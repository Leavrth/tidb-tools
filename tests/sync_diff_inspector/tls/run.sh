#!/bin/sh

set -ex

cd "$(dirname "$0")"
CA_PATH=../../conf/root.crt
CERT_PATH=../../conf/client.crt
KEY_PATH=../../conf/client.crt
OUT_DIR=/tmp/tidb_tools_test/sync_diff_inspector/output
FIX_DIR=/tmp/tidb_tools_test/sync_diff_inspector/fixsql
rm -rf $OUT_DIR
rm -rf $FIX_DIR
mkdir -p $OUT_DIR
mkdir -p $FIX_DIR

# create user for test tls
mysql -uroot -h 127.0.0.1 -P 4000 -e "create user 'root_tls'@'%' identified by '' require X509;"
mysql -uroot -h 127.0.0.1 -P 4000 -e "grant all privileges on *.* to 'root_tls'@'%';"
mysql -uroot_tls -h 127.0.0.1 -P 4000 --ssl-ca "$CA_PATH" --ssl-cert "$CERT_PATH" --ssl-key "KEY_PATH"  -e "SHOW STATUS LIKE \"%Ssl%\";"

echo "use sync_diff_inspector to compare data"
# sync diff tidb-tidb
sed 's/"ca-path"#CAPATH/"$CA_PATH"/g' config.toml > config_.toml
sed 's/"cert-path"#CERTPATH/"$CERT_PATH"/g' config_.toml > config_.toml
sed 's/"key-path"#KEYPATH/"$KEY_PATH"/g' config_.toml > config_.toml
sync_diff_inspector --config=./config_.toml > $OUT_DIR/diff.output
check_contains "check pass!!!" $OUT_DIR/sync_diff.log
