<!-- Badges -->
<!-- ![Docker Pulls](https://img.shields.io/docker/pulls/anderpuqing/mindustry) -->
![Docker Image Size (latest)](https://img.shields.io/docker/image-size/anderpuqing/mindustry/latest?label=img%20size%20%28latest%29&logo=docker)

![Mindustry logo](https://raw.githubusercontent.com/AndPuQing/docker-mindustry/main/assets/mindustry-logo.png)

Mindustry is a hybrid tower-defense sandbox factory game. Create elaborate supply chains of conveyor belts to feed ammo into your turrets, produce materials to use for building, and defend your structures from waves of enemies.

## Usage

### Docker cli

```sh
docker run -it -d \
  --name mindustry \
  -p 6567:6567/tcp -p 6567:6567/udp \
  -v /path/to/config:/mindustry/config \
  --restart unless-stopped \
  anderpuqing/mindustry:latest
```

### Docker compose (recommended)

```yaml
version: "3.8"
services:
  mindustry:
    image: anderpuqing/mindustry:latest
    container_name: mindustry
    stdin_open: true
    tty: true
    volumes:
      - /path/to/config:/mindustry/config
    ports:
      - 6567:6567/tcp
      - 6567:6567/udp
    restart: unless-stopped
```

### Connect to console

Attaching to the console is useful to run commands like `host` that will start hosting a game, you won't be able to see previous logs this way as you will be greeted with an empty screen, but you can run commands there.

```sh
docker attach mindustry
```

## Configuration

Configuration for the server can be modified by using commands in the console, the full list of available commands can be found in the [official docs](https://mindustrygame.github.io/wiki/servers/#dedicated-server-configuration-options).

### Auto host

To automatically run the command `host` when starting the server, just run:

```sh
config startCommands host
```

The server will host a game the next time you start the container (as long as you keep the same `settings.bin` file).

## Tagging

There are two types of container tags used on this image: `latest` and `stable`; these are in addition to the specific version of the server which can always be picked instead and are **recommended**.

In case specific versions are too granular for you, I would recommend to use `stable` instead of `latest` if you are looking for the **latest stable** version of the image, which will likely run the same version of the game client that you start from Steam.

The `latest` tag instead runs the **latest pre-release** version that you can find on the [Github releases page](https://github.com/Anuken/Mindustry/releases) of the game, run this version of the image only if you are sure that you're using the latest pre-release game client.
