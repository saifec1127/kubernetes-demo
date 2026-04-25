FROM node:20-alpine As base


WORKDIR /app

COPY package.json package-lock.json* ./

RUN npm ci --omit=dev

COPY . .

USER node

EXPOSE 3000

ENV NODE_ENV=production

CMD ["npm", "start"]