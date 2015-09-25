#!/bin/sh

pid=$(ps aux | grep svnserve | grep " -d " | tr -s ' ' | cut -d" " -f2)
kill $pid 2>&1 | sed "/kill: usage:/d"
rm -rf server_data
rm -rf client_data