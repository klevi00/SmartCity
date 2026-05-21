-- Tragitto Carpooling — Schema del database
-- Eseguire in phpMyAdmin o MySQL CLI

CREATE DATABASE IF NOT EXISTS tragitto CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tragitto;

CREATE TABLE utenti (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL,
    email VARCHAR(200) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    bio TEXT,
    auto VARCHAR(255),
    num_patente VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE viaggi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    autista_id INT NOT NULL,
    partenza VARCHAR(200) NOT NULL,
    arrivo VARCHAR(200) NOT NULL,
    data_partenza DATE NOT NULL,
    ora_partenza TIME NOT NULL,
    posti_totali INT NOT NULL DEFAULT 3,
    posti_disponibili INT NOT NULL DEFAULT 3,
    prezzo DECIMAL(8,2) NOT NULL,
    note TEXT,
    no_fumo TINYINT DEFAULT 0,
    no_animali TINYINT DEFAULT 0,
    solo_donne TINYINT DEFAULT 0,
    stato ENUM('attivo','cancellato','completato') DEFAULT 'attivo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (autista_id) REFERENCES utenti(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE prenotazioni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    viaggio_id INT NOT NULL,
    passeggero_id INT NOT NULL,
    posti INT DEFAULT 1,
    stato ENUM('in_attesa','confermata','cancellata') DEFAULT 'confermata',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (viaggio_id) REFERENCES viaggi(id) ON DELETE CASCADE,
    FOREIGN KEY (passeggero_id) REFERENCES utenti(id) ON DELETE CASCADE,
    UNIQUE KEY uq_prenotazione (viaggio_id, passeggero_id)
) ENGINE=InnoDB;

CREATE TABLE recensioni (
    id INT AUTO_INCREMENT PRIMARY KEY,
    autore_id INT NOT NULL,
    destinatario_id INT NOT NULL,
    viaggio_id INT NOT NULL,
    voto INT NOT NULL CHECK (voto BETWEEN 1 AND 5),
    commento TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (autore_id) REFERENCES utenti(id),
    FOREIGN KEY (destinatario_id) REFERENCES utenti(id),
    FOREIGN KEY (viaggio_id) REFERENCES viaggi(id)
) ENGINE=InnoDB;

CREATE TABLE messaggi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mittente_id INT NOT NULL,
    destinatario_id INT NOT NULL,
    viaggio_id INT,
    testo TEXT NOT NULL,
    letto TINYINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (mittente_id) REFERENCES utenti(id),
    FOREIGN KEY (destinatario_id) REFERENCES utenti(id)
) ENGINE=InnoDB;

-- Dati di esempio (password: "password" per tutti)
INSERT INTO utenti (nome, cognome, email, password, telefono, bio, auto, num_patente) VALUES
('Marco', 'Rossi', 'marco@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '333 1234567', 'Autista esperto, puntuale e comunicativo. Amo i viaggi in compagnia!', 'Volkswagen Golf Nero', "AB123GF456", "M"),
('Giulia', 'Marino', 'giulia@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '347 9876543', 'Studentessa universitaria, viaggio spesso tra Milano e Bologna.', 'Fiat 500 Bianco', "AB123GF456", "F"),
('Luca', 'Ferrari', 'luca@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', '328 5551234', 'Manager, viaggio per lavoro tutti i lunedì. Wi-Fi a bordo!', 'BMW M4 Competition Blu Mezzanotte', "AB123GF456", "M");

INSERT INTO viaggi (autista_id, partenza, arrivo, data_partenza, ora_partenza, posti_totali, posti_disponibili, prezzo, note, no_fumo) VALUES
(1, 'Milano', 'Bologna', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '07:30:00', 3, 2, 18.00, 'Partenza da Lampugnano P1. Aria condizionata, musica soft.', 1),
(1, 'Bologna', 'Roma', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '08:00:00', 3, 3, 35.00, 'Sosta autogrill A1. Portate snack!', 1),
(3, 'Milano', 'Torino', DATE_ADD(CURDATE(), INTERVAL 1 DAY), '07:00:00', 4, 3, 15.00, 'Wi-Fi a bordo, puntuale garantito.', 1),
(2, 'Milano', 'Firenze', DATE_ADD(CURDATE(), INTERVAL 3 DAY), '09:15:00', 2, 1, 28.00, 'Solo donne. Musica italiana degli anni 90.', 1),
(3, 'Torino', 'Milano', DATE_ADD(CURDATE(), INTERVAL 2 DAY), '17:00:00', 4, 4, 15.00, 'Ritorno da Torino, partenza Porta Nuova.', 0),
(1, 'Milano', 'Venezia', DATE_ADD(CURDATE(), INTERVAL 4 DAY), '06:45:00', 3, 2, 22.00, 'Parcheggio Mestre o direttamente a Venezia.', 1);

INSERT INTO recensioni (autore_id, destinatario_id, viaggio_id, voto, commento) VALUES
(2, 1, 1, 5, 'Marco è un autista eccellente! Puntuale, gentile e guida in modo sicuro. Consigliatissimo!'),
(3, 1, 1, 5, 'Ottimo viaggio, macchina pulita e musica giusta. Lo riprenoterei subito.'),
(1, 3, 3, 5, 'Luca è super professionale, Wi-Fi funzionante e partenza puntuale. Top!');


