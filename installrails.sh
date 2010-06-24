#!/bin/bash

echo "[Calango Megaboga Install Ruby Pack for Ubuntu]\n v0.01a\n Iniciando... "

echo "Instalando libs basicas....\n"
apt-get update
apt-get -y install build-essential zlib1g zlib1g-dev libxml2 libxml2-dev libxslt-dev sqlite3 libsqlite3-dev locate git-core
apt-get -y install git-doc git-svn git-gui gitk
apt-get -y install curl wget vim vim-rails

echo "Instalando Ruby 1.8 MRI...\n"

apt-get -y install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8 libreadline-ruby1.8 libruby1.8 libopenssl-ruby
ln -s /usr/bin/ruby1.8 /usr/bin/ruby
ln -s /usr/bin/rdoc1.8 /usr/bin/rdoc
ln -s /usr/bin/irb1.8 /usr/bin/irb
ln -s /usr/bin/ri1.8 /usr/bin/ri

echo "Instalando RubyGems 1.3.1 a partir do Source Code....\n"

curl http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz | tar -xzv
cd rubygems-1.3.1 && ruby setup.rb install
cd .. && rm -rf rubygems-1.3.1
ln -s /usr/bin/gem1.8 /usr/local/bin/gem
gem sources -a http://gems.github.com

echo "Instalando Gems basicas....\n"

gem install rake nokogiri hpricot builder cheat daemons json uuid sqlite3-ruby fastthread rack

echo "Instalando Rails....\n"

gem install activerecord activesupport actionmailer activeresource actionpack rails
export PATH=$PATH:/var/lib/gems/1.8/bin

echo "Deseja instalar pacote tunado de gems[aws3,brazilianRails,capistrano,etc..]? (y/n)"
read packgem
if [ $packgem = "y" ];
then
	gem install aws-s3 brcep brcpfcnpj brdata brdinheiro brhelper brnumeros brstring brtraducao capistrano fastercsv mongrel mechanize --no-rdoc --no-ri
fi

echo "Instalar Mysql 5 ou CouchDB? [m]-MySql [c]-CouchDB [n]-Nenhum dos dois "
read pdatabase
if [ $pdatabase = "m" ];
then
    echo "Instalando o MySql"
	apt-get install mysql-server-5.0
	apt-get install libmysqlclient15-dev
	gem install mysql
elif [ $pdatabase = "c" ]; 
then
    echo "Instalando o CouchDB"
    aptitude install automake autoconf libtool subversion-tools help2man spidermonkey-bin erlang erlang-manpages libicu38 libicu-dev libreadline5-dev checkinstall libmozjs-dev
    adduser --no-create-home --disabled-password --disabled-login couchdb
    wget http://linorg.usp.br/apache/couchdb/0.9.0/apache-couchdb-0.9.0.tar.gz
    tar zxvf apache-couchdb-0.9.0.tar.gz
    cd apache-couchdb-0.9.0
    ./configure --bindir=/usr/bin --sbindir=/usr/sbin --localstatedir=/var --sysconfdir=/etc
    make
    make install
    chown couchdb:couchdb -R /var/lib/couchdb /var/log/couchdb /usr/local/var/run/
    ln -s /usr/local/etc/init.d/couchdb /etc/init.d/
    update-rc.d couchdb defaults
fi

echo "Instalar ImageMagick? (y/n)"
read imagick
if [ $imagick = "y" ];
then
	apt-get -y install libmagick9-dev
	gem install rmagick
fi

echo "Instalar Apache + Phusion Passenger? (y/n)"
read apache
if [ $apache = "y" ];
then
	echo "deb http://apt.brightbox.net hardy main" > /etc/apt/sources.list.d/brightbox.list
	wget -q -O - http://apt.brightbox.net/release.asc | apt-key add -
	apt-get update
	apt-get -y install libapache2-mod-passenger
fi


echo "Finalizando instalacao....\n\n"
echo "Versão do Ruby: " 
ruby -v
echo "Versão do RubyGems: " 
gem -v
echo "Versão do Rails: " 
rails -v
echo "Gems instaladas: \n"
gem list

echo "\n\nFinalizado!"
