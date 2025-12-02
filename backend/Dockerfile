FROM node:18-alpine
WORKDIR /app
ARG CACHEBUST=1
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

COPY . .

RUN chmod +x entrypoint.sh && chown node entrypoint.sh

USER node
EXPOSE 3500
ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]

CMD ["node", "server.js"]