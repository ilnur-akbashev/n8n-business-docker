FROM node:20-bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_ENV=production
ENV N8N_USER_FOLDER="/home/node/.n8n"

# Chromium env
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium
ENV CHROME_BIN=/usr/bin/chromium

# Делаем глобальные node_modules видимыми для require() в Code Node
ENV NODE_PATH=/usr/local/lib/node_modules

# PATH явно — на случай pip --user артефактов
ENV PATH="/usr/local/bin:/usr/local/lib/node_modules/.bin:$PATH"

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    ffmpeg \
    sox \
    python3 \
    python3-pip \
    chromium \
    fonts-liberation \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    libnss3 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --no-cache-dir --upgrade pip==24.3.1 \
    && python3 -m pip install --no-cache-dir \
        certifi==2026.6.17

ARG YTDLP_VERSION=2026.06.09
ARG YTDLP_SHA256=bf8aac79b72287a6d2043074415132558b43743a8f9461a22b0141e90f16ce66

RUN curl -fsSL \
        "https://github.com/yt-dlp/yt-dlp/releases/download/${YTDLP_VERSION}/yt-dlp_linux" \
        -o /usr/local/bin/yt-dlp \
    && echo "${YTDLP_SHA256}  /usr/local/bin/yt-dlp" | sha256sum -c - \
    && chmod 0755 /usr/local/bin/yt-dlp \
    && /usr/local/bin/yt-dlp --version

# n8n отдельно, затем puppeteer-core в тот же глобальный node_modules
RUN npm install -g n8n@1.123.18
RUN npm install -g puppeteer-core@21.11.0

RUN mkdir -p ${N8N_USER_FOLDER} && chown -R node:node ${N8N_USER_FOLDER}

USER node
WORKDIR ${N8N_USER_FOLDER}

# Проверка всех инструментов при сборке
RUN yt-dlp --version && ffmpeg -version && n8n --version && chromium --version

EXPOSE 5678
CMD ["n8n"]
