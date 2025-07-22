FROM node:18-bullseye-slim

# Установка зависимостей
RUN apt-get update && apt-get install -y \
  ffmpeg \
  curl \
  tesseract-ocr \
  imagemagick \
  libreoffice \
  jq \
  sqlite3 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка n8n
RUN npm install -g n8n@1.83.2

# Создание рабочей директории
ENV N8N_USER_FOLDER="/home/node/.n8n"
RUN mkdir -p ${N8N_USER_FOLDER} && chown -R node:node ${N8N_USER_FOLDER}
WORKDIR ${N8N_USER_FOLDER}

# Пользователь
USER node

# Порт
EXPOSE 5678

# Старт
CMD ["n8n"]
