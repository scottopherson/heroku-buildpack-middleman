Heroku Ruby buildpack with Middleman support
============================================

This version has been forked to add explicit support for
[Middleman](http://www.middlemanapp.com). This allows you to push your MM app to
Heroku and have it automatically build the files and serve them.

``` sh
# To create a new app:
$ heroku create --stack cedar --buildpack http://github.com/rstacruz/heroku-buildpack-middleman.git

# ...or to migrate an existing Cedar app to it:
$ heroku config:add BUILDPACK_URL=http://github.com/rstacruz/heroku-buildpack-middleman.git
```

Unlike other buildpacks, this removes the need to modify your Middleman app! You
don't need to have `config.ru` or `Gemfile` or anything. All you need is
Middleman's `config.rb`.

How does it look like?
----------------------

```
-----> Heroku receiving push
-----> Fetching custom buildpack... done
-----> Middleman app detected
-----> Installing dependencies using Bundler version 1.2.0.pre
       Running: bundle install --without development:test --path vendor/bundle --binstubs bin/ --deployment
       Using RedCloth (4.2.9)
       Using i18n (0.6.0)
       Using multi_json (1.0.4)
       Using activesupport (3.2.2)
       ...
       Your bundle is complete! It was installed into ./vendor/bundle
       Cleaning up the bundler cache.
-----> Building Middleman site
             create  build
             create  build/section_nav.html
             create  build/page_search.html
             create  build/section_index_item.html
             create  build/my_account_-_subscriptions.html
             create  build/about_us.html
             create  build/images/bg-linen.png
             create  build/images/bg-footer.png
             ...
             ...
             ...
       Middleman build completed (4.09s)
-----> Discovering process types
       Procfile declares types     -> (none)
       Default types for Middleman -> console, rake, web
-----> Compiled slug size is 10.1MB
-----> Launching... done, v87
       http://furious-fire-8104.herokuapp.com deployed to Heroku
```
