# Build
FROM node:19.2-alpine as builder
RUN mkdir /app
WORKDIR /app

# Copy app dependencies.
COPY angular-app/packages.json angular-app/package-lock.json
/app/angular-app/

# Install app dependencies
RUN npm install --prefix angular-app

# Copy app files.
COPY . /app

# Build app
RUN npm run build --prefix angular-app -- --output-path=./dist/out

# Delivery
FROM nginx:1.23.2-alpine

# Remove default ngix website
RUN rm -rf /usr/share/nginx/html/*

# Copy output directory from builder to nginx image.
COPY --from=builder /app/angular-app/dist/out /usr/share/nginx/html

# Copy nginx configuration file.
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

