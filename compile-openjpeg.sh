#/bin/bash
git clone https://github.com/uclouvain/openjpeg.git
cd openjpeg
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && make
make install
ldconfig
