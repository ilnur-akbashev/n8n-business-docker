FROM node:20-bullseye-slim

# Базовые ENV
ENV DEBIAN_FRONTEND=noninteractive \
    NODE_ENV=production \
    N8N_USER_FOLDER="/home/node/.n8n"

# Системные зависимости, которые нужны для большинства нод n8n:
# - ffmpeg — для медиа-операций (частые функции в нодах)
# - curl, git — для запросов/инсталляций
# - sqlite3 — для SQLite нод и локальных БД
# - python3, pip — для скриптов нод Script/Python
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    ffmpeg \
    sqlite3 \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Установка n8n (как было)
RUN npm install -g n8n@1.107.4

# Создание рабочей директории
RUN mkdir -p ${N8N_USER_FOLDER} && chown -R node:node ${N8N_USER_FOLDER}
WORKDIR ${N8N_USER_FOLDER}

# Пользователь
USER node

# Порт n8n
EXPOSE 5678

# Запуск n8n
CMD ["n8n"]
