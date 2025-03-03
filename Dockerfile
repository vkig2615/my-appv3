FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Set the React version dynamically
ARG REACT_APP_VERSION=v1
ENV REACT_APP_VERSION=${REACT_APP_VERSION}

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
