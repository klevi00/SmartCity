<?php

namespace Model;

use PDO;
use Util\Connection;

class ViaggioRepository
{
    private PDO $pdo;

    public function __construct()
    {
        $this->pdo = Connection::getInstance();
    }

    public function cerca(string $partenza, string $arrivo, string $data, int $posti = 1): array
    {
        $sql = 'SELECT v.*, u.nome, u.cognome, u.voto_medio, u.num_recensioni, u.auto_marca, u.auto_modello, u.auto_colore
                FROM viaggi v
                JOIN utenti u ON v.autista_id = u.id
                WHERE v.stato = :stato AND v.posti_disponibili >= :posti';

        $params = [':stato' => 'attivo', ':posti' => $posti];

        if (!empty($data) && \DateTime::createFromFormat('Y-m-d', $data) !== false) {
            $sql .= ' AND v.data_partenza = :data';
            $params[':data'] = $data;
        }

        if ($partenza !== '') {
            $sql .= ' AND v.partenza LIKE :partenza';
            $params[':partenza'] = "%$partenza%";
        }
        if ($arrivo !== '') {
            $sql .= ' AND v.arrivo LIKE :arrivo';
            $params[':arrivo'] = "%$arrivo%";
        }

        $sql .= ' ORDER BY v.ora_partenza ASC';
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll();
    }

    public function findById(int $id): ?array
    {
        $stmt = $this->pdo->prepare(
            'SELECT v.*, u.nome, u.cognome, u.voto_medio, u.num_recensioni,
                    u.auto_marca, u.auto_modello, u.auto_colore, u.bio, u.id AS utente_id
             FROM viaggi v
             JOIN utenti u ON v.autista_id = u.id
             WHERE v.id = :id'
        );
        $stmt->execute([':id' => $id]);
        return $stmt->fetch() ?: null;
    }

    public function findByAutista(int $autista_id): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT v.*,
                    (SELECT COUNT(*) FROM prenotazioni p WHERE p.viaggio_id = v.id AND p.stato = "confermata") AS num_prenotazioni
             FROM viaggi v
             WHERE v.autista_id = :id
             ORDER BY v.data_partenza DESC, v.ora_partenza DESC'
        );
        $stmt->execute([':id' => $autista_id]);
        return $stmt->fetchAll();
    }

    public function findByPasseggero(int $passeggero_id): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT v.*, u.nome AS autista_nome, u.cognome AS autista_cognome,
                    u.voto_medio, u.auto_marca, u.auto_modello,
                    p.stato AS stato_prenotazione, p.posti AS posti_prenotati
             FROM prenotazioni p
             JOIN viaggi v ON v.id = p.viaggio_id
             JOIN utenti u ON u.id = v.autista_id
             WHERE p.passeggero_id = :id
             ORDER BY v.data_partenza DESC'
        );
        $stmt->execute([':id' => $passeggero_id]);
        return $stmt->fetchAll();
    }

    public function findRecenti(int $limit = 6): array
    {
        $stmt = $this->pdo->prepare(
            'SELECT v.*, u.nome, u.cognome, u.voto_medio, u.auto_marca, u.auto_modello
             FROM viaggi v
             JOIN utenti u ON v.autista_id = u.id
             WHERE v.stato = "attivo" AND v.data_partenza >= CURDATE() AND v.posti_disponibili > 0
             ORDER BY v.data_partenza ASC, v.created_at DESC
             LIMIT :lim'
        );
        $stmt->bindValue(':lim', $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    public function inserisci(array $d): int
    {
        $stmt = $this->pdo->prepare(
            'INSERT INTO viaggi
                (autista_id, partenza, arrivo, data_partenza, ora_partenza,
                 posti_totali, posti_disponibili, prezzo, note, no_fumo, no_animali, solo_donne)
             VALUES
                (:autista_id, :partenza, :arrivo, :data_partenza, :ora_partenza,
                 :posti_totali, :posti_totali, :prezzo, :note, :no_fumo, :no_animali, :solo_donne)'
        );
        $stmt->execute([
            ':autista_id'    => $d['autista_id'],
            ':partenza'      => trim($d['partenza']),
            ':arrivo'        => trim($d['arrivo']),
            ':data_partenza' => $d['data_partenza'],
            ':ora_partenza'  => $d['ora_partenza'],
            ':posti_totali'  => (int) $d['posti_totali'],
            ':prezzo'        => (float) $d['prezzo'],
            ':note'          => trim($d['note'] ?? ''),
            ':no_fumo'       => isset($d['no_fumo']) ? 1 : 0,
            ':no_animali'    => isset($d['no_animali']) ? 1 : 0,
            ':solo_donne'    => isset($d['solo_donne']) ? 1 : 0,
        ]);
        return (int) $this->pdo->lastInsertId();
    }

    public function cancella(int $id, int $autista_id): bool
    {
        $stmt = $this->pdo->prepare(
            'UPDATE viaggi SET stato = "cancellato" WHERE id = :id AND autista_id = :aid'
        );
        $stmt->execute([':id' => $id, ':aid' => $autista_id]);
        return $stmt->rowCount() > 0;
    }
}
