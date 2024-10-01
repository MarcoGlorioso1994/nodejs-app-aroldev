FROM node
WORKDIR /usr/src/app
COPY package*.json ./
COPY . ./
RUN npm install
COPY . .
EXPOSE 8080
CMD [ "node", "index.js" ]