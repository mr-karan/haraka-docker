# haraka-docker

_Containerised setup for running `haraka` SMTP server._

This is an opinionated setup and installs some external plugins by default. You're free to use it as a [base image](./Dockerfile) and tweak the base plugins.

## Running

For a full example, visit [docker-compose.yml](docker-compose.yml). You're expected to tweak this file and adjust for your own needs.

## Considerations

`haraka` has a weird structure of mixing the data and config files in a single directory which makes it a bit difficult to mount the entire directory from the container to the host (without docker volumes). These are the _opinionated_ things that this docker images does to overcome it:

- `/queue` is a symlink to the actual queue directory that `haraka` uses. The symlink makes it easier to mount to an external drive in `docker` with bind mounts.
- `smtp_logs` folder is created for storing SMTP Logs that the `accounting-files` plugin uses. You're expected to tweak the plugin's config file to store the logs here.
- `/haraka/config` folder is a _read only_ mount. Any kind of config changes must be done outside of the container.

### Adding Plugins

For now, you can use this as the base image and add support for more plugins in your own `Dockerfile`.
