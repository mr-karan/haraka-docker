FROM node:18.4.0-buster

# Version of haraka to install. https://github.com/haraka/Haraka/releases.
ARG HARAKA_VERSION=2.8.28

# Install packages and build tools required for npm install of some plugins.
RUN apt-get update && apt-get install -y --no-install-recommends curl unzip bash vim \
    ca-certificates tzdata make \
    git rsync gettext-base \
    python3 gcc make \
    && apt-get clean && rm -fr /var/lib/apt/lists/*

# Installs haraka.
RUN npm install -g Haraka@${HARAKA_VERSION}
WORKDIR /haraka

# Sets up default config directories.
RUN haraka -i /haraka

# Install plugin for SMTP Logs.
RUN npm install "https://github.com/vishnus/haraka-plugin-accounting-files.git#haraka_new" --save
RUN mkdir -p /smtp_logs/accounting_files

# Symlink the queue folder to /queue so it can be mounted externally
RUN ln -s /queue /haraka/queue

# Override the entrypoint set in node base image.
ENTRYPOINT [ "" ]

# Run the app in non-daemon mode.
CMD [ "haraka", "-c", "/haraka" ]
