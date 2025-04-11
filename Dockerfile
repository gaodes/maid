FROM ruby:3.4-slim

# Install required dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libyaml-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Clone the Maid repository directly from GitHub
RUN git clone https://github.com/maid/maid.git . \
    # Remove "dubious ownership" error messages
    && git config --global --add safe.directory /app \
    && bundle install \
    && gem build maid.gemspec \
    && gem install maid-*.gem

# Create default maid directory structure including logs
RUN mkdir -p /root/.maid/logs && chmod -R 755 /root/.maid

# Set environment variable as in the original Dockerfile
ENV ISOLATED=true

# Use tail -f /dev/null to keep the container running indefinitely
ENTRYPOINT ["tail", "-f", "/dev/null"]