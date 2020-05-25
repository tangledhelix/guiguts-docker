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

ENV DEBIAN_FRONTEND=noninteractive

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

RUN cpanm -n Tk::CursorControl
RUN cpanm -n Tk::ToolBar
RUN mkdir -p /dp/pp
RUN git clone --depth 1 https://github.com/DistributedProofreaders/guiguts.git /dp/guiguts \
 && rm -rf /dp/guiguts/.git
RUN cd /dp/guiguts/tools/jeebies \
 && curl -L -o jeebies-dp.zip http://www.pgdp.org/~gm/jeebies/jeebies.zip \
 && unzip -o jeebies-dp.zip \
 && gcc jeebies.c -o jeebies \
 && rm -f jeebies-dp.zip
RUN curl -L -o /bookloupe.tar.gz http://www.juiblex.co.uk/pgdp/bookloupe/bookloupe-2.0.tar.gz \
 && cd / && tar xfz bookloupe.tar.gz \
 && cd /bookloupe-2.0 && ./configure && make && make install && rm -rf bookloupe-2.0
RUN mkdir -p /root/.fonts \
 && curl -L -o /root/.fonts/DPCustomMono2.ttf https://www.pgdp.net/c/faq/DPCustomMono2.ttf \
 && fc-cache -f -v

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

# Default settings which includes path to bookloupe, DP custom font, and
# other such base settings. But this is just defaults copied into place initially,
# settings are persisted after that point.
COPY guiguts-base-settings.rc /dp/guiguts-base-settings.rc

# TODO: epub maker
# TODO: kindle maker
# TODO: should guiguts/data/ be mounted from host?
#       No label file found, creating file data/labels_en.rc with default values.
# TODO: should the guiguts paths and stuff be set using env vars?
#       the file is perl, right? So it can load env vars? Maybe?
# TODO: a gimp container? bundle gimp in this container? (package name = gimp)

ENTRYPOINT ["/entrypoint.sh"]
