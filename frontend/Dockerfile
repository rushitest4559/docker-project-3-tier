FROM node:18-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:1.25.3-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80