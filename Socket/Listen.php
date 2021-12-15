<?php
namespace Socket;
use Http\{
    Kernel, Router, HttpRequest
};
use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;

class Listen implements MessageComponentInterface
{
    // @var SplObjectStorage $clients
    protected $clients;

    // @var array $config
    private static $config = [
        'sender' => [],
        'rider' => []
    ];

    // @var array $track
    private static $track = [];

    // @var array $services
    private static $services = [];

    // load constructor
    public function __construct()
    {
        $this->clients = new \SplObjectStorage;

        if (count(self::$services) == 0) :

            // get the list of services
            self::$services = (include_once 'services.php')[SERVICE_MODE];

        endif;
    }

    public function onOpen(ConnectionInterface $conn)
    {
        // Store the new connection to send messages to later
        $this->clients->attach($conn);

        // we have a new socket connection
        echo "New connection! ({$conn->resourceId})\n";
    }

    public function onMessage(ConnectionInterface $from, $msg)
    {
        // @var int $numRecv
        $numRecv = count($this->clients) - 1;

        // @var array $services
        $services = self::$services;

        // account service
        $accountEndpoint = isset(self::$services['account']) ? self::$services['account'] : '';

        // packages service
        $packageEndpoint = isset(self::$services['packages']) ? self::$services['packages'] : '';

        // riders service
        $ridersEndpoint = isset(self::$services['riders']) ? self::$services['riders'] : '';

        // echo sprintf('Connection %d sending message "%s" to %d other connection%s' . "\n"
        //     , $from->resourceId, $msg, $numRecv, $numRecv == 1 ? '' : 's');

        // foreach ($this->clients as $client) :
        
        //     if ($from !== $client) {

        //         // The sender is not the receiver, send to each client connected
        //         $client->send($msg);
        //     }

        // just removed an entry
        $justRemovedAnEntry = false;

        // endforeach;
        if (is_string($msg) && strpos($msg, '{') !== false) :

            // try read it as an object
            $object = json_decode($msg);

            // read it as a post data
            $endpoint = array_key_exists($object->service, self::$services) ? self::$services[$object->service] : null;

            // single request
            if (isset($object->single) && $object->single == true) :

                // make single request
                if ($endpoint !== null && is_object($object->data)) :

                    // add micro services header
                    HttpRequest::header([
                        'x-micro-services' => json_encode(self::$services)
                    ]);

                    // send request.
                    $request = HttpRequest::body(((array) $object->data))->sendRequest($object->method, $endpoint . '/' . $object->endpoint);

                    // check for identifier
                    if (isset($object->identifier)) $request->json->identifier = $object->identifier;

                    // return response
                    $from->send(json_encode(((array) $request->json)));

                endif;

            elseif (isset($object->notification) && $object->notification = true) :

                // check for data
                if (is_object($object->data)) :

                    // get the customerid
                    $customerid = $object->data->customerid;

                    // send notification
                    foreach (self::$config as $type) :

                        foreach ($type as $target => $config) :

                            if ($target == $customerid) :

                                // send notification
                                $config['pool']->send(json_encode(array_merge(((array) $object->data), [
                                    'code' => 200,
                                    'message' => $object->data->message,
                                    'identifier' => (isset($object->identifier) ? $object->identifier : 'notification')
                                ])));

                                // break out
                                break;

                            endif;

                        endforeach;

                    endforeach;
                    
                endif;

            else:

                // read the data as an array
                if (is_object($object->data)) :

                    // config
                    if (isset($object->data->type)) :

                        // @var target
                        $target  =  isset($object->data->customerid) ? $object->data->customerid : (isset($object->data->hash) ? $object->data->hash : null);

                        // add to config
                        if ($target !== null) :

                            // add pool for rider
                            self::$config[$object->data->type][$target] = [
                                'pool' => $from,
                                'latitude' => $object->data->latitude,
                                'longitude' => $object->data->longitude,
                            ];

                            // update entry
                            $justRemovedAnEntry = false;

                            // can we remove
                            if (isset($object->data->connection) && $object->data->connection == 'close') :

                                $remove = true;

                                // check account type
                                if ($object->data->type == 'rider' && $endpoint !== null) : 

                                    // send request.
                                    $request = HttpRequest::body(((array) $object->data))->sendRequest($object->method, $endpoint . '/' . $object->endpoint);

                                    // can we close
                                    if ($request->json->status != 'success') :

                                        // sorry !
                                        $remove = false;

                                        // send response
                                        $from->send(json_encode([
                                            'status' => 'error',
                                            'message' => $request->json->message,
                                            'code' => 404
                                        ]));

                                    else:

                                        $from->send(json_encode([
                                            'status' => 'success',
                                            'message' => 'You have gone offline',
                                            'code' => 204
                                        ]));

                                    endif;

                                endif;


                                // remove from waiting list
                                if ($remove) :

                                    // remove target
                                    unset(self::$config[$object->data->type][$target]);

                                    // just removed
                                    $justRemovedAnEntry = true;

                                endif;

                            endif;

                        endif;

                    endif;

                    // send location to registered devices
                    if (count(self::$config['rider']) > 0 && count(self::$track) > 0) :

                        if (isset($object->data->customerid)) :

                            foreach (self::$track as $poolInfo) :
                                // check rider id
                                if ($poolInfo['riderid'] == $object->data->customerid) :
                                    $poolInfo['pool']->send(json_encode([
                                        'latitude' => $object->data->latitude,
                                        'longitude' => $object->data->longitude,
                                        'riderid' => $object->data->customerid
                                    ]));
                                endif;
                            endforeach;

                        endif;

                    endif;

                    // register a device for tracking
                    if (isset($object->data->track) && isset($object->data->hash)) :

                        // register device
                        self::$track[$object->data->hash] = [
                            'pool' => $from,
                            'riderid' => $object->data->riderid
                        ];

                    else:
                        
                        if (count(self::$config['sender']) > 0 && count(self::$config['rider']) > 0) :

                            // find rider closer to sender
                            foreach (self::$config['sender'] as $sender) :

                                // get the latitude and longitude
                                $s_latitude = $sender['latitude'];
                                $s_longitude = $sender['longitude'];

                                // @var array $data
                                $data = [];

                                // @var float radius
                                $radius = 6371e3;

                                // get the radian 1
                                $radian1 = floatval($s_latitude) * pi() / 180;

                                // check all riders
                                foreach (self::$config['rider'] as $riderIndex => $rider) :

                                    // get the latitude and longitude
                                    $r_latitude = $rider['latitude'];
                                    $r_longitude = $rider['longitude'];

                                    // calculate distance
                                    $kilometer = $this->distance($s_latitude, $s_longitude, $r_latitude, $r_longitude, 'm');

                                    // must not be above 1500
                                    if ($kilometer < 1500) :

                                        // get the rider pool
                                        $riderPool = $rider['pool'];

                                        // remove pool
                                        unset($rider['pool']);

                                        // add meter
                                        if (!isset($rider['meter'])) $rider['meter'] = 0;

                                        // add meter
                                        $rider['meter'] = round($meters, 2);

                                        // get the rider info
                                        if (!isset($rider['information'])) :

                                            // get the rider information
                                            // we have an endpoint
                                            if ($endpoint !== null) :

                                                // send request.
                                                $request = HttpRequest::body(((array) $object->data))->sendRequest($object->method, $endpoint . '/' . $object->endpoint);
                                                
                                                // check status
                                                if ($request->json->status == 'success') :

                                                    // add response text
                                                    $rider['pickup_response'] = (array) $request->json;

                                                    if ($accountEndpoint != '') :

                                                        // add information
                                                        $riderInfo = HttpRequest::query()->sendRequest('get', $endpoint . '/app/information/' . $object->data->customerid);

                                                        // add the customer information
                                                        if ($riderInfo->json->status == 'success') : 
                                                            
                                                            // get the basic info
                                                            $basicInfo = HttpRequest::query()->sendRequest('get', $accountEndpoint . '/app/account/' . $object->data->customerid);

                                                            // do we have a basic info
                                                            if ($basicInfo->json->status == 'success') :

                                                                // push account info to array
                                                                $riderInfo->json->account = (array) $basicInfo->json;

                                                                // set the ratings
                                                                $riderInfo->json->ratings = 0;

                                                                // set the pickups
                                                                $riderInfo->json->pickups = 0;

                                                                // get the ratings
                                                                $ratings = HttpRequest::query()->sendRequest('get', $ridersEndpoint . '/app/get-ratings/' . $object->data->customerid);

                                                                // get total ratings
                                                                if ($ratings->json->status == 'success') $riderInfo->json->ratings = $ratings->json->ratings;

                                                                // get the pickups
                                                                $pickups = HttpRequest::query()->sendRequest('get', $packageEndpoint . '/app/rider-pickups/completed/' . $object->data->customerid);

                                                                // add pickups
                                                                if ($pickups->json->status == 'success') $riderInfo->json->pickups = $pickups->json->total;

                                                            endif;

                                                            // add rider information
                                                            $rider['information'] = (array) $riderInfo->json;
                                                            
                                                        endif;

                                                    endif;

                                                else:

                                                    // send message to rider
                                                    $riderPool->send(json_encode([
                                                        'status' => 'error',
                                                        'origin' => $object->endpoint,
                                                        'message' => $request->json->message,
                                                        'code' => isset($request->json->code) ? $request->json->code : 0
                                                    ]));

                                                endif;

                                            endif; 

                                            // save for later
                                            self::$config['rider'][$riderIndex]['information'] = $rider['information'];
                                            
                                        endif;

                                        $rider['information']['geo'] = [
                                            'latitude' => $r_latitude,
                                            'longitude' => $r_longitude
                                        ];

                                        // push to data
                                        $data[] = $rider;
                                        
                                    endif;

                                endforeach;

                                // send pool
                                if (count($data) > 0) $sender['pool']->send(json_encode($data));

                            endforeach;
                    
                        else:
                        
                            // just removed an entry
                            if ($justRemovedAnEntry && count(self::$config['sender']) > 0) :

                                // find rider closer to sender
                                foreach (self::$config['sender'] as $sender) :

                                    // no dispatch rider avaliable around user.
                                    $sender['pool']->send(json_encode([]));

                                endforeach;

                            endif;

                        endif;

                    endif;

                endif;

            endif;

        endif;
    }

    // calculate distance latitude and longitude
    public function distance($lat1, $lon1, $lat2, $lon2, $unit)
    {
        if (($lat1 == $lat2) && ($lon1 == $lon2)) :
        
          return 0;
        
        else:

          $theta = $lon1 - $lon2;
          $dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) +  cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta));
          $dist = acos($dist);
          $dist = rad2deg($dist);
          $miles = $dist * 60 * 1.1515;
          $unit = strtoupper($unit);
      
          if ($unit == "K") :

            return ($miles * 1.609344);

          elseif ($unit == "N") :

            return ($miles * 0.8684);

          else:

            return $miles;
          endif;
        
        endif;
    }

    public function onClose(ConnectionInterface $conn)
    {
        // The connection is closed, remove it, as we can no longer send it messages
        $this->clients->detach($conn);

        echo "Connection {$conn->resourceId} has disconnected\n";
    }

    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        $fh = fopen('error.log', 'a+');
        fwrite($fh, "An error has occurred: {$e->getMessage()}\n");
        fclose($fh);

        //$conn->close();
    }
}