FROM node:18.4.0-buster
ARG HARAKA_VERSION=2.8.28

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

ENTRYPOINT [ "" ]
CMD [ "haraka", "-c", "/haraka" ]
