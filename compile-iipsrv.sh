#/bin/bash
git clone https://github.com/ruven/iipsrv.git
cd iipsrv
./autogen.sh
./configure --with-openjpeg=/openjpeg/
make
