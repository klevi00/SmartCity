<?php

use Controller\ConversazioneController;
use Controller\HomeController;
use Controller\ViaggioController;
use Controller\UtenteController;
use DI\Container;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Log\LoggerInterface;
use Slim\Factory\AppFactory;
use League\Plates\Engine;

require '../vendor/autoload.php';
require_once '../conf/config.php';

session_start();

$container = new Container();
AppFactory::setContainer($container);
$app = AppFactory::create();

$app->setBasePath(BASE_PATH);

$container->set('template', function () {
    $engine = new Engine('../templates', 'tpl');
    $engine->addData(['base_path' => BASE_PATH]);
    return $engine;
});

$customErrorHandler = function (
    Request $request,
    Throwable $exception,
    bool $displayErrorDetails,
    bool $logErrors,
    bool $logErrorDetails
) use ($app) {
    $response = $app->getResponseFactory()->createResponse();
    $engine   = $app->getContainer()->get('template');

    if ($exception instanceof \Slim\Exception\HttpNotFoundException) {
        $response->getBody()->write($engine->render('404', ['error' => $exception->getMessage()]));
        return $response->withStatus(404);
    }

    $response->getBody()->write('<pre>Errore: ' . htmlspecialchars($exception->getMessage()) . '</pre>');
    return $response->withStatus(500);
};

$errorMiddleware = $app->addErrorMiddleware(true, true, true);
if (MY_ERROR_HANDLER) {
    $errorMiddleware->setDefaultErrorHandler($customErrorHandler);
}

// ── ROUTES ──────────────────────────────────────────────────

$app->get('/', HomeController::class . ':index');

// Ricerca
$app->get('/cerca', ViaggioController::class . ':cerca');

// Dettaglio viaggio e prenotazione
$app->get('/viaggio/{id:[0-9]+}', ViaggioController::class . ':show');
$app->post('/viaggio/{id:[0-9]+}/prenota', ViaggioController::class . ':prenota');
$app->post('/viaggio/{id:[0-9]+}/cancella', ViaggioController::class . ':cancella');

// Pubblica viaggio
$app->get('/pubblica', ViaggioController::class . ':pubblica');
$app->post('/pubblica', ViaggioController::class . ':salvaViaggio');

// Auth
$app->get('/accedi', UtenteController::class . ':accedi');
$app->post('/accedi', UtenteController::class . ':login');
$app->get('/registrati', UtenteController::class . ':registrati');
$app->post('/registrati', UtenteController::class . ':registra');
$app->get('/profilo/{id}/modifica', [UtenteController::class, 'modificaProfilo']);
$app->post('/profilo/{id}/modifica', [UtenteController::class, 'aggiornaProfilo']);
$app->get('/esci', UtenteController::class . ':logout');

// Profilo utente
$app->get('/profilo/{id:[0-9]+}', UtenteController::class . ':profilo');

// I miei viaggi
$app->get('/miei-viaggi', UtenteController::class . ':mieiViaggi');

// Messaggi
$app->get('/messaggi', ConversazioneController::class . ':messaggi');
$app->get('/messaggi/{id:[0-9]+}', ConversazioneController::class . ':messaggi');
$app->post('/messaggi/{id:[0-9]+}/invia', ConversazioneController::class . ':inviaMessaggio');
$app->get('/messaggi/{id:[0-9]+}/stream', ConversazioneController::class . ':stream');

$app->run();
