<?php

namespace Controller;

use Model\ConversazioneRepository;
use Model\UtenteRepository;
use Model\ViaggioRepository;
use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

class ConversazioneController
{
    public function __construct(private ContainerInterface $container) {}

    public function messaggi(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            $_SESSION['flash'] = 'Accedi per poter visualizzare le tue chat.';

            return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/accedi');
        }
        $uid   = $_SESSION['utente_id'];
        $conv_repo  = new ConversazioneRepository();
        $utente_repo  = new UtenteRepository();

        $altro_id = isset($args['id']) ? (int) $args['id'] : null;
        $conversazioni = $conv_repo->getConversazioni($uid);
        $messaggi = [];
        $altro = null;
        if ($altro_id) {
            $messaggi = $conv_repo->getMessaggi($uid, $altro_id);
            $altro    = $utente_repo->findById($altro_id);
        } elseif (!empty($conversazioni)) {
            $altro_id = $conversazioni[0]['id'];
            $messaggi = $conv_repo->getMessaggi($uid, $altro_id);
            $altro    = $utente_repo->findById($altro_id);
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
            $repo = new ConversazioneRepository();
            $repo->inviaMessaggio($_SESSION['utente_id'], $dest_id, $testo);
        }
        return $response->withStatus(302)->withHeader('Location', BASE_PATH . '/messaggi/' . $dest_id);
    }

    public function stream(Request $request, Response $response, array $args): Response
    {
        if (!isset($_SESSION['utente_id'])) {
            return $response->withStatus(403);
        }

        $uid      = (int) $_SESSION['utente_id'];
        $altro_id = (int) $args['id'];
        $params   = $request->getQueryParams();
        $last_id  = (int) ($params['last_id'] ?? 0);

        $repo = new ConversazioneRepository();

        // FONDAMENTALE: rilascia il lock del file di sessione.
        // Senza questo, finché lo stream è aperto il browser
        // non può fare altre richieste (es. inviare messaggi).
        session_write_close();

        // Headers SSE
        header('Content-Type: text/event-stream');
        header('Cache-Control: no-cache');
        header('X-Accel-Buffering: no'); // necessario se usi Nginx

        // Disabilita il limite di tempo di esecuzione PHP
        set_time_limit(0);

        while (true) {
            $nuovi = $repo->getMessaggiDopo($uid, $altro_id, $last_id);

            foreach ($nuovi as $msg) {
                echo "data: " . json_encode($msg) . "\n\n";
                $last_id = (int) $msg['id'];
            }

            ob_flush();
            flush();
            sleep(1);

            if (connection_aborted()) break;
        }

        return $response;
    }

}


