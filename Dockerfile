# Guiguts requirements:
# https://github.com/DistributedProofreaders/guiguts/blob/master/INSTALL.md

# Ebookmaker requirements:
# https://github.com/DistributedProofreaders/guiguts/blob/master/tools/ebookmaker/README.md

# References:
#
# https://www.pgdp.net/wiki/PPTools/Guiguts/Install/Linux
# https://github.com/DistributedProofreaders/guiguts
# http://gutcheck.sourceforge.net/etc.html
# https://www.pgdp.net/wiki/DP_Official_Documentation:Proofreading/DPCustomMono2_Font#Download
# https://wiki.ubuntu.com/Fonts
# https://stackoverflow.com/a/42260979/2449905

FROM debian:buster-slim
LABEL maintainer="dan@tangledhelix.com"

### ------------------------------------------------------------------
### Set GUIGUTS_RELEASE_VERSION when upgrading to a new guiguts.
###   (see below)
### Also update docker-compose.yml (image version) before rebuilding
### ------------------------------------------------------------------

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Note: Use `cpanm -n` to not run tests (they fail without an X11 server)

ARG DEBIAN_FRONTEND=noninteractive
RUN chmod 755 /docker-entrypoint.sh \
 && apt-get update \
 && apt-get install -y \
      libtext-levenshteinxs-perl \
      libfile-which-perl \
      libimage-size-perl \
      libwww-perl \
      libwebservice-validator-html-w3c-perl \
      libxml-xpath-perl \
      libxml2-dev \
      libxslt-dev \
      libjpeg-dev \
      perl-tk \
      aspell \
      aspell-en \
      tidy \
      geeqie \
      xterm \
      cpanminus \
      make \
      curl \
      zip \
      gcc \
      pkg-config \
      automake \
      libglib2.0 \
      dos2unix \
      python3 \
      python3-pip \
      python3-cairo \
      firefox-esr \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install ebookmaker

RUN cpanm -n Tk::CursorControl \
 && cpanm -n Tk::ToolBar \
 && rm -rf /root/.cpanm

RUN curl -s -L -o /bookloupe.tar.gz \
      http://www.juiblex.co.uk/pgdp/bookloupe/bookloupe-2.0.tar.gz \
 && cd / \
 && tar xfz bookloupe.tar.gz \
 && cd /bookloupe-2.0 \
 && cp /usr/share/automake-1.16/config.guess config/ \
 && cp /usr/share/automake-1.16/config.sub config/ \
 && ./configure \
 && make \
 && make install \
 && cd / \
 && rm -rf bookloupe-2.0 bookloupe.tar.gz

RUN groupadd pgdp \
 && useradd -g pgdp -d /dp -m pgdp

# Default settings which includes path to bookloupe, DP custom font, and
# other such base settings.
COPY guiguts-base-settings.rc /guiguts-base-settings.rc

# Guiguts release to install (must exist as a GitHub release)
ENV GUIGUTS_RELEASE_VERSION=1.2.4

USER pgdp
WORKDIR /dp

RUN mkdir -p .fonts \
 && curl -s -L -o .fonts/DPSansMono2.ttf \
      https://github.com/DistributedProofreaders/dproofreaders/raw/master/styles/fonts/DPSansMono.ttf \
 && fc-cache -f -v

RUN curl -s -L -o guiguts.zip \
    https://github.com/DistributedProofreaders/guiguts/releases/download/r${GUIGUTS_RELEASE_VERSION}/guiguts-generic-${GUIGUTS_RELEASE_VERSION}.zip \
 && unzip guiguts.zip \
 && rm -f guiguts.zip \
 && cd guiguts/tools/jeebies \
 && make build

ENTRYPOINT [ "/docker-entrypoint.sh" ]

# There is no version of Kindle Previewer for Linux. You can get one
# for macOS. Unclear how to get a Kindle-format book that works with it,
# maybe ebookmaker will do that?
# https://www.amazon.com/gp/feature.html?docId=1000765261

# for ebookmaker:
# [ ] install cairo
#       libcairo2 ?
#       libcairo2-dev ?
#       python3-cairo ?
#       python3-cairo-dev ?
# [x] pip3 install ebookmaker
#       this installed cairocffi, did it take care of this itself?

