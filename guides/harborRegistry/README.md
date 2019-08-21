# Harbor registry
Install and configure Harbor registry on CentOS 7
# Install Docker


yum install gcc openssl-devel bzip2-devel wget yum-utils device-mapper-persistent-data lvm2 -y
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce -y
systemctl enable --now docker
# Create self-signed OpenSSL certs
**hostnamectl set-hostname registry
hostname=$(hostname)
mkdir harbor_install
mkdir -p harbor_install/openssl
cd harbor_install/openssl**


**openssl genrsa -out ca.key 4096**

**openssl req -x509 -new -nodes -sha512 -days 3650 \
-subj "/C=RU/ST=Russia/L=Moscow/O=test/OU=test/CN=${hostname}" \
-key ca.key \
-out ca.crt**

**openssl genrsa -out ${hostname}.key 4096**

**openssl req -sha512 -new \
-subj "/C=RU/ST=Russia/L=Moscow/O=test/OU=test/CN=${hostname}" \
-key ${hostname}.key \
-out ${hostname}.csr**

**cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1=${hostname}
DNS.2=registry
EOF**

**openssl x509 -req -sha512 -days 3650 \
-extfile v3.ext \
-CA ca.crt -CAkey ca.key -CAcreateserial \
-in ${hostname}.csr \
-out ${hostname}.crt**

# Copy certs to root for Harbor installation
**mkdir -p /root/cert/
cp ${hostname}.crt /root/cert/
cp ${hostname}.key /root/cert/**

**openssl x509 -inform PEM -in ${hostname}.crt -out ${hostname}.cert**
