#!/bin/bash

for i in `seq 0 10` ; do
    echo "Creating server"
    time curl -s -H "X-NITRO-USER: nsroot" -H "X-NITRO-PASS: i-0d8c19060b2fd1ba7" -H "Content-Type:application/json" -XPOST http://10.0.1.21/nitro/v1/config/server/i-029bd777982e1034d -d '{"server":{"name":"i-029bd777982e1034d","IPAddress":"10.0.3.86"}}'; echo

    echo "Creating service"
    time curl -s -H "X-NITRO-USER: nsroot" -H "X-NITRO-PASS: i-0d8c19060b2fd1ba7" -H "Content-Type:application/json" -XPOST http://10.0.1.21/nitro/v1/config/service/i-029bd777982e1034d-80 -d '{"service":{"name":"i-029bd777982e1034d-80","serverName":"i-029bd777982e1034d","serviceType":"HTTP","port":80}}'; echo

    echo "Binding service to lb"
    time curl -s -H "X-NITRO-USER: nsroot" -H "X-NITRO-PASS: i-0d8c19060b2fd1ba7" -H "Content-Type:application/json" -XPOST http://10.0.1.21/nitro/v1/config/lbvserver_service_binding -d '{"lbvserver_service_binding":{"servicename":"i-029bd777982e1034d-80","name":"jurik-lb"}}'; echo

    for x in `seq 0 10` ; do
        curl -s "http://10.0.2.21/"
        sleep 0.1
    done

    echo "Deleting server"
    time curl -s -H "X-NITRO-USER: nsroot" -H "X-NITRO-PASS: i-0d8c19060b2fd1ba7" -XDELETE http://10.0.1.21/nitro/v1/config/server/i-029bd777982e1034d; echo

    for x in `seq 0 10` ; do
        curl -s "http://10.0.2.21/"
        sleep 0.1
    done
done
