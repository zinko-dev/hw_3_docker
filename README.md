# ДЗ по Docker

У меня выполнены задания для 4, 6 и 8 баллов. Более подробная история команд находится в logs.txt

## Настройки

Перед запуском создайте .env на основе .env.example:

- `APP_PORT` - порт приложения на компьютере (по умолчанию 8080)
- `GREETING` - приветствие, которое возвращает приложение

Запуск: ```docker compose up -d --build
```

Проверка состояния: ```docker compose ps
```

Остановка: ```docker compose down
```

Остановка с удалением данных: ```docker compose down -v
```

## Выполненные действия для получения 8 баллов:

### 1. Настраиваем файлы Dockerfile и compose.yaml

### 2. Запускаем контейнер через Docker Compose, проверен запуск app и redis:

docker compose up -d --build
docker compose ps
NAME           IMAGE              COMMAND                  SERVICE   CREATED              STATUS                        PORTS
hw_3-app-1     hw_3-app           "python app.py"          app       About a minute ago   Up 59 seconds (healthy)       127.0.0.1:8080->8000/tcp
hw_3-redis-1   redis:7.4-alpine   "docker-entrypoint.s…"   redis     About a minute ago   Up About a minute (healthy)   6379/tcp

### 3. Проверяем GET и POST запросы: 

curl -fsS http://127.0.0.1:8080/
curl -fsS -X POST http://127.0.0.1:8080/increment
curl -fsS http://127.0.0.1:8080/readyz
{"greeting": "whatever shall i compose?!?!", "count": 0, "hostname": "c6fc23932537", "storage": "redis"}
{"greeting": "whatever shall i compose?!?!", "count": 1, "hostname": "c6fc23932537", "storage": "redis"}
{"status": "ready", "storage": "redis"}

### 4. Фиксируем N = 4: 

curl -fsS -X POST http://127.0.0.1:8080/increment                  
curl -fsS -X POST http://127.0.0.1:8080/increment       
curl -fsS -X POST http://127.0.0.1:8080/increment
{"greeting": "whatever shall i compose?!?!", "count": 2, "hostname": "c6fc23932537", "storage": "redis"}
{"greeting": "whatever shall i compose?!?!", "count": 3, "hostname": "c6fc23932537", "storage": "redis"}
{"greeting": "whatever shall i compose?!?!", "count": 4, "hostname": "c6fc23932537", "storage": "redis"}

### 5. Останавливаем и удаляем контейнер, затем создаем заново. Данные сохраняются (N = 4), доступно изменение (N' = 5):

docker compose down
docker compose up -d

curl -fsS http://127.0.0.1:8080/
curl -fsS -X POST http://127.0.0.1:8080/increment
curl -fsS http://127.0.0.1:8080/readyz
{"greeting": "whatever shall i compose?!?!", "count": 4, "hostname": "dd8339359736", "storage": "redis"}
{"greeting": "whatever shall i compose?!?!", "count": 5, "hostname": "dd8339359736", "storage": "redis"}
{"status": "ready", "storage": "redis"}

### 6. Останавливаем контейнер Redis, проверяем недоступность данных; app продолжает работать:

docker compose stop redis

curl -fsS http://127.0.0.1:8080/
curl -fsS -X POST http://127.0.0.1:8080/increment
curl -fsS http://127.0.0.1:8080/readyz
curl: (22) The requested URL returned error: 503
curl: (22) The requested URL returned error: 503
curl: (22) The requested URL returned error: 503

curl -fsS http://127.0.0.1:8080/healthz
{"status": "alive"}

docker compose ps
NAME         IMAGE      COMMAND           SERVICE   CREATED         STATUS                   PORTS
hw_3-app-1   hw_3-app   "python app.py"   app       4 minutes ago   Up 4 minutes (healthy)   127.0.0.1:8080->8000/tcp

### 7. Запускаем Redis, данные сохраняются (N' = 5), доступно изменение:

docker compose start redis

docker compose ps
NAME           IMAGE              COMMAND                  SERVICE   CREATED         STATUS                    PORTS
hw_3-app-1     hw_3-app           "python app.py"          app       5 minutes ago   Up 5 minutes (healthy)    127.0.0.1:8080->8000/tcp
hw_3-redis-1   redis:7.4-alpine   "docker-entrypoint.s…"   redis     5 minutes ago   Up 48 seconds (healthy)   6379/tcp

curl -fsS http://127.0.0.1:8080/
curl -fsS -X POST http://127.0.0.1:8080/increment
curl -fsS http://127.0.0.1:8080/readyz
{"greeting": "whatever shall i compose?!?!", "count": 5, "hostname": "dd8339359736", "storage": "redis"}
{"greeting": "whatever shall i compose?!?!", "count": 6, "hostname": "dd8339359736", "storage": "redis"}
{"status": "ready", "storage": "redis"}