# This configuration file works with both the Compass command line tool and within Rails.
require 'html5-boilerplate'
# Require any additional compass plugins here.
require 'compass'
require 'compass/logger'

project_type = :rails

# Set this to the root of your project when deployed:
http_path = "/"

# You can select your preferred output style here (can be overridden via the command line):
# output_style = :expanded or :nested or :compact or :compressed

# To enable relative paths to assets via compass helper functions. Uncomment:
relative_assets = true
project_path = Rails.root if defined?(Rails)

http_path = "/assets"
#css_dir = "public/stylesheets"
sass_dir = "app/assets/stylesheets"
images_dir = "app/assets/images"
javascripts_dir = "app/assets/javascripts"
cache_dir = "tmp/sass-cache"

http_images_path = "/assets/images"
http_stylesheets_path = "/assets/stylesheets"
http_javascripts_path = "/assets/javascripts"
# To disable debugging comments that display the original location of your selectors. Uncomment:
# line_comments = false


# If you prefer the indented syntax, you might want to regenerate this
# project again passing --syntax sass, or you can uncomment this:
# preferred_syntax = :sass
# and then run:
# sass-convert -R --from scss --to sass app/stylesheets scss && rm -rf sass && mv scss sass
