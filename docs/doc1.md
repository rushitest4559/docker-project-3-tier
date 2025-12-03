## Docker Files Explanation ##  

```bash
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
```  

This is our backend dockerfile, this image consists of 2 steps:
1. Install dependencies
2. Run backed server  

For running backend server we need node dependencies and we don't have to build code here, so therefore we skip multi stage build here.

COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force    
This lines in dockerfile does our first step which is installing dependencies, we only copy package.json and package-lock.json files here instead of copying all files because if we copy everything then even small changes in code reinstall all dependencies next time building image, so this approach makes our build faster next time for code changes until actually our dependencies are not modified.

After that we copy all files, we use *entrypoint*.sh script which purpose is make sure user enter environment variables values before starting container.
for node:18-alpine base image, there is no existing entrypoint present so we can safely put our entrypoint. entrypoint is basically a script which runs just before starting a container.
for services base images like nginx or mysql, if we have add entrypoint we cannot add like this because this services base images has their existing entrypoint scripts which must run which is reposible for start services in foreground, switching users and do other things. in this type of base images they provide empty directories like /docker.entrypoint.d/ or /docker-entrypoint.initdb.d/, we can put our custom entrypoint scripts in this folder for nginx or mysql type base images.

RUN chmod +x entrypoint.sh && chown node entrypoint.sh
this line gives the execute permissions for this script to node user, node user already create by node:18-alpine image, but we need to write USER node line in dockerfile because this base image only create user but run all instructions in dockerfile as root user until we explicitly change user.

This image total size after building is 154MB on host.    


```bash
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
```

This is our frontend multi stage dockerfile. It has mostly 3 phases
1. Install dependencies
2. Build code
3. Server static files
For installing dependencies we need node environment but for running code we dont node, so we use nginx for 3rd phase, so our final image size is optmized so much and it is 48.1MB on host.

COPY default.conf /etc/nginx/conf.d/default.conf
this line copy nginx config file from host and put into socker image at location /etc/nginx/conf.d/default.conf, this is our proxy file which is reponsible for sending /api/ traffic to backend container internally. 