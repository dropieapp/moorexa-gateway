<?php
namespace Http;

class Kernel
{
    /**
     * @var array $requestHeader
     */
    private static $requestHeader = [];

    /**
     * @var array $httpError
     */
    private static $httpError = [];

    /**
     * @var bool $resolved
     */
    private static $resolved = false;

    /**
     * @method Kernel headerSatisfied
     * @return bool
     */
    public static function headerSatisfied() : bool 
    {
        // @var bool $satisfied 
        $satisfied = false;

        // get the request header
        if (function_exists('getallheaders')) :

            // get all headers
            $headers = getallheaders();

            // required headers
            $required = [
                'x-service-name' => '',
                'x-request-caching' => '',
                'x-response-type'=> 'application/json'
            ];

            // verified
            $verified = 1;

            // check for x-service-name, x-request-caching, x-response-type
            foreach ($headers as $header_key => $header_value) :

                // convert to lower case
                $header_key = strtolower($header_key);

                // has required header
                if (isset($required[$header_key])) :

                    // update required
                    $required[$header_key] = $header_value;

                    // update int
                    $verified++;

                else:

                    $required[$header_key] = $header_value;

                endif;

            endforeach;

            // set the response header
            header('Content-Type: ' . $required['x-response-type']);

            // are we good
            if ($verified > 2) :

                // all statisfied
                self::$requestHeader = $required;

                // header satisfied
                $satisfied = true;

            else:

                // get the service name
                if ($required['x-service-name'] == '') :

                    // event name missing
                    self::$httpError = ['status' => 'error', 'message' => 'Event name (x-service-name) missing in request header'];

                else:

                    // event name missing
                    self::$httpError = ['status' => 'error', 'message' => 'Response type (x-response-type) missing in request header'];
                endif;

            endif;

        endif;

        // return boolean
        return $satisfied;
    }

    /**
     * @method Kernel invalidRequest
     * @return void 
     */
    public static function invalidRequest()
    {
        self::resolve(419, self::$httpError);
    }

    /**
     * @method Kernel resolve
     * @param int $responseCode
     * @param mixed $data
     * @return void
     */
    public static function resolve(int $responseCode, $data) : void 
    {
        if (self::$resolved === false) :

            // @var string $output
            $output = '';

            // resolve response code
            http_response_code($responseCode);

            // check for string
            if (is_string($data)) :

                // check for xml data
                if (preg_match('/[<][\/](.*?)[>]/', $data)) :

                    // change the content type
                    header('Content-Type: application/xml');

                    // check for xml starting tag
                    if (strpos($data, '<?xml') !== false) :

                        // print xml data
                        $output = $data;

                    else:

                        // build xml data
                        $output = '<?xml version="1.0"?>
                        <response> ' . $data . '</response>';

                    endif;

                else:

                    // change the content type
                    header('Content-Type: application/json');

                    // print json data
                    $output = $data;

                endif;

            elseif (is_array($data)) :

                // get content type
                $usingJson = false;

                // xml
                $usingXml = false;

                // check now 
                $headers = headers_list();

                // check for json or xml
                foreach ($headers as $header) :

                    // convert to lower case
                    $header = strtolower($header);

                    // check for json
                    if (strpos($header, 'application/json') !== false) $usingJson = true;

                    // check for xml
                    if (strpos($header, 'application/xml') !== false) $usingXml = true;

                endforeach;

                // load for json
                if ($usingJson) $output = json_encode($data, JSON_PRETTY_PRINT);

                // load for xml
                if ($usingXml) :

                    // build tag
                    $tags = [];

                    // build tag
                    foreach ($data as $tag => $value) $tags[] = '<'. $tag . '>' . $value . '</' . $tag . '>';

                    // build xml data
                    $output = '<?xml version="1.0"?>
                    <response> ' . implode("\n", $tags) . '</response>';

                endif;

                // use default
                if ($usingXml === false && $usingJson === false) :

                    // change the content type
                    header('Content-Type: application/json');

                    // print json data
                    $output = json_encode($data, JSON_PRETTY_PRINT);

                endif;

            endif;

            // check for output
            if ($output !== '') :

                // render output
                echo $output;

            endif;

            // resolved
            self::$resolved = true;

        endif;
    }

    /**
     * @method Kernel systemHealthCheck
     * @param array $services
     * @return mixed
     */
    public static function systemHealthCheck(array $services)
    {
        // @var array $status
        $status = [];

        // create instance
        HttpRequest::createInstance();

        // base time
        $baseTime = time();

        // run array
        foreach ($services as $service => $endpoint) :

            // set a benchmark
            $rqtime = microtime(true);

            // send request.
            $request = HttpRequest::query()->sendRequest('get', $endpoint);

            // response time
            $rstime = microtime(true);

            // push status
            $status[$service] = [
                'request_time' => (string) round($rqtime - $baseTime, 2) . 'ms',
                'response_time' => (string) round(($rstime - $rqtime), 2) . 'ms',
                'status' => $request->status,
                'version' => isset($request->responseHeaders['x-service-version']) ? $request->responseHeaders['x-service-version'][0] : '0.0.1',
                'scheduled_maintenance' => isset($request->responseHeaders['x-service-maintenance']) ? $request->responseHeaders['x-service-maintenance'][0] : ''
            ];

            // update basetime
            $baseTime = time();

        endforeach;

        // send output
        return self::resolve(200, ['response' => json_encode(['services' => $status])]);
    }

