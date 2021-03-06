FROM node:11.7.0-slim

MAINTAINER Reev Ranj

COPY fonts.conf .

RUN apt-get update && apt-get -y install apt-transport-https curl
RUN  apt-get update \
     && apt-get install -yq wget curl gnupg libgconf-2-4 ca-certificates wget xvfb dbus dbus-x11 build-essential --no-install-recommends \
     && apt-get install -yq gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcurl4-gnutls-dev libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget fonts-arphic-ukai fonts-arphic-uming fonts-ipafont-mincho fonts-ipafont-gothic fonts-unfonts-core fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-noto unzip --no-install-recommends \
     && cd "$(mktemp -d)" \
     && wget https://noto-website.storage.googleapis.com/pkgs/NotoColorEmoji-unhinted.zip \
     && unzip NotoColorEmoji-unhinted.zip \
     && mkdir -p ~/.fonts \
     && mv *.ttf ~/.fonts \
     && mkdir -p ~/.config/fontconfig \
     && cp /fonts.conf ~/.config/fontconfig \
     && fc-cache -f -v \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN  apt-get update \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     && apt-get install -y google-chrome-stable fonts-ipafont-gothic fonts-wqy-zenhei fonts-thai-tlwg fonts-kacst fonts-freefont-ttf libxss1 --no-install-recommends \
     && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN apt-get -y update && apt-get install -y wget nano git build-essential yasm pkg-config
RUN apt-get update && apt-get install -y python2.7

# Compile and install ffmpeg from source
RUN apt-get install -y ffmpeg 
RUN apt-get install -y build-essential libxi-dev libglu1-mesa-dev libglew-dev pkg-config libvips-dev
COPY . .
RUN npm i --force

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV CHROME_PATH=/usr/bin/google-chrome-stable
ENV IS_DOCKER=true
ENV PUPPETEER_EXEC_PATH=google-chrome-stable

RUN chmod +x *.sh
