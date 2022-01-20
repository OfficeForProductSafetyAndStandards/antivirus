FROM ruby:3.0.3

RUN gem install bundler:2.3.4

RUN apt-get update && apt-get install -y \
  clamav-daemon && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# permission juggling
RUN mkdir /var/run/clamav && \
    chown clamav:clamav /var/run/clamav && \
    chmod 750 /var/run/clamav

# av configuration update
RUN sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/clamd.conf && \
    sed -i 's/^Foreground .*$/Foreground true/g' /etc/clamav/freshclam.conf

VOLUME ["/var/lib/clamav"]

WORKDIR /antivirus

COPY . .

COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
