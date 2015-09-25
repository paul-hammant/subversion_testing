#!/bin/sh

rm -rf server_data
mkdir server_data
cd server_data
/usr/local/bin/svnadmin create foo
perl -pi -e 's/# anon-access = read/anon-access = write/' foo/conf/svnserve.conf
/usr/local/bin/svnserve -d -r foo &