    /**
     * @method Kernel laodService
     * @return mixed
     */
    public static function laodService(array $services) 
    {
        // get the service name
        $service = self::$requestHeader['x-service-name'];

        // load input
        self::input();

        // remove endpoint from get
        unset($_GET['endpoint']);

        // system health check ?
        if ($service == 'system-health-check') return self::systemHealthCheck($services);

        // stop if service does not exists
        if (!isset($services[$service])) return self::resolve(200, [
            'status' => 'error',
            'message' => 'The service requested for "'.$service.'" does not exists.'
        ]);

        // get the service url
        $endpoint = rtrim($services[$service], '/') . '/' . Router::getEndpoint(); 

        // remove service name
        unset(self::$requestHeader['x-service-name']);

        // set the content type
        self::$requestHeader['Content-Type'] = self::$requestHeader['x-response-type'];

        // remove content type
        unset(self::$requestHeader['x-response-type']);

        // pass services
        self::$requestHeader['x-micro-services'] = json_encode($services);

        // set request header
        foreach (self::$requestHeader as $header => $value) HttpRequest::header([$header => $value]);

        // get the request method
        $requestMethod = strtolower($_SERVER['REQUEST_METHOD']);

        // send request.
        $request = HttpRequest::multipart()->sendRequest($requestMethod, $endpoint);
            
        // exception throwned
        // we should prossibly log failed transactions.
        if (is_string($request)) return self::resolve(200, [
            'status' => 'error',
            'message' => strip_tags($request)
        ]);

        // get the response data
        if (is_object($request)) :

            // build response
            $response = [
                'response' => $request->text,
                'headers' => $request->responseHeaders
            ];

            // manage headers
            $headers = [];

            // convert keys to lower case
            foreach ($request->responseHeaders as $header => $value) $headers[strtolower($header)] = $value;

            // get the content type
            $contentType = isset($headers['content-type']) ? $headers['content-type'][0] : null;
            
            // no content type
            if ($contentType == null) return self::resolve(200, [
                'status' => 'error',
                'message' => 'Content Type missing in response header for service #{'.$service.'}'
            ]);

            // does response content type match the requested one ?
            if ($contentType != self::$requestHeader['Content-Type']) return self::resolve(200, [
                'status' => 'error',
                'message' => 'Invalid Content Type in response header for service "'.$service.'". Expected #{'.self::$requestHeader['Content-Type'].'}, received #{'.$contentType.'}'
            ]);

            // check for gateway pipe from response header
            if (isset($headers['x-gateway-event-pipe'])) :

                // convert to an object
                $fh = fopen('pipes.txt', 'a+');
                fwrite($fh, $headers['x-gateway-event-pipe'][0] . ',');
                fclose($fh);

            endif;
            
            // send output
            self::resolve($request->status, $response);

        endif;
    }

    /**
     * @method Post input
     * @return array
     * 
     * Convert Content-Disposition to a post data
     */
	public static function input() : array
	{
        // @var string $input
        $input = file_get_contents('php://input');

        // continue if $_POST is empty
		if (strlen($input) > 0 && count($_POST) == 0 || count($_POST) > 0) :
		
			$postsize = "---".sha1(strlen($input))."---";

			preg_match_all('/([-]{2,})([^\s]+)[\n|\s]{0,}/', $input, $match);

            // update input
			if (count($match) > 0) $input = preg_replace('/([-]{2,})([^\s]+)[\n|\s]{0,}/', '', $input);

			// extract the content-disposition
			preg_match_all("/(Content-Disposition: form-data; name=)+(.*)/m", $input, $matches);

			// let's get the keys
			if (count($matches) > 0 && count($matches[0]) > 0)
			{
				$keys = $matches[2];
                
                foreach ($keys as $index => $key) :
                    $key = trim($key);
					$key = preg_replace('/^["]/','',$key);
					$key = preg_replace('/["]$/','',$key);
                    $key = preg_replace('/[\s]/','',$key);
                    $keys[$index] = $key;
                endforeach;

				$input = preg_replace("/(Content-Disposition: form-data; name=)+(.*)/m", $postsize, $input);

				$input = preg_replace("/(Content-Length: )+([^\n]+)/im", '', $input);

				// now let's get key value
				$inputArr = explode($postsize, $input);

                // @var array $values
                $values = [];
                
                foreach ($inputArr as $index => $val) :
                    $val = preg_replace('/[\n]/','',$val);
                    
                    if (preg_match('/[\S]/', $val)) $values[$index] = trim($val);

                endforeach;
                
				// now combine the key to the values
				$post = [];

                // @var array $value
				$value = [];

                // update value
				foreach ($values as $i => $val) $value[] = $val;

                // push to post
				foreach ($keys as $x => $key) $post[$key] = isset($value[$x]) ? $value[$x] : '';

				if (is_array($post)) :
				
					$newPost = [];

					foreach ($post as $key => $val) :
					
						if (preg_match('/[\[]/', $key)) :
						
							$k = substr($key, 0, strpos($key, '['));
							$child = substr($key, strpos($key, '['));
							$child = preg_replace('/[\[|\]]/','', $child);
							$newPost[$k][$child] = $val;
						
                        else:
						
                            $newPost[$key] = $val;
                            
						endif;
                    
                    endforeach;

                    $_POST = count($newPost) > 0 ? $newPost : $post;
                    
				endif;
			}
        
        endif;

        // return array
		return $_POST;
    }
}