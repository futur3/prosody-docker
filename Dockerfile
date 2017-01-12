################################################################################
# Build a dockerfile for Prosody XMPP server
################################################################################

FROM debian:jessie

MAINTAINER Daniele Brugnara <daniele@brugnara.me>

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libidn11 \
        liblua5.1-expat0 \
        libssl1.0.0 \
        lua-bitop \
        lua-dbi-mysql \
        lua-dbi-postgresql \
        lua-dbi-sqlite3 \
        lua-event \
        lua-expat \
        lua-filesystem \
        lua-sec \
        lua-socket \
        lua-zlib \
        lua5.1 \
        openssl \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Install and configure prosody

RUN echo 'deb http://packages.prosody.im/debian jessie main' > /etc/apt/sources.list.d/prosody \ 
    && wget http://prosody.im/files/prosody-debian-packages.key -O- | apt-key add - \
    && apt-get update \
    && apt-get install -y prosody \
    && rm -rf /var/lib/apt/lists/* \
    && sed -i '1s/^/daemonize = false;\n/' /etc/prosody/prosody.cfg.lua \
    && perl -i -pe 'BEGIN{undef $/;} s/^log = {.*?^}$/log = {\n    {levels = {min = "info"}, to = "console"};\n}/smg' /etc/prosody/prosody.cfg.lua

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 443 5222 5269 5347 5280 5281
USER prosody
ENV __FLUSH_LOG yes
CMD ["prosody"]
