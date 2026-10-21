#!/bin/zsh
# H-042 / H-095 uçtan uca: yalıtılmış ikinci backend (port 8090, veritabanı hivelzon_e2e).
# Pilot backend'ine (8080) ve "hivelzon" veritabanına dokunmaz. Posta: projenin Mailpit'i (SMTP 1027).
# Önce: docker exec hivelzon-postgres createdb -U hivelzon hivelzon_e2e
#       (cd backend && mvn -B -q package -DskipTests)
set -u
here=${0:A:h}
cd "$here/../../backend"
export HIVELZON_DB_URL=jdbc:postgresql://localhost:5435/hivelzon_e2e
export HIVELZON_PORT=8090
export HIVELZON_JWT_SECRET="$(openssl rand -base64 48 | tr -d '\n')"
export HIVELZON_OTP_PEPPER="$(openssl rand -hex 24)"
# Yerel sırlar (ücretli TTS anahtarı) okunmasın.
export HIVELZON_LOCAL_CONFIG=/nonexistent/hivelzon-e2e.yml
# Kalıcı silme işi sık çalışsın (yalnızca süresi dolmuş hesapları siler).
exec java -jar target/hivelzon-backend-0.0.1-SNAPSHOT.jar \
  --hivelzon.jobs.purge-cron="*/10 * * * * *"
