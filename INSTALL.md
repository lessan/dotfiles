
(dotfiles)


sudo apt install silversearcher-ag




git clone https://github.com/rbenv/rbenv.git ~/.rbenv

git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev

rbenv install 2.6.1

rbenv global 2.6.1

gem install bundler

sudo apt install postgresql libpq-dev
sudo su - postgres

psql template1

CREATE USER deploy WITH PASSWORD '';
ALTER USER deploy SUPERUSER;

CREATE USER datacore WITH PASSWORD '';
ALTER USER datacore SUPERUSER;

ctrl-d


cd
