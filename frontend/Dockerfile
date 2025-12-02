FROM node:18-alpine AS build
WORKDIR /app

COPY package*.json
RUN npm ci --only=production && npm cache clean --force

COPY . .
RUN npm run build

FROM nginx:1.25.3-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY --from=build /app/myapp.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/entrypoint.sh /docker-entrypoint.d/

EXPOSE 80