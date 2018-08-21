FROM cypress/base:8
RUN node --version
RUN npm --version

ADD package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /app && cp -a /tmp/node_modules /app/

WORKDIR /app
ADD . /app
RUN $(npm bin)/cypress verify
RUN ls -l