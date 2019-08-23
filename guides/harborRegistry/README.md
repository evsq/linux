# Harbor registry
Install and configure Harbor registry on CentOS 7
# Install Docker

```
yum install gcc openssl-devel bzip2-devel wget yum-utils device-mapper-persistent-data lvm2 -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
```
# Create self-signed OpenSSL certs
```
hostnamectl set-hostname registry
hostname=$(hostname)
mkdir harbor_install
mkdir -p harbor_install/openssl
cd harbor_install/openssl
```

```
openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -sha512 -days 3650 \
-subj "/C=RU/ST=Russia/L=Moscow/O=test/OU=test/CN=${hostname}" \
-key ca.key \
-out ca.crt**

openssl genrsa -out ${hostname}.key 4096

openssl req -sha512 -new \
-subj "/C=RU/ST=Russia/L=Moscow/O=test/OU=test/CN=${hostname}" \
-key ${hostname}.key \
-out ${hostname}.csr

cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1=${hostname}
DNS.2=registry
EOF

openssl x509 -req -sha512 -days 3650 \
-extfile v3.ext \
-CA ca.crt -CAkey ca.key -CAcreateserial \
-in ${hostname}.csr \
-out ${hostname}.crt
```

```
openssl x509 -inform PEM -in ${hostname}.crt -out ${hostname}.cert
```

# Copy certs to root for Harbor installation
```
mkdir -p /root/cert/
cp ${hostname}.crt /root/cert/
cp ${hostname}.key /root/cert/
```
# Copy certs to Docker to get around X509 unauthorized cert error
```
mkdir -p /etc/docker/certs.d/${hostname}/
cp ${hostname}.cert /etc/docker/certs.d/${hostname}/
cp ${hostname}.key /etc/docker/certs.d/${hostname}/
cp ca.crt /etc/docker/certs.d/${hostname}/
cp ${hostname}.crt /etc/pki/ca-trust/source/anchors/${hostname}.crt
update-ca-trust
```
# Start the Docker Service
```
systemctl enable --now docker
```

# Install Docker Compose
```
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
# Download harbor
```
cd /root/harbor_install/
wget https://storage.googleapis.com/harbor-releases/release-1.8.0/harbor-online-installer-v1.8.2.tgz
tar xvf harbor-online-installer-v1.8.2.tgz
rm harbor-online-installer-v1.8.2.tgz
cd $(pwd)/harbor
```
# Configure harbor
Change hostname, enable https, add path to certs and add s3 storage in harbor.yml

```
hostname: your hostname

# http related config
#http:
  # port for http, default is 80. If https enabled, this port will redirect to https port
#  port: 80

# https related config
https:
#   # https port for harbor, default is 443
  port: 5000
#   # The path of cert and key files for nginx
  certificate: /root/cert/yourcert.crt
  private_key: /root/cert/yourkey.key
storage_service:
  s3:
    accesskey: youraccesskey
    secretkey: yoursecretkey
    region: yourregion
    bucket: yourbucket
    regionendpoint: yourendpoint

```
# Install harbor
Apply your configuration and install harbor

```
./prepare
./install.sh
```
# Update harbor
Stop existing services, change your configuration file, apply configuration with help ./prepare and start services
```
docker-compose down -v
vim harbor.yml
./prepare
docker-compose up -d
```
