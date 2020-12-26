# TODO: epub maker
# TODO: kindle maker
# TODO: should guiguts/data/ be mounted from host?
#       No label file found, creating file data/labels_en.rc with default values.
# TODO: a gimp container? bundle gimp in this container? (package name = gimp)

# References
# ----------
# https://www.pgdp.net/wiki/PPTools/Guiguts/Install/Linux
# https://github.com/DistributedProofreaders/guiguts
# http://gutcheck.sourceforge.net/etc.html
# https://www.pgdp.net/wiki/DP_Official_Documentation:Proofreading/DPCustomMono2_Font#Download
# https://wiki.ubuntu.com/Fonts
# https://stackoverflow.com/a/42260979/2449905

FROM debian:10.4
MAINTAINER Dan Lowe <dan@tangledhelix.com>

# What to check out (probably a tag) from guiguts repository
ENV GUIGUTS_RELEASE_TAG=r1.1.1

# Install system packages
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -y \
        make \
        gcc \
        zip \
        git \
        dos2unix \
        cpanminus \
        curl \
        pkg-config \
        libglib2.0 \
        geeqie \
        aspell \
        aspell-en \
        tidy \
        xterm \
        libmime-base64-urlsafe-perl \
        libdigest-md5-file-perl \
        liburi-perl \
        libencode-locale-perl \
        libfile-listing-perl \
        libhtml-parser-perl \
        libhtml-tagset-perl \
        libhttp-cookies-perl \
        libhttp-daemon-perl \
        libhttp-date-perl \
        libhttp-message-perl \
        libhttp-negotiate-perl \
        libio-html-perl \
        libimage-size-perl \
        libwww-perl \
        liblwp-mediatypes-perl \
        libmodule-build-perl \
        libnet-http-perl \
        perltidy \
        libtext-levenshteinxs-perl \
        perl-tk \
        liburi-perl \
        libwww-robotrules-perl \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install guiguts & its other requirements.
# Use -n to not run cpanm tests (they'll fail without X11)
RUN cpanm -n Tk::CursorControl \
 && cpanm -n Tk::ToolBar \
 && rm -rf /root/.cpanm \
 && git clone https://github.com/DistributedProofreaders/guiguts.git /dp/guiguts \
 && cd /dp/guiguts && git checkout ${GUIGUTS_RELEASE_TAG} && rm -rf .git

# Install Jeebies
RUN cd /dp/guiguts/tools/jeebies \
 && curl -s -L -o jeebies-dp.zip http://www.pgdp.org/~gm/jeebies/jeebies.zip \
 && unzip -o jeebies-dp.zip \
 && gcc jeebies.c -o jeebies \
 && rm -f jeebies-dp.zip

# Install Bookloupe
RUN curl -s -L -o /bookloupe.tar.gz http://www.juiblex.co.uk/pgdp/bookloupe/bookloupe-2.0.tar.gz \
 && cd / && tar xfz bookloupe.tar.gz \
 && cd /bookloupe-2.0 && ./configure && make && make install && rm -rf bookloupe-2.0

# Install DP's custom font
RUN mkdir -p /root/.fonts \
 && curl -s -L -o /root/.fonts/DPCustomMono2.ttf https://www.pgdp.net/c/faq/DPCustomMono2.ttf \
 && fc-cache -f -v

# Default settings which includes path to bookloupe, DP custom font, and
# other such base settings. But this is just defaults copied into place initially,
# your settings are persisted after that point. This is only here to make it
# convenient to use the container-bundled aspell, bookloupe, jeebies, etc.
COPY guiguts-base-settings.rc /dp/guiguts/default-settings.rc

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

ENTRYPOINT [ "/docker-entrypoint.sh" ]

