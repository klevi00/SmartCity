-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Feb 12, 2026 alle 11:25
-- Versione del server: 10.4.32-MariaDB
-- Versione PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `blablacar`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `autista`
--

CREATE TABLE `autista` (
  `idAutista` int(11) NOT NULL,
  `nome` varchar(15) NOT NULL,
  `cognome` varchar(15) NOT NULL,
  `dataNascita` date NOT NULL,
  `numeroPatente` varchar(12) NOT NULL,
  `scadenzaPatente` date NOT NULL,
  `casaAutomobilistica` varchar(20) NOT NULL,
  `modello` varchar(20) NOT NULL,
  `targa` varchar(7) NOT NULL,
  `annoImmatricolazione` int(11) NOT NULL,
  `numeroTelefono` varchar(10) NOT NULL,
  `email` varchar(50) NOT NULL,
  `fotografia` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `feedbackautista`
--

CREATE TABLE `feedbackautista` (
  `idAutista` int(11) NOT NULL,
  `idPasseggero` int(11) NOT NULL,
  `idFeedback` int(11) NOT NULL,
  `valutazione` int(11) NOT NULL,
  `giudizio` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `feedbackpasseggero`
--

CREATE TABLE `feedbackpasseggero` (
  `idAutista` int(11) NOT NULL,
  `idPasseggero` int(11) NOT NULL,
  `idFeedback` int(11) NOT NULL,
  `valutazione` int(11) NOT NULL,
  `giudizio` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `passeggero`
--

CREATE TABLE `passeggero` (
  `idPasseggero` int(11) NOT NULL,
  `nome` varchar(20) NOT NULL,
  `cognome` varchar(20) NOT NULL,
  `numeroSerieCartaIdentita` varchar(9) NOT NULL,
  `numeroTelefono` varchar(10) NOT NULL,
  `email` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `prenotazione`
--

CREATE TABLE `prenotazione` (
  `idPasseggero` int(11) NOT NULL,
  `idViaggio` int(11) NOT NULL,
  `dataOraPrenotazione` datetime NOT NULL,
  `stato` enum('accettata','rifiutata','inElaborazione') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `viaggio`
--

CREATE TABLE `viaggio` (
  `idViaggio` int(11) NOT NULL,
  `cittaPartenza` int(11) NOT NULL,
  `cittaDestinazione` int(11) NOT NULL,
  `dataOraPartenza` datetime NOT NULL,
  `costo` double NOT NULL,
  `tempo` time NOT NULL,
  `idAutista` int(11) NOT NULL,
  `pieno` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `autista`
--
ALTER TABLE `autista`
  ADD PRIMARY KEY (`idAutista`);

--
-- Indici per le tabelle `feedbackautista`
--
ALTER TABLE `feedbackautista`
  ADD PRIMARY KEY (`idFeedback`),
  ADD KEY `idAutista` (`idAutista`),
  ADD KEY `idPasseggero` (`idPasseggero`);

--
-- Indici per le tabelle `feedbackpasseggero`
--
ALTER TABLE `feedbackpasseggero`
  ADD PRIMARY KEY (`idFeedback`),
  ADD KEY `idAutista` (`idAutista`),
  ADD KEY `idPasseggero` (`idPasseggero`);

--
-- Indici per le tabelle `passeggero`
--
ALTER TABLE `passeggero`
  ADD PRIMARY KEY (`idPasseggero`);

--
-- Indici per le tabelle `prenotazione`
--
ALTER TABLE `prenotazione`
  ADD PRIMARY KEY (`idPasseggero`,`idViaggio`),
  ADD KEY `idViaggio` (`idViaggio`);

--
-- Indici per le tabelle `viaggio`
--
ALTER TABLE `viaggio`
  ADD PRIMARY KEY (`idViaggio`),
  ADD KEY `idAutista` (`idAutista`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `autista`
--
ALTER TABLE `autista`
  MODIFY `idAutista` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `feedbackautista`
--
ALTER TABLE `feedbackautista`
  MODIFY `idFeedback` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `feedbackpasseggero`
--
ALTER TABLE `feedbackpasseggero`
  MODIFY `idFeedback` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `passeggero`
--
ALTER TABLE `passeggero`
  MODIFY `idPasseggero` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `viaggio`
--
ALTER TABLE `viaggio`
  MODIFY `idViaggio` int(11) NOT NULL AUTO_INCREMENT;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `feedbackautista`
--
ALTER TABLE `feedbackautista`
  ADD CONSTRAINT `feedbackautista_ibfk_1` FOREIGN KEY (`idAutista`) REFERENCES `autista` (`idAutista`),
  ADD CONSTRAINT `feedbackautista_ibfk_2` FOREIGN KEY (`idPasseggero`) REFERENCES `passeggero` (`idPasseggero`);

--
-- Limiti per la tabella `feedbackpasseggero`
--
ALTER TABLE `feedbackpasseggero`
  ADD CONSTRAINT `feedbackpasseggero_ibfk_1` FOREIGN KEY (`idAutista`) REFERENCES `autista` (`idAutista`),
  ADD CONSTRAINT `feedbackpasseggero_ibfk_2` FOREIGN KEY (`idPasseggero`) REFERENCES `passeggero` (`idPasseggero`);

--
-- Limiti per la tabella `prenotazione`
--
ALTER TABLE `prenotazione`
  ADD CONSTRAINT `prenotazione_ibfk_1` FOREIGN KEY (`idPasseggero`) REFERENCES `passeggero` (`idPasseggero`),
  ADD CONSTRAINT `prenotazione_ibfk_2` FOREIGN KEY (`idViaggio`) REFERENCES `viaggio` (`idViaggio`);

--
-- Limiti per la tabella `viaggio`
--
ALTER TABLE `viaggio`
  ADD CONSTRAINT `viaggio_ibfk_1` FOREIGN KEY (`idAutista`) REFERENCES `autista` (`idAutista`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
