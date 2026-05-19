<?php

namespace Controller;

use Model\UtenteRepository;
use Model\ViaggioRepository;
use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

class UtenteController
{
    public function __construct(private ContainerInterface $container) {}

    public function accedi(Request $request, Response $response, array $args): Response
    {
        if (isset($_SESSION['utente_id'])) {
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/');
        }
        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('accedi', ['errore' => null]));
        return $response;
    }

    public function login(Request $request, Response $response, array $args): Response
    {
        $body  = (array) $request->getParsedBody();
        $email = strtolower(trim($body['email'] ?? ''));
        $pass  = $body['password'] ?? '';

        $repo   = new UtenteRepository();
        $utente = $repo->findByEmail($email);

        if ($utente && password_verify($pass, $utente['password'])) {
            $_SESSION['utente_id']   = $utente['id'];
            $_SESSION['utente_nome'] = $utente['nome'];
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/');
        }

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('accedi', [
            'errore' => 'Email o password non corretti.',
        ]));
        return $response;
    }

    public function logout(Request $request, Response $response, array $args): Response
    {
        session_destroy();
        return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/');
    }

    public function registrati(Request $request, Response $response, array $args): Response
    {
        if (isset($_SESSION['utente_id'])) {
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/');
        }
        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('registrati', ['errori' => [], 'dati' => []]));
        return $response;
    }

    public function registra(Request $request, Response $response, array $args): Response
    {
        $body   = (array) $request->getParsedBody();
        $errori = $this->validaRegistrazione($body);

        $repo = new UtenteRepository();
        if (empty($errori) && $repo->findByEmail(strtolower(trim($body['email'] ?? '')))) {
            $errori['email'] = 'Questa email è già registrata.';
        }

        if (!empty($errori)) {
            $engine = $this->container->get('template');
            $response->getBody()->write($engine->render('registrati', [
                'errori' => $errori,
                'dati'   => $body,
            ]));
            return $response;
        }

        $id = $repo->registra($body);
        $_SESSION['utente_id']   = $id;
        $_SESSION['utente_nome'] = trim($body['nome']);
        return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/');
    }

    public function profilo(Request $request, Response $response, array $args): Response
    {
        $repo   = new UtenteRepository();
        $utente = $repo->findById((int) $args['id']);
        if (!$utente) {
            throw new \Slim\Exception\HttpNotFoundException($request);
        }
        $recensioni = $repo->getRecensioni($utente['id']);
        $voto_medio = $repo->getVotoMedio($utente['id']);
        $num_recensioni = $repo->getNumRecensioni($utente['id']);
        $vrepo  = new ViaggioRepository();
        $viaggi = $vrepo->findByAutista($utente['id']);

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('profilo', [
            'utente'    => $utente,
            'recensioni'=> $recensioni,
            'num_recensioni'=> $num_recensioni,
            'voto_medio' => $voto_medio,
            'viaggi'    => array_slice($viaggi, 0, 4),
        ]));
        return $response;
    }

    public function mieiViaggi(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            $_SESSION['flash'] = 'Accedi per poter visualizzare i tuoi viaggi.';

            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }
        $uid   = $_SESSION['utente_id'];
        $vrepo = new ViaggioRepository();
        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('miei-viaggi', [
            'viaggi_autista'    => $vrepo->findByAutista($uid),
            'viaggi_passeggero' => $vrepo->findByPasseggero($uid),
        ]));
        return $response;
    }

    public function messaggi(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            $_SESSION['flash'] = 'Accedi per poter visualizzare le tue chat.';

            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }
        $uid   = $_SESSION['utente_id'];
        $repo  = new UtenteRepository();

        $altro_id = isset($args['id']) ? (int) $args['id'] : null;
        $conversazioni = $repo->getConversazioni($uid);
        $messaggi = [];
        $altro = null;
        if ($altro_id) {
            $messaggi = $repo->getMessaggi($uid, $altro_id);
            $altro    = $repo->findById($altro_id);
        } elseif (!empty($conversazioni)) {
            $altro_id = $conversazioni[0]['id'];
            $messaggi = $repo->getMessaggi($uid, $altro_id);
            $altro    = $repo->findById($altro_id);
        }

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('messaggi', [
            'conversazioni' => $conversazioni,
            'messaggi'      => $messaggi,
            'altro'         => $altro,
            'altro_id'      => $altro_id,
        ]));
        return $response;
    }

    public function inviaMessaggio(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            $_SESSION['flash'] = 'Accedi per poter inviare un viaggio.';

            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }
        $body = (array) $request->getParsedBody();
        $testo = trim($body['testo'] ?? '');
        $dest_id = (int) $args['id'];
        if ($testo !== '' && $dest_id > 0) {
            $repo = new UtenteRepository();
            $repo->inviaMessaggio($_SESSION['utente_id'], $dest_id, $testo);
        }
        return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/messaggi/' . $dest_id);
    }

    private function validaRegistrazione(array $d): array
    {
        $errori = [];
        if (empty(trim($d['nome'] ?? '')))    $errori['nome']    = 'Inserisci il tuo nome.';
        if (empty(trim($d['cognome'] ?? ''))) $errori['cognome'] = 'Inserisci il tuo cognome.';
        if (!filter_var($d['email'] ?? '', FILTER_VALIDATE_EMAIL)) $errori['email'] = 'Email non valida.';
        if (strlen($d['password'] ?? '') < 8) $errori['password'] = 'La password deve avere almeno 8 caratteri.';
        if (($d['password'] ?? '') !== ($d['password2'] ?? '')) $errori['password2'] = 'Le password non coincidono.';
        return $errori;
    }

    public function modificaProfilo(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            $_SESSION['flash'] = 'Accedi per poter modificare il tuo profilo.';
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }
        // Impedisce di modificare il profilo di altri utenti
        if ((int) $args['id'] !== (int) $_SESSION['utente_id']) {
            return $response->withStatus(403);
        }

        $repo   = new UtenteRepository();
        $utente = $repo->findById((int) $args['id']);

        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('modifica-profilo', [
            'utente' => $utente,
            'errori' => [],
        ]));
        return $response;
    }

    public function aggiornaProfilo(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            $_SESSION['flash'] = 'Accedi per poter modificare il tuo profilo.';
            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }
        if ((int) $args['id'] !== (int) $_SESSION['utente_id']) {
            return $response->withStatus(403);
        }

        $body   = (array) $request->getParsedBody();
        $errori = $this->validaModifica($body);

        if (!empty($errori)) {
            $engine = $this->container->get('template');
            $response->getBody()->write($engine->render('modifica-profilo', [
                'utente' => array_merge($body, ['id' => $args['id']]),
                'errori' => $errori,
            ]));
            return $response;
        }

        $repo = new UtenteRepository();
        $repo->aggiorna((int) $args['id'], $body);

        // Aggiorna il nome in sessione se l'utente ha cambiato il proprio profilo
        $_SESSION['utente_nome'] = trim($body['nome']);

        return $response->withStatus(302)
            ->withHeader('Location', BASE_PATH . '/profilo/' . $args['id']);
    }

    private function validaModifica(array $d): array
    {
        $errori = [];
        if (empty(trim($d['nome'] ?? '')))    $errori['nome']    = 'Inserisci il tuo nome.';
        if (empty(trim($d['cognome'] ?? ''))) $errori['cognome'] = 'Inserisci il tuo cognome.';
        if (isset($d['num_patente']) && $d['num_patente'] !== '' &&
            !preg_match('/^[A-Z0-9]{1,10}$/i', $d['num_patente'])) {
            $errori['num_patente'] = 'Numero di patente non valido.';
        }
        return $errori;
    }
}


