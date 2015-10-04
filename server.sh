#!/bin/sh

rm -rf server_data
mkdir server_data
cd server_data
../../fast_perforce_setup/make_perforce_server_ssl_keys.sh
../../fast_perforce_setup/run_perforce_server_localhost.sh