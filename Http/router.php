<?php
namespace Http;

class Router
{
    /**
     * @var string $endpoint
     */
    private static $endpoint = '';

    /**
     * @method Router noGateWayEndpoint
     * @return bool
     */
    public static function noGateWayEndpoint() : bool 
    {
        // @var bool $hasEndpoint
        $hasEndpoint = false;

        // check GET for resource
        if (isset($_GET['endpoint'])) :

            // we have an endpoint
            $hasEndpoint = true;

            // get the endpoint
            self::$endpoint = $_GET['endpoint'];

        endif;

        // return bool
        return $hasEndpoint;
    }

    /**
     * @method Router getEndpoint
     * @return string
     */
    public static function getEndpoint() : string 
    {
        return self::$endpoint;
    }
}