source /etc/profile.d/rvm.sh
rvm install 2.5.3
rvm use ruby-2.5.3
gem install bundler

# Setup RDL
echo "Installing RDL ..."
git clone https://github.com/plum-umd/rdl
cd rdl
git checkout pldi-comp-types
cd ~

# Setup Discourse
echo "Installing Discourse ..."
git clone https://github.com/mckaz/discourse-typecheck
cd discourse-typecheck
grep -v rdl Gemfile > Gemfile
echo "gem 'rdl', path: \"~/rdl/\"" >> Gemfile
bundle install
