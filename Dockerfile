FROM ruby:4 AS builder
WORKDIR /app/web

RUN apt-get update && apt-get install -y chromium fonts-liberation --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN bundle exec nanoc && \
    bundle exec nanoc check internal_links mixed_content stale && \
    chromium --headless --no-sandbox --disable-gpu --disable-dev-shm-usage \
             --no-pdf-header-footer --print-to-pdf=output/paper.pdf "file://$(pwd)/output/index.html"

FROM httpd:2 AS runner

COPY --from=builder /app/web/output /usr/local/apache2/htdocs
