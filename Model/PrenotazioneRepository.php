<?php

namespace Model;

use PDO;
use Util\Connection;

class PrenotazioneRepository
{
    private PDO $pdo;

    public function __construct()
    {
        $this->pdo = Connection::getInstance();
    }

    public function esistePrenotazione(int $viaggio_id, int $passeggero_id): bool
    {
        $stmt = $this->pdo->prepare(
            "SELECT id FROM prenotazioni WHERE viaggio_id = :v AND passeggero_id = :p AND stato != 'cancellata'"
        );
        $stmt->execute([':v' => $viaggio_id, ':p' => $passeggero_id]);
        return $stmt->fetch() !== false;
    }

    public function prenota(int $viaggio_id, int $passeggero_id, int $posti = 1): bool
    {
        try {
            $this->pdo->beginTransaction();

            $stmt = $this->pdo->prepare(
                'INSERT INTO prenotazioni (viaggio_id, passeggero_id, posti) VALUES (:v, :p, :posti)'
            );
            $stmt->execute([':v' => $viaggio_id, ':p' => $passeggero_id, ':posti' => $posti]);

            $upd = $this->pdo->prepare(
                'UPDATE viaggi SET posti_disponibili = posti_disponibili - :posti
                 WHERE id = :v AND posti_disponibili >= :posti AND stato = "attivo"'
            );
            $upd->execute([':posti' => $posti, ':v' => $viaggio_id]);

            if ($upd->rowCount() === 0) {
                $this->pdo->rollBack();
                return false;
            }

            $this->pdo->commit();
            return true;
        } catch (\Exception) {
            $this->pdo->rollBack();
            return false;
        }
    }

    public function getPasseggeri(int $viaggio_id): array
    {
        $stmt = $this->pdo->prepare(
            "SELECT p.*, u.nome, u.cognome, u.voto_medio
             FROM prenotazioni p
             JOIN utenti u ON u.id = p.passeggero_id
             WHERE p.viaggio_id = :v AND p.stato = 'confermata'"
        );
        $stmt->execute([':v' => $viaggio_id]);
        return $stmt->fetchAll();
    }
}
