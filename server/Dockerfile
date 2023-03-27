FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ENV NODE_ENV $NODE_ENV
EXPOSE $PORT
CMD [ "npm", "start" ]