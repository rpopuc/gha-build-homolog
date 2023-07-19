# Dockerfile para criar um container com Nginx servindo página estática
FROM nginx:latest

# Copia o arquivo index.html para dentro do container
COPY src/* /usr/share/nginx/html/