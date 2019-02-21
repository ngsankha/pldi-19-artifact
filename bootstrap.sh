cd ~

sudo apt-get -y update
sudo apt-get -y install gnupg2 curl git build-essential software-properties-common
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get -y update
sudo apt-get install -y gcc g++ gcc-6 g++-6 postgresql-10 libpq-dev redis-server imagemagick libmagickwand-dev
sudo update-alternatives --remove-all gcc
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 80 --slave /usr/bin/g++ g++ /usr/bin/g++-6
sudo -u postgres createuser vagrant --superuser

# Install RVM
gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm

# Install Ruby
rvm install 2.4.5
rvm use ruby-2.4.5
gem install bundler

# Setup RDL
echo "Installing RDL ..."
git clone https://github.com/plum-umd/rdl
git clone https://github.com/mckaz/db-types
cd rdl
git checkout pldi-comp-types
cd ~

# Setup Discourse
echo "Installing Discourse ..."
git clone https://github.com/mckaz/discourse-typecheck
cd discourse-typecheck
bundle install
bundle exec rake db:create db:migrate
cd ~

# Setup Huginn
echo "Installing Huginn ..."
git clone https://github.com/ngsankha/huginn
cd huginn
cp .env.example .env
grep -v rdl Gemfile > Gemfile.new
echo "gem 'rdl', path: \"~/rdl/\"" >> Gemfile.new
mv Gemfile.new Gemfile
bundle install
bundle exec rake db:create db:migrate db:seed
cd ~

# Setup Journey
git clone https://github.com/mckaz/journey
cd journey
cp /vagrant/journey_database.yml config/database.yml
bundle install
bundle exec rake db:migrate
cd ~

# Setup Code.org
git clone https://github.com/mckaz/code-dot-org
cd code-dot-org
cp /vagrant/code-dot-org-schema.rb dashboard/db/schema.rb
bundle install
cd pegasus
rake pegasus:setup_db
cd ../dashboard
bundle exec rails db:environment:set RAILS_ENV=development
bundle exec rake db:create
bundle exec rake db:schema:load
cd ~
