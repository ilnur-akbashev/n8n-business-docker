FROM node:20-bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    N8N_USER_FOLDER="/home/node/.n8n"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    ffmpeg \
    sox \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir --upgrade \
    pip==24.3.1 \
  && python3 -m pip install --no-cache-dir \
    certifi==2024.12.14 \
    yt-dlp==2024.12.23

RUN npm install -g n8n@1.123.18

RUN mkdir -p ${N8N_USER_FOLDER} && chown -R node:node ${N8N_USER_FOLDER}

USER node
WORKDIR ${N8N_USER_FOLDER}

RUN yt-dlp --version \
 && ffmpeg -version \
 && n8n --version

EXPOSE 5678
CMD ["n8n"]
