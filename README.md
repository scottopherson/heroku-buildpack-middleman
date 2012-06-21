Heroku Ruby buildpack with Middleman support
============================================

This version has been forked to add explicit support for
[Middleman](http://www.middlemanapp.com). This allows you to push your MM app to
Heroku and have it automatically build the files and serve them.

    $ heroku create --stack cedar --buildpack http://github.com/rstacruz/heroku-buildpack-middleman.git

Unlike other buildpacks, this removes the need to modify your Middleman app! You
don't need to have `config.ru` or `Gemfile` or anything. All you need is
Middleman's `config.rb`.

