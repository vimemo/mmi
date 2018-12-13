#
# ---- Base Node ----
FROM alpine AS base

# Add packages
RUN apk add --update --no-cache \
  build-base \
  nodejs-current \
  curl \
  npm \
  tzdata

WORKDIR /app

# Install
COPY ./shared-libs ./shared-libs
COPY ./webapp/package.json ./webapp/package.json
COPY ./admin/package.json ./admin/package.json


#
# ---- Dependencies ----
From base AS dependencies
# install deps
RUN npm ci --silent
RUN npm rebuild node-sass
RUN npm i -D jit-grunt

#
# ---- Test ----
from dependencies as test
COPY . .

RUN yarn global add grunt-cli

# Expose port
EXPOSE 5988

# Start up
#CMD ["docker/app/startup.sh"]
CMD ["grunt", "dev-webapp"]
