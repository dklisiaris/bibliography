# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w[hotwire.js hotwire.css]

# hotwire.css is built by Dart Sass (npm run build:css) and contains modern CSS
# (min(), etc.). sassc-rails registers a Sprockets postprocessor that re-compresses
# all CSS and chokes on those features — disable it in every environment.
# See: https://github.com/rails/cssbundling-rails#how-do-i-avoid-sasscsyntaxerror-exceptions-on-existing-projects
Rails.application.config.assets.css_compressor = nil
