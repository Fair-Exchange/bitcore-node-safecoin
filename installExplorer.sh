
#!/bin/bash

# install needed dependencies
cd
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
sudo apt-get install -y libzmq3-dev

# MongoDB (Ubuntu 18)
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo systemctl enable mongod
sudo service mongod start

#bitcore-node-safecoin
cd
git clone https://github.com/Fair-Exchange/bitcore-node-safecoin
cd bitcore-node-safecoin
npm install
cd bin
chmod +x bitcore-node
cp ~/safecoin/src/safecoind ~/bitcore-node-safecoin/bin
./bitcore-node create mynode
cd mynode

rm bitcore-node.json

cat << EOF > bitcore-node.json
{
  "network": "livenet",
  "port": 3001,
  "services": [
    "bitcoind",
    "insight-api-safecoin",
    "insight-ui-safecoin",
    "web"
  ],
  "messageLog": "",
  "servicesConfig": {
      "web": {
      "disablePolling": false,
      "enableSocketRPC": false
    },
    "bitcoind": {
      "sendTxLog": "./data/pushtx.log",
      "spawn": {
        "datadir": "./data",
        "exec": "../safecoind",
        "rpcqueue": 1000,
        "rpcport": 8771,
        "zmqpubrawtx": "tcp://127.0.0.1:28771",
        "zmqpubhashblock": "tcp://127.0.0.1:28771"
      }
    },
    "insight-api-safecoin": {
        "routePrefix": "api",
                 "db": {
                   "host": "127.0.0.1",
                   "port": "27017",
                   "database": "safecoin-api-livenet",
                   "user": "",
                   "password": ""
          },
          "disableRateLimiter": true
    },
    "insight-ui-safecoin": {
        "apiPrefix": "api",
        "routePrefix": ""
    }
  }
}
EOF

cd data
cat << EOF > safecoin.conf
server=1
whitelist=127.0.0.1
txindex=1
addressindex=1
timestampindex=1
spentindex=1
zmqpubrawtx=tcp://127.0.0.1:28771
zmqpubhashblock=tcp://127.0.0.1:28771
rpcport=8771
rpcallowip=127.0.0.1
rpcuser=safecoin
rpcpassword=mysafecoinpassword
uacomment=bitcore
mempoolexpiry=24
rpcworkqueue=1100
maxmempool=2000
dbcache=1000
maxtxfee=1.0
dbmaxfilesize=64
showmetrics=0
addnode=dnsseedua.local.support
addnode=dnsseedna.local.support
EOF

cd ..
cd node_modules
cd insight-api-safecoin
npm install
cd ..
cd insight-ui-safecoin
npm install
cd ..
cd ..

echo "Explorer is installed"
echo "Then to start explorer navigate to mynode folder and type ../bitcore-node start. Explorer will be accessible on localhost:3001" 