<?php
use Http\{
    Kernel, Router, HttpRequest
};

$file = 'pipes.txt';

// read the file content
$content = file_get_contents($file);

if ($content == '') :

    if (file_exists('jobs.txt')):

        // get jobs
        $content = file_get_contents('jobs.txt');

        // delete jobs.txt
        unlink('jobs.txt');

    endif;

endif;

// check if task exists
if (strlen($content) > 2) :

    // get json data
    $content  = '[' . rtrim($content, ',') . ']';

    // get object
    $object = json_decode($content);

    if (is_object($object) || is_array($object)) :

        // clean pipe
        file_put_contents($file, '');

        // require gateway files
        include_once 'require.php';

        // get services
        $services = (include_once 'services.php')[SERVICE_MODE];

        // get event pipes
        foreach ($object as $eventPipes) :

            // load events
            foreach ($eventPipes as $pipe) :

                if (isset($pipe->service) && isset($pipe->event)) :

                    // check if service exists
                    if (isset($services[$pipe->service])) :

                        // create an http instance
                        $http = new HttpRequest();

                        // get the data
                        $data = isset($pipe->data) ? json_encode($pipe->data) : '';

                        // set the http headers
                        HttpRequest::header(['x-service-event' => $pipe->event, 'x-service-data' => $data]);
                    
                        // send request
                        $request = $http->sendRequest('get', $services[$pipe->service]);

                        if (is_object($request)) :

                            // manage headers
                            $headers = [];

                            // convert keys to lower case
                            foreach ($request->responseHeaders as $header => $value) $headers[strtolower($header)] = $value;

                            // check for gateway pipe from response header
                            if (isset($headers['x-gateway-event-pipe'])) :

                                // save events
                                $fh = fopen('jobs.txt', 'a+');
                                fwrite($fh, $headers['x-gateway-event-pipe'][0] . ',');
                                fclose($fh);

                            endif;

                        else:

                            // failed services
                            $fh = fopen('failed-services.log', 'a+');
                            fwrite($fh, json_encode([
                                'service' => $pipe->service,
                                'event' => $pipe->event,
                                'data' => $data,
                                'timestamp' => time(),
                                'date' => date('Y-m-d g:i:s a')
                            ]) . ',');
                            fclose($fh);

                            // in the furture we may need to send a notificatio to 
                            // gateway admin

                        endif;

                    endif; 

                endif;  

            endforeach;

        endforeach;

    endif;

endif;