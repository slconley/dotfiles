#!/usr/bin/env python3

# python3 version of pingtcp - makes tcp connection to specified target(s)

import sys, traceback, socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.settimeout(5)

try:
    for arg in sys.argv[1:]:
        host, port = arg.split(':',2)
        try :
            s.connect((host, int(port)))
            print('connection succeeded: %s:%s' % (host, port))
        except socket.error as e:
            print("connection failed: %s:%s (%s)" % (host, port, e))
        s.close()
except KeyboardInterrupt:
    sys.exit(0)

