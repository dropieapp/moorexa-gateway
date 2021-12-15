<?php
use Http\{
    Kernel, Router, HttpRequest
};

// require gateway files
include_once 'require.php';


/**
 * Set our storage directory
 */
define('PATH_TO_STORAGE', 'Cache/');

/**
 * Satisfy request header
 */
if (!Kernel::headerSatisfied()) return Kernel::invalidRequest(); 

/**
 * Check for gateway endpoint
 */
if (!Router::noGateWayEndpoint()) return Kernel::resolve(404, [
    'status' => 'error',
    'message' => 'No Gateway endpoint requested.'
]);

/**
 * Send Http request
 */
Kernel::laodService((include_once 'services.php')[SERVICE_MODE]);
