<?php

namespace Controller;

use Model\ViaggioRepository;
use Model\UtenteRepository; 
use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

class HomeController
{
    public function __construct(private ContainerInterface $container) {}

    public function index(Request $request, Response $response, array $args): Response
    {
        $repo = new ViaggioRepository();
        $utente_repo = new UtenteRepository();
        $engine = $this->container->get('template');
        $viaggi_recenti = $repo->findRecenti(6);
        foreach ($viaggi_recenti as &$viaggio) {
            $viaggio["voto_medio"] = $utente_repo->getVotoMedio($viaggio["autista_id"]);
        }
        unset($viaggio); // buona pratica dopo un foreach per reference
        $response->getBody()->write($engine->render('home', [
            'viaggi_recenti' => $viaggi_recenti,
        ]));
        return $response;
    }
}
