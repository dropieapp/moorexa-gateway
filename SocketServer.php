<?php
use Ratchet\Server\IoServer;
use Socket\Listen;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;

// require composer autoloader
require_once 'vendor/autoload.php';

// require gateway files
include_once 'require.php';

// require the listener file
include_once 'Socket/Listen.php';

// build server
$server = IoServer::factory(
    new HttpServer(
        new WsServer(
            new Listen()
        )
    ),
    8080
);

// run server
$server->run();