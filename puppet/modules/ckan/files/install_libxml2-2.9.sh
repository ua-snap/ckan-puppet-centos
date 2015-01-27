wget ftp://xmlsoft.org/libxml2/libxml2-2.9.0.tar.gz
tar -zxvf libxml2-2.9.0.tar.gz
cd libxml2-2.9.0
./configure --libdir=/usr/lib64
make && make install