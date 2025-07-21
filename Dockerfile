FROM docker.n8n.io/n8nio/n8n:latest

USER root

RUN apk add --no-cache \
    ffmpeg \
    curl \
    tesseract \
    imagemagick \
    libreoffice \
    jq \
    poppler-utils \
    ghostscript \
    httpie \
    sox \
    htmlq \
    sed \
    awk \
    grep \
    sqlite3 \
    bash \
    python3 \
    py3-pip \
    git

RUN chown -R node:node /home/node/.n8n

USER node
