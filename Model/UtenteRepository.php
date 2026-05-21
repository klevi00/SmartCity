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

    public function aggiorna(int $id, array $data): void
    {
        $stmt = $this->pdo->prepare(
            'UPDATE utenti
         SET nome = :nome,
             cognome = :cognome,
             telefono = :telefono,
             bio = :bio,
             auto = :auto,
             num_patente = :num_patente
         WHERE id = :id'
        );
        $stmt->execute([
            ':nome'         => trim($data['nome']),
            ':cognome'      => trim($data['cognome']),
            ':telefono'     => trim($data['telefono'] ?? ''),
            ':bio'          => trim($data['bio'] ?? ''),
            ':auto'         => trim($data['auto'] ?? ''),
            ':num_patente'  => trim($data['num_patente'] ?? ''),
            ':id'           => $id,
        ]);
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

    public function getVotoMedio(int $utente_id): float
    {
        $stmt = $this -> pdo -> prepare(
            'SELECT AVG(r.voto)
            FROM recensioni r
            WHERE r.destinatario_id = :id
            GROUP BY r.destinatario_id'
        );
        $stmt->execute([':id' => $utente_id]);
        $result = $stmt->fetchColumn();
        return $result !== false ? (float) $result : 0.0;
    }

    public function getNumRecensioni(int $utente_id) : int 
    {
        $stmt = $this -> pdo -> prepare(
            'SELECT COUNT(*)
            FROM recensioni r
            WHERE r.destinatario_id = :id
            GROUP BY r.destinatario_id'
        );
        $stmt->execute([':id' => $utente_id]);
        $result = $stmt->fetchColumn();
        return $result !== false ? (int) $result : 0;

    }
}
