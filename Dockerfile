# Use Node.js for building
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# Copy the rest of the application code
COPY . . 

# Set React version dynamically
ARG REACT_APP_VERSION=v1
ENV REACT_APP_VERSION=${REACT_APP_VERSION}

# Increase memory limit for React builds
ENV NODE_OPTIONS="--max-old-space-size=2048"

# Build the React application
RUN npm run build

# Use Nginx for serving the app
FROM nginx:alpine

# Copy the built files to the Nginx directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
