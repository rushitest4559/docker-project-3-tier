FROM node:18-alpine
WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

COPY . .
RUN chmod +x entrypoint.sh
USER node
EXPOSE 3500

ENTRYPOINT ["./entrypoint.sh"]
CMD ["node", "server.js"]