# Dockerfile
FROM node:18

# create destination directory
RUN mkdir -p /app
WORKDIR /app

# update and install dependency
RUN apt-get update
RUN apt install git

# copy the app, note .dockerignore
COPY . /app/
RUN npm install
RUN npm run build

EXPOSE 3023

ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3023

CMD [ "npm", "run", "dev" ]