FROM nginx:latest

COPY build /usr/share/nginx/html

RUN chown -R nginx:nginx /usr/share/nginx/html

EXPOSE 8081

LABEL org.opencontainers.image.source https://github.com/arthureichelberger/trailrapp
