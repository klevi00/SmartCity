<?php

namespace Controller;

use Model\ViaggioRepository;
use Model\UtenteRepository;
use Model\PrenotazioneRepository;
use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

class ViaggioController
{
    public function __construct(private ContainerInterface $container) {}

    public function cerca(Request $request, Response $response, array $args): Response
    {
        $q = $request->getQueryParams();
        $partenza = trim($q['da'] ?? '');
        $arrivo   = trim($q['a'] ?? '');
        $data     = trim($q['data'] ?? '');
        $posti    = max(1, (int)($q['posti'] ?? 1));

        $repo = new ViaggioRepository();
        $viaggi = [];
        
        $viaggi = $repo->cerca($partenza, $arrivo, $data, $posti);
        

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('cerca', [
            'viaggi'   => $viaggi,
            'partenza' => $partenza,
            'arrivo'   => $arrivo,
            'data'     => $data,
            'posti'    => $posti,
        ]));
        return $response;
    }

    public function show(Request $request, Response $response, array $args): Response
    {
        $repo = new ViaggioRepository();
        $utente_repo = new UtenteRepository();
        $viaggio = $repo->findById((int) $args['id']);

        if (!$viaggio) {
            throw new \Slim\Exception\HttpNotFoundException($request);
        }

        $prenotazioneRepo = new PrenotazioneRepository();
        $gia_prenotato = false;
        $passeggeri = $prenotazioneRepo->getPasseggeri($viaggio['id']);
        $voto_medio = $utente_repo->getVotoMedio($viaggio['autista_id']);
        $num_recensioni = $utente_repo->getNumRecensioni($viaggio['autista_id']);

        if (isset($_SESSION['utente_id'])) {
            $gia_prenotato = $prenotazioneRepo->esistePrenotazione(
                $viaggio['id'],
                $_SESSION['utente_id']
            );
        }

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('viaggio', [
            'viaggio'        => $viaggio,
            'gia_prenotato'  => $gia_prenotato,
            'passeggeri'     => $passeggeri,
            'voto_medio'     => $voto_medio,
            'num_recensioni' => $num_recensioni,
        ]));
        return $response;
    }

    public function prenota(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }

        $viaggio_id = (int) $args['id'];
        $repo = new PrenotazioneRepository();
        $vrepo = new ViaggioRepository();
        $viaggio = $vrepo->findById($viaggio_id);

        if (!$viaggio) {
            throw new \Slim\Exception\HttpNotFoundException($request);
        }

        if ($viaggio['autista_id'] == $_SESSION['utente_id']) {
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/viaggio/' . $viaggio_id . '?err=autista');
        }

        $ok = $repo->prenota($viaggio_id, $_SESSION['utente_id']);
        $dest = BASE_PATH . '/viaggio/' . $viaggio_id . ($ok ? '?ok=1' : '?err=posti');
        return $response->withStatus(302)->withHeader('Location', $dest);
    }

    public function pubblica(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }

        $repoUtente = new UtenteRepository();
        $utente = $repoUtente->findById($_SESSION['utente_id']);
        if(empty($utente['num_patente']) || empty($utente['auto'])){
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/profilo/' . $_SESSION['utente_id']);
        }

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('pubblica', [
            'errori' => [],
            'dati'   => [],
        ]));
        return $response;
    }

    public function salvaViaggio(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }

        $body = (array) $request->getParsedBody();
        $errori = $this->validaViaggio($body);

        if (!empty($errori)) {
            $engine = $this->container->get('template');
            $response->getBody()->write($engine->render('pubblica', [
                'errori' => $errori,
                'dati'   => $body,
            ]));
            return $response;
        }

        $body['autista_id'] = $_SESSION['utente_id'];
        $repo = new ViaggioRepository();
        $id = $repo->inserisci($body);

        return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/viaggio/' . $id . '?nuovo=1');
    }

    public function cancella(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }
        $repo = new ViaggioRepository();
        $repo->cancella((int) $args['id'], $_SESSION['utente_id']);
        return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/miei-viaggi');
    }

    private function validaViaggio(array $d): array
    {
        $errori = [];
        if (empty(trim($d['partenza'] ?? ''))) $errori['partenza'] = 'Inserisci la città di partenza.';
        if (empty(trim($d['arrivo'] ?? '')))   $errori['arrivo']   = 'Inserisci la città di arrivo.';
        if (empty($d['data_partenza']))         $errori['data_partenza'] = 'Inserisci la data.';
        if (empty($d['ora_partenza']))          $errori['ora_partenza']  = 'Inserisci l\'orario.';
        if (!isset($d['posti_totali']) || (int)$d['posti_totali'] < 1) $errori['posti_totali'] = 'Almeno 1 posto.';
        if (!isset($d['prezzo']) || (float)$d['prezzo'] <= 0) $errori['prezzo'] = 'Inserisci un prezzo valido.';
        if (isset($d['data_partenza']) && $d['data_partenza'] < date('Y-m-d')) {
            $errori['data_partenza'] = 'La data non può essere nel passato.';
        }
        return $errori;
    }
}
