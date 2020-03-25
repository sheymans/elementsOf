FROM alpine
RUN apk add --update nodejs nodejs-npm
COPY . /src
WORKDIR /src
RUN npm install
ENTRYPOINT ["node", "./hi.js"]
EXPOSE 8111
LABEL maintainer="ben@ny.com"