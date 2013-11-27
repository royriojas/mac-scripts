#!/bin/bash 

echo '===> install apc.so in OSX Mavericks'

mkdir -p ~/tmp/apc-deps

# Compile PCRE - Perl Compatible Regular Expressions
cd ~/tmp/apc-deps
curl -O ftp://ftp.csx.cam.ac.uk//pub/software/programming/pcre/pcre-8.33.tar.gz
tar -xvzf pcre-8.33.tar.gz
cd pcre-8.33
./configure
make
sudo make install

HAVE_AUTOCONF=$(which autoconf)

if [[ $HAVE_AUTOCONF == "" ]] ; then
  echo '===> no autoconf found'
  echo '===> trying to install it...'
  
  cd ~/tmp/apc-deps
  curl -O http://gnu.mirrors.hoobly.com/gnu/autoconf/autoconf-2.69.tar.gz
  tar xzf autoconf-2.69.tar.gz
  cd autoconf-2.69
  ./configure --prefix=/usr/local
  make
  sudo make install

else
  echo '===> autoconf found'
fi

echo '===> Now get apc and installed it'

# Compile PHP APC
cd ~/tmp/apc-deps
curl -O http://pecl.php.net/get/APC-3.1.13.tgz
tar zxvf APC-3.1.13.tgz
cd APC-3.1.13
phpize
./configure --with-php-config=/usr/bin/php-config
make && sudo make install

echo '===> Done!. Modify your php.ini to load the apc.so. See the logs to find the proper location.'
echo '===> usually it is something like this... /usr/lib/php/extensions/no-debug-non-zts-20100525/'

