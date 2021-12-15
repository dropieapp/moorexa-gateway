<?php
/**
 * @var array $files
 */
$files = [
    'Http/kernel.php',
    'Http/router.php',
    'Http/request.php',
    'Http/queues.php'
];

// require composer
include_once 'vendor/autoload.php';

// include files once
foreach ($files as &$file) if (file_exists($file)) require_once $file;

// clean up
$files = null;
$file = null;

/**
 * Set the default service mode
 */
define('SERVICE_MODE', 'development');