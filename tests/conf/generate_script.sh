# root.key
openssl genrsa -out root.key 4096
# root.crt
openssl req -new -x509 -days 10000 -key root.key -out root.crt
# tidb.key
openssl genrsa -out tidb.key 2048
# tidb.csr
openssl req -new -key tidb.key -out tidb.csr
# tidb.crt
openssl x509 -req -days 10000 -CA root.crt -CAkey root.key -CAcreateserial -in tidb.csr -out tidb.crt
# client.key
openssl genrsa -out client.key 2048
# client.csr
openssl req -new -key client.key -out client.csr
# client.crt
openssl x509 -req -days 10000 -CA root.crt -CAkey root.key -CAcreateserial -in client.csr -out client.crt