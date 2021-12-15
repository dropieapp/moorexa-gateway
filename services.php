<?php
/**
 * @package Micro Services
 * @author Amadi Ifeanyi <amadiify.com>
 */
$services = [
    
    'production' => [
        /**
         * @example
         * ServiceName => endpoint
         */
    ],

    'development' => [
        /**
         * @example
         * ServiceName => endpoint
         */
        'account' => 'http://localhost:8888/dropexpress_services/account/',
        'authentication' => 'http://localhost:8888/dropexpress_services/authentication/',
        'messaging' => 'http://localhost:8888/dropexpress_services/messaging/',
        'packages' => 'http://localhost:8888/dropexpress_services/packages/',
        'riders' => 'http://localhost:8888/dropexpress_services/riders/',
        'wallet' => 'http://localhost:8888/dropexpress_services/wallet/',
        'payment' => 'http://localhost:8888/dropexpress_services/payment/',
    ]
];

// return array
return $services;