FROM node:14.17.1-alpine3.13 AS dependencies

RUN mkdir /app
WORKDIR /app

COPY ./package.json package.json
COPY ./package-lock.json package-lock.json

RUN npm ci

FROM node:14.17.1-alpine3.13

 RUN mkdir /app
 WORKDIR /app
COPY --from=dependencies /app/node_modules node_modules
COPY . .

USER node
EXPOSE 80
ENTRYPOINT ["npm"]
CMD ["start"]