ENV['JEKYLL_NO_BUNDLER_REQUIRE'] = 'true'
Gem.paths = { 'GEM_PATH' => ['/tmp/andy-site-gems', *Gem.path].join(File::PATH_SEPARATOR) }
gem 'jekyll', '3.10.0'
require 'jekyll'
config = Jekyll.configuration({ 'source' => Dir.pwd, 'destination' => '/tmp/andy-site-preview', 'url' => 'http://127.0.0.1:8765', 'future' => true, 'disable_disk_cache' => true })
config['plugins'] += ['jekyll-optional-front-matter', 'jekyll-relative-links']
Jekyll::Site.new(config).process
