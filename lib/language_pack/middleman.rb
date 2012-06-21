require "fileutils"
require "language_pack"
require "language_pack/rack"

class LanguagePack::Middleman < LanguagePack::Rack

  def self.use?
    File.exist?("Gemfile") && File.exist?("config.rb")
  end

  # Usually the default addons include the shared database, but in this case,
  # we don't need any addons by default.
  def default_addons
    []
  end

  def name
    "Middleman"
  end

  def compile
    Dir.chdir(build_path)
    remove_vendor_bundle
    install_ruby
    setup_language_pack_environment
    allow_git do
      install_language_pack_gems
      build_bundler
      create_config_ru
      install_binaries
      middleman_build
    end
  end

  def middleman_build
    log("middleman_build") do
      topic("Building Middleman site")
      require 'benchmark'
      time = Benchmark.realtime { pipe("env PATH=$PATH:bin bundle exec middleman build --debug 2>&1") }
      if $?.success?
        puts "Middleman build completed (#{"%.2f" % time}s)"
      else
        error "Middleman build failed."
      end
    end
  end

  def create_config_ru
    unless File.exist?('config.ru')
      log("create_config_ru") do
        topic("Creating default config.ru for Middleman")
        File.open('config.ru', 'w') { |f| f.write config_ru_contents }
      end
    end
  end

  def config_ru_contents
    %[
      # Modified version of TryStatic, from rack-contrib
      # https://github.com/rack/rack-contrib/blob/master/lib/rack/contrib/try_static.rb

      # Serve static files under a `build` directory:
      # - `/` will try to serve your `build/index.html` file
      # - `/foo` will try to serve `build/foo` or `build/foo.html` in that order
      # - missing files will try to serve build/404.html or a tiny default 404 page


      module Rack

        class TryStatic

          def initialize(app, options)
            @app = app
            @try = ['', *options.delete(:try)]
            @static = ::Rack::Static.new(lambda { [404, {}, []] }, options)
          end

          def call(env)
            orig_path = env['PATH_INFO']
            found = nil
            @try.each do |path|
              resp = @static.call(env.merge!({'PATH_INFO' => orig_path + path}))
              break if 404 != resp[0] && found = resp
            end
            found or @app.call(env.merge!('PATH_INFO' => orig_path))
          end
        end
      end

      use Rack::TryStatic, :root => "build", :urls => %w[/], :try => ['.html', 'index.html', '/index.html']

      # Run your own Rack app here or use this one to serve 404 messages:
      run lambda{ |env|
        not_found_page = File.expand_path("../build/404.html", __FILE__)
        if File.exist?(not_found_page)
          [ 404, { 'Content-Type'  => 'text/html'}, [File.read(not_found_page)] ]
        else
          [ 404, { 'Content-Type'  => 'text/html' }, ['404 - page not found'] ]
        end
      }
    ].strip.gsub(/^ {6}/, '')
  end

end
