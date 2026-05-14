<?php

namespace Model;

use PDO;
use Util\Connection;

class UtenteRepository
{
    private PDO $pdo;

    public function __construct()
    {
        $this->pdo = Connection::getInstance();
    }


    public function findByEmail(string $email): ?array
    {
        $stmt = $this->pdo->prepare('SELECT * FROM utenti WHERE email = :email');
        $stmt->execute([':email' => $email]);
        return $stmt->fetch() ?: null;
    }

    public function findById(int $id): ?array
    {
        $stmt = $this->pdo->prepare('SELECT * FROM utenti WHERE id = :id');
        $stmt->execute([':id' => $id]);
        return $stmt->fetch() ?: null;
    }

    public function registra(array $data): int
    {
        $stmt = $this->pdo->prepare(
            'INSERT INTO utenti (nome, cognome, email, password, telefono, bio, auto, num_patente)
             VALUES (:nome, :cognome, :email, :password, :telefono, :bio, :auto, :num_patente)'
        );
        $stmt->execute([
            ':nome'     => trim($data['nome']),
            ':cognome'  => trim($data['cognome']),
            ':email'    => strtolower(trim($data['email'])),
            ':password' => password_hash($data['password'], PASSWORD_DEFAULT),
            ':telefono' => trim($data['telefono']),
            ':bio' => trim($data['bio'] ?? ''),
            ':auto' => trim($data['auto'] ?? ''),
            ':num_patente' => trim($data['num_patente'] ?? ''),
        ]);
        return (int) $this->pdo->lastInsertId();
    }

    public function getRecensioni(int $utente_id): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT r.*, u.nome AS autore_nome, u.cognome AS autore_cognome
             FROM recensioni r
             JOIN utenti u ON u.id = r.autore_id
             WHERE r.destinatario_id = :id
             ORDER BY r.created_at DESC
             LIMIT 20'
        );
        $stmt->execute([':id' => $utente_id]);
        return $stmt->fetchAll();
    }

    public function getConversazioni(int $utente_id): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT
                u.id, u.nome, u.cognome,
                m.testo AS ultimo_messaggio,
                m.created_at AS ultimo_at,
                m.mittente_id,
                m.viaggio_id,
                (SELECT COUNT(*) FROM messaggi m2
                 WHERE m2.destinatario_id = :uid AND m2.mittente_id = u.id AND m2.letto = 0) AS non_letti
             FROM (
                SELECT IF(mittente_id = :uid, destinatario_id, mittente_id) AS altro_id,
                       MAX(id) AS ultimo_id
                FROM messaggi
                WHERE mittente_id = :uid OR destinatario_id = :uid
                GROUP BY altro_id
             ) sub
             JOIN messaggi m ON m.id = sub.ultimo_id
             JOIN utenti u ON u.id = sub.altro_id
             ORDER BY m.created_at DESC'
        );
        $stmt->execute([':uid' => $utente_id]);
        return $stmt->fetchAll();
    }

    public function getMessaggi(int $utente_id, int $altro_id): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT m.*, u.nome AS mittente_nome
             FROM messaggi m
             JOIN utenti u ON u.id = m.mittente_id
             WHERE (m.mittente_id = :uid AND m.destinatario_id = :aid)
                OR (m.mittente_id = :aid AND m.destinatario_id = :uid)
             ORDER BY m.created_at ASC'
        );
        $stmt->execute([':uid' => $utente_id, ':aid' => $altro_id]);
        $this->pdo->prepare(
            'UPDATE messaggi SET letto = 1 WHERE destinatario_id = :uid AND mittente_id = :aid AND letto = 0'
        )->execute([':uid' => $utente_id, ':aid' => $altro_id]);
        return $stmt->fetchAll();
    }

    public function inviaMessaggio(int $mittente_id, int $destinatario_id, string $testo, ?int $viaggio_id = null): void
    {
        $stmt = $this->pdo->prepare(
            'INSERT INTO messaggi (mittente_id, destinatario_id, viaggio_id, testo)
             VALUES (:mid, :did, :vid, :testo)'
        );
        $stmt->execute([
            ':mid'   => $mittente_id,
            ':did'   => $destinatario_id,
            ':vid'   => $viaggio_id,
            ':testo' => trim($testo),
        ]);
    }
}
