#!/usr/bin/env perl

use strict;
use warnings;
use IO::Socket;

usage() if $#ARGV < 0 ;

foreach (@ARGV) {
  my ($host, $port) = split(/:/); 

  my $remote = IO::Socket::INET->new(
    Proto    => "tcp",
    PeerAddr  => $host,
    PeerPort  => $port,
    Timeout    => 8,
  );
  
  if ($remote) {
    print "connection succeeded: ${host}:${port}\n";
    close $remote;
  }
  else {
    print "connection failed: ${host}:${port} ($@)\n";
  }

}

sub usage {
  print STDERR "USAGE: $0 host:port [ host:port ... ]\n";
  exit 1;
}

