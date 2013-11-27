#!/bin/bash 

echo "===> install memcached.so in OSX Mavericks"

HAVE_PEAR=$(which pear)

if [[ $HAVE_PEAR == "" ]] ; then
  echo '===> no pear found'
  echo '===> trying to install it...'
  
  cd /usr/local

  sudo curl -O  http://pear.php.net/go-pear.phar
  sudo php -d detect_unicode=0 go-pear.phar

else
  echo '===> pear found'
fi

echo $(pear version)

echo '===> Now get memcached and installed it'

mkdir -p ~/tmp/memcached-temp
cd ~/tmp/memcached-temp
pecl download memcached
tar zxvf memcached-*
cd memcached-*
phpize
./configure --with-libmemcached-dir=/opt/local
make
sudo make install

echo '===> Done!. Modify your php.ini to load the memcached.so. See the logs to find the proper location.'
echo '===> usually it is something like this... /usr/lib/php/extensions/no-debug-non-zts-20100525/'

