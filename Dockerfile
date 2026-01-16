FROM node:20-bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    N8N_USER_FOLDER="/home/node/.n8n"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    ffmpeg \
    sox \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

# pip/certifi зафиксированы для воспроизводимости сборки
RUN python3 -m pip install --no-cache-dir \
    pip==24.3.1 \
    certifi==2024.12.14

# yt-dlp зафиксирован
RUN python3 -m pip install --no-cache-dir yt-dlp==2024.12.23

# n8n зафиксирован
RUN npm install -g n8n@1.123.11

RUN mkdir -p ${N8N_USER_FOLDER} && chown -R node:node ${N8N_USER_FOLDER}
WORKDIR ${N8N_USER_FOLDER}

# self-check на этапе билда
RUN yt-dlp --version \
 && ffmpeg -version \
 && n8n --version

USER node
EXPOSE 5678
CMD ["n8n"]
