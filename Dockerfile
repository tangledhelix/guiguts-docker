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

FROM debian:buster
LABEL maintainer="dan@tangledhelix.com"

### Set GUIGUTS_RELEASE_VERSION when upgrading to a new guiguts.
###   (see below)
### Also update docker-compose.yml (image version) before rebuilding

# Install system packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y \
      libtext-levenshteinxs-perl \
      libfile-which-perl \
      libimage-size-perl \
      libwww-perl \
      libwebservice-validator-html-w3c-perl \
      libxml-xpath-perl \
      perl-tk \
      aspell \
      aspell-en \
      tidy \
      opensp \
      default-jre \
      geeqie \
      xterm \
      cpanminus \
      make \
      curl \
      zip \
      gcc \
      pkg-config \
      libglib2.0 \
      dos2unix \
      python3 \
      python3-pip \
      python3-cairo \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Ebookmaker install
RUN pip3 install ebookmaker

# Install guiguts requirements.
# Use -n to not run cpanm tests (they'll fail without X11 server)
RUN cpanm -n Tk::CursorControl \
 && cpanm -n Tk::ToolBar \
 && rm -rf /root/.cpanm

# Install Bookloupe
RUN curl -s -L -o /bookloupe.tar.gz http://www.juiblex.co.uk/pgdp/bookloupe/bookloupe-2.0.tar.gz \
 && cd / \
 && tar xfz bookloupe.tar.gz \
 && cd /bookloupe-2.0 \
 && ./configure && make && make install && rm -rf bookloupe-2.0

# Install DP's custom font
RUN mkdir -p /root/.fonts \
 && curl -s -L -o /root/.fonts/DPSansMono2.ttf https://github.com/DistributedProofreaders/dproofreaders/raw/master/styles/fonts/DPSansMono.ttf \
 && fc-cache -f -v

# Guiguts release to fetch from Github
ENV GUIGUTS_RELEASE_VERSION=1.2.3

# Install Guiguts
RUN curl -s -L -o /guiguts.zip \
    https://github.com/DistributedProofreaders/guiguts/releases/download/r${GUIGUTS_RELEASE_VERSION}/guiguts-generic-${GUIGUTS_RELEASE_VERSION}.zip \
 && mkdir -p /dp \
 && cd /dp \
 && unzip /guiguts.zip \
 && rm -f /guiguts.zip

# Install Jeebies
RUN cd /dp/guiguts/tools/jeebies \
 && make build

# Default settings which includes path to bookloupe, DP custom font, and
# other such base settings.
COPY guiguts-base-settings.rc /dp/guiguts/default-settings.rc

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

WORKDIR /dp/guiguts
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# java for css validator = /usr/bin/java
# open-sp for xhtml validator = /usr/bin/{onsgmls,osgmlnorm,ospam,ospcat,ospent,osx}

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

# TODO: a gimp container? bundle gimp in this container? (package name = gimp)
