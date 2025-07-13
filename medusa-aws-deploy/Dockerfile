FROM node:18-alpine

WORKDIR /app

COPY . .

RUN npm install && npm run build

CMD ["sh", "-c", "cd .medusa/server && npm install && npm run predeploy && npm run start"]
