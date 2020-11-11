#!/bin/bash

# install needed dependencies
sudo apt-get update
sudo apt-get install \
      build-essential pkg-config libc6-dev m4 g++-multilib \
      autoconf libtool ncurses-dev unzip git python \
      zlib1g-dev wget bsdmainutils automake curl

# safecoinBitcore
cd
git clone https://github.com/Fair-Exchange/safecoin.git safecoin
cd safecoin
./zcutil/fetch-params.sh
./zcutil/build.sh -j$(nproc)
cd
echo "Safecoind with extended RPC functionalities is prepared. Please run following command to install insight explorer for safecoin"
echo "wget -qO- https://raw.githubusercontent.com/Fair-Exchange/bitcore-node-safecoin/master/installExplorer.sh | bash"