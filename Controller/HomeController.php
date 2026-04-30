<?php

namespace Controller;

use Model\ViaggioRepository;
use Psr\Container\ContainerInterface;
use Slim\Psr7\Request;
use Slim\Psr7\Response;

class HomeController
{
    public function __construct(private ContainerInterface $container) {}

    public function index(Request $request, Response $response, array $args): Response
    {
        $repo = new ViaggioRepository();
        $engine = $this->container->get('template');
        $response->getBody()->write($engine->render('home', [
            'viaggi_recenti' => $repo->findRecenti(6),
        ]));
        return $response;
    }
}
