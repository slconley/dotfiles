#!/bin/sh
for f in ~/.files/profile.d/*.sh ; do 
  . "$f"
done
