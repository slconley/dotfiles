#!/usr/bin/env python2

# python version of pingtcp - makes tcp connection to specified target(s)

import sys, traceback, socket
socket.setdefaulttimeout(5)

try:
    for arg in sys.argv[1:]:

        host, port = arg.split(':',2)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        try:
            s.connect((host, int(port)))
            print('connection succeeded: %s:%s' % (host, port))
            s.close()

        except socket.error, e:
            print "connection failed: %s:%s (%s)" % (host, port, e)

except KeyboardInterrupt:
    sys.exit(0)

