#!/bin/bash

# configure _bash_profile_ if not present
if [ -f /home/vagrant/.bash_profile ]; then
  echo 'bash_profile found'
else
  cp /vagrant/config/bash_profile /home/vagrant/.bash_profile
  chown -R vagrant /home/vagrant/.bash_profile
fi

# update
apt-get update --yes

# install _curl_ if not present
hash curl 2>&- || apt-get install curl --yes

# install _vim_ if not present, and configure
hash vim 2>&- || {
  apt-get install vim --yes
  cp /vagrant/config/vimrc /home/vagrant/.vimrc
  cp -r /vagrant/config/vim /home/vagrant/.vim
  chown -R vagrant /home/vagrant/.vimrc /home/vagrant/.vim
}

# configure _gemrc_ if not present
if [ -f /home/vagrant/.gemrc ]; then
  echo 'gemrc found'
else
  cp /vagrant/config/gemrc /home/vagrant/.gemrc
  chown -R vagrant /home/vagrant/.gemrc
fi

# RVM
if [ -f /etc/profile.d/rvm.sh ]; then
  echo 'rvm found'
else
  bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer)
  usermod -a -G rvm root
  usermod -a -G rvm vagrant
  source "/etc/profile.d/rvm.sh"
fi

# ruby 1.9.2
if grep -q 'ruby 1.9.2' <<< "`ruby --version`"; then
  echo 'ruby 1.9.2 found'
else
  rvm install 1.9.2
  rvm use 1.9.2 --default
fi

# mysql-server
# hash mysql 2>&- || {
#   mysql, http://www.cmsimike.com/blog/2012/01/08/install-mysql-on-ubuntu-without-being-prompted-for-a-password/comment-page-1/
#   echo "mysql-server mysql-server/root_password select (password)" | sudo debconf-set-selections
#   echo "mysql-server mysql-server/root_password_again select (password)" | sudo debconf-set-selections
#   apt-get install --yes mysql-server
# }

# memcached
# hash memcached 2>&- || apt-get install memcached --yes

# redis
# hash redis-server 2>&- || apt-get install redis-server --yes

# sphinx
# hash search 2>&- || apt-get install sphinxsearch --yes

# imagemagick
# hash identify 2>&- || apt-get install imagemagick --yes

# build tools
apt-get install build-essential libssl-dev --yes

# git
hash git 2>&- || {
  apt-get install git-core --yes
 #git config --global user.name "My Name"
 #git config --global user.email my.email@some_domain.com
}

# sqlite3
hash sqlite3 2>&- || {
  apt-get install sqlite3 libsqlite3-dev
}

# rails
hash rails 2>&- || gem install rails

# nvm, node
hash nvm 2>&- || {
  git clone git://github.com/creationix/nvm.git /home/vagrant/.nvm
  . /home/vagrant/.nvm/nvm.sh
  nvm install v0.5.2
  nvm alias default v0.5.2
  chown -R vagrant /home/vagrant/.nvm
}

# npm, returns 'it failed' but it probably didn't
# hash npm 2>&- || curl http://npmjs.org/install.sh | sh

# coffeescript
# hash coffee 2>&- || npm install -g coffee-script

# apache
# hash apache2ctl 2>7- || {
#   cp -r /vagrant/config/public_html /home/vagrant/
#   chown -R vagrant /home/vagrant/public_html
#   apt-get install apache2 --yes
#   cp /vagrant/config/apache_site_default /etc/apache2/sites-available/default
#   apache2ctl restart
# }

# source bash_profile
source "/home/vagrant/.bash_profile"

# bundle install for rails app
cd /vagrant && bundle install

# start rails app
cd /vagrant && rails s -p 80

exit 0
