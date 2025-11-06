# База: Debian slim с Node 20
FROM node:20-bullseye-slim

# 1) Базовые env
ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    N8N_USER_FOLDER="/home/node/.n8n"

# 2) Системные зависимости
# --no-install-recommends уменьшает размер образа и снижает риск "втащить" X11/GUI
# Добавлены:
# - ghostscript + poppler-utils: PDF/PS конвертации (часто нужны в нодах)
# - tesseract-ocr-eng, tesseract-ocr-rus: языковые данные сразу "из коробки"
# - sox, git, python3, pip: полезны для множества нод и скриптов
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ffmpeg \
    imagemagick \
    ghostscript \
    poppler-utils \
    libreoffice \
    tesseract-ocr \
    tesseract-ocr-eng \
    tesseract-ocr-rus \
    jq \
    sqlite3 \
    sox \
    git \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

# 3) Разрешаем ImageMagick читать/писать PDF (иначе часто ловят "not authorized `PDF`")
# В некоторых сборках policy.xml может отсутствовать — поэтому && true
RUN set -eux; \
  if [ -f /etc/ImageMagick-6/policy.xml ]; then \
    sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/g' /etc/ImageMagick-6/policy.xml || true; \
  fi; \
  if [ -f /etc/ImageMagick/policy.xml ]; then \
    sed -i 's/rights="none" pattern="PDF"/rights="read|write" pattern="PDF"/g' /etc/ImageMagick/policy.xml || true; \
  fi

# 4) Установка n8n (оставлено без изменений по версии)
RUN npm install -g n8n@1.107.4

# 5) Рабочая директория и права
RUN mkdir -p ${N8N_USER_FOLDER} && chown -R node:node ${N8N_USER_FOLDER}
WORKDIR ${N8N_USER_FOLDER}

# 6) Пользователь (как у тебя)
USER node

# 7) Порт (как у тебя)
EXPOSE 5678

# 8) Старт (как у тебя)
CMD ["n8n"]
