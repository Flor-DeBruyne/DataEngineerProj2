FROM node:latest

WORKDIR /app

COPY ./node_modules ./node_modules
COPY package-lock.json package.json tailwind.config.js ./
RUN npm i react-scripts

COPY /public ./public
COPY /src ./src

EXPOSE 3000

CMD ["npm", "start"]
