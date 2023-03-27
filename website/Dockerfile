FROM node:14-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build
ENV NODE_ENV $NODE_ENV
ENV PORT 3000
EXPOSE $PORT
CMD ["npm", "start"]
