# frozen_string_literal: true

# Helper to locate a Chrome/Chromium executable across platforms.
def chrome_executable
  candidates = %w[google-chrome google-chrome-stable chromium-browser chromium]
  candidates.find { |cmd| system('which', cmd, out: File::NULL, err: File::NULL) } ||
    raise('No Chrome/Chromium executable found. Install Google Chrome or Chromium.')
end

namespace :build do
  desc 'Compile the Nanoc site into output/'
  task :compile do
    sh 'bundle exec nanoc'
  end

  desc 'Run Nanoc validation checks (internal links, mixed content, stale)'
  task :check do
    sh 'bundle exec nanoc check internal_links mixed_content stale'
  end
end

desc 'Compile the Nanoc site (alias for build:compile)'
task build: 'build:compile'

desc 'Generate output/paper.pdf from the compiled site using headless Chrome'
task :pdf do
  raise 'Run `rake build` first — output/index.html not found.' \
    unless File.exist?('output/index.html')

  chrome = chrome_executable
  sh %(#{chrome} --headless --disable-gpu --no-pdf-header-footer \
        --print-to-pdf=output/paper.pdf \
        "file://#{Dir.pwd}/output/index.html")
  puts "PDF written to output/paper.pdf"
end

desc 'Serve the compiled output/ on http://localhost:4000'
task :serve do
  raise 'Run `rake build` first — output/ directory not found.' \
    unless Dir.exist?('output')

  exec 'bundle exec rackup config.ru --port 4000'
end

desc 'Build the site, generate the PDF, then serve it on http://localhost:4000'
task dev: %i[build pdf serve]
