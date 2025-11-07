FROM node:18-alpine
WORKDIR /app
COPY . .
RUN apk add --no-cache python3 g++ make cmake && yarn install --production
CMD ["node", "src/index.js"]
EXPOSE 3000
