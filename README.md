A simple board in development.

```
sudo gem install thin
sudo gem install bundler
git clone https://github.com/RoxasShadow/Dafuq
cd Dafuq
bundle install # may be necessary to install some libraries with your package manager, such as libxslt-dev and libxml2-dev
thin -R config.ru -p 4567 start # http://localhost:4567
```

In order to have a documentation about the public APIs execute the follow commands.

```
sudo gem install rdoc-sinatra
rdoc app/controllers/*
cd doc
```

Files to translate:

```
app/assets/javascript/index_LANG.js
app/views/posts/index_LANG.erb
app/models/*.rb # messages
app/helpers/time.rb # strings
```
