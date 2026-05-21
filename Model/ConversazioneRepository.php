<?php

namespace Model;

use PDO;
use Util\Connection;

class ConversazioneRepository
{
    private PDO $pdo;

    public function __construct()
    {
        $this->pdo = Connection::getInstance();
    }

    public function getConversazioni(int $utente_id): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT
                u.id, u.nome, u.cognome,
                m.testo AS ultimo_messaggio,
                m.created_at AS ultimo_at,
                m.mittente_id,
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

    public function inviaMessaggio(int $mittente_id, int $destinatario_id, string $testo): void
    {
        $stmt = $this->pdo->prepare(
            'INSERT INTO messaggi (mittente_id, destinatario_id, testo)
             VALUES (:mid, :did, :testo)'
        );
        $stmt->execute([
            ':mid'   => $mittente_id,
            ':did'   => $destinatario_id,
            ':testo' => trim($testo),
        ]);
    }

    public function getMessaggiDopo(int $utente_id, int $altro_id, int $last_id): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT m.id, m.mittente_id, m.destinatario_id, m.testo,
                DATE_FORMAT(m.created_at, "%Y-%m-%d %H:%i:%s") AS created_at,
                u.nome AS mittente_nome
         FROM messaggi m
         JOIN utenti u ON u.id = m.mittente_id
         WHERE ((m.mittente_id = :uid AND m.destinatario_id = :aid)
             OR (m.mittente_id = :aid AND m.destinatario_id = :uid))
           AND m.id > :last_id
         ORDER BY m.created_at ASC'
        );
        $stmt->execute([':uid' => $utente_id, ':aid' => $altro_id, ':last_id' => $last_id]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
}
