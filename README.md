# haraka-docker

_Containerised setup for running `haraka` SMTP server._

This is an opinionated setup and installs some external plugins by default. You can use it as a [base image](./Dockerfile) and tweak the base plugins.

## Running

For a complete example, visit [docker-compose.yml](docker-compose.yml). You're expected to tweak this file and adjust it for your needs.

### Tags

You can view the available tags [here](https://github.com/mr-karan/haraka-docker/pkgs/container/haraka).

- `ghcr.io/mr-karan/haraka:3.0.0`
- `ghcr.io/mr-karan/haraka:latest`

## Considerations

`haraka` has a weird structure of mixing the data and config files in a single directory (`/etc/haraka/config` and `/etc/haraka` respectively). Since `/etc/haraka/config` and `/etc/haraka` are overlapping directories, it's impossible to do a bind mount of `/etc/haraka` on the host if you have a mount for the config directory.

It's possible to overcome this with `docker volumes` and some amount of little shell-scripting in _entrypoint_. The drawback of using docker volumes is the inability to mount `accounting_files` directory (`accounting_files` plugin uses this to store SMTP logs) to the host and let an external log collection agent pick it up.

These are some of the **opinionated decisions** undertook to overcome the above directory issues:

- `/queue` is a symlink to the actual queue directory that `haraka` uses. The symlink makes it easier to mount to an external drive in `docker` with bind mounts.
- `smtp_logs` folder is created for storing SMTP Logs that the `accounting-files` plugin uses. You're expected to tweak the plugin's config file to store the logs in this directory.
- `/haraka/config` folder is a _read only_ mount. Any kind of config changes must be done outside of the container.

### Adding Plugins

You can use this as the base image and add support for more plugins in your own `Dockerfile`.
