FROM node:18-alpine3.20

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY package.json /usr/src/app/
RUN npm install && \
  touch /usr/src/app/.env

COPY ./docker/docker-entrypoint.sh /usr/src/app/docker-entrypoint.sh
COPY . /usr/src/app

EXPOSE 9000

ENTRYPOINT "/usr/src/app/docker-entrypoint.sh"