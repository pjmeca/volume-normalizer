# pjmeca/volume-normalizer

[![GitHub Repo stars](https://img.shields.io/github/stars/pjmeca/volume-normalizer?style=flat&logo=github&label=Star%20this%20repo!)](https://github.com/pjmeca/volume-normalizer)
[![Docker Image Version (tag)](https://img.shields.io/docker/v/pjmeca/volume-normalizer/latest?logo=docker)](https://hub.docker.com/r/pjmeca/volume-normalizer)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/pjmeca/volume-normalizer/docker-image.yml?branch=main)

This Docker image normalizes the volume of your entire music library using [rsgain](https://github.com/complexlogic/rsgain). Your audio files will not be modified; only a metadata tag with the ReplayGain value will be added or updated (more details can be found in the [rsgain repo](https://github.com/complexlogic/rsgain)).

I created this image because I couldn't find a way to run rsgain periodically using cron in a container, as it can take a long time to process all the files in a large library.

You can find the Dockerfile and all the resources I used to create this image in [my GitHub repository](https://github.com/pjmeca/volume-normalizer). If you find this useful, please leave a ⭐. Feel free to request new features *or make a pull request if you're up for it!* 💪

## Usage

The following example creates a container that normalizes your music library everyday at 4 AM. You can configure how rsgain behaves by passing arguments via the `ADDITIONAL_ARGS` environment variable and define your own presets by mounting a preset file (by default, the `no_album` preset is used).

### Using docker run:

```sh
docker run -d --name volume-normalizer -v /your/main/music/path:/mnt -v /your/preset.ini:/root/.config/rsgain/presets/user_preset.ini:ro -v /etc/localtime:/etc/localtime:ro -e CRON_SCHEDULE="0 4 * * *" -e ADDITIONAL_ARGS="-S" --restart unless-stopped pjmeca/volume-normalizer:latest
```

### Using docker-compose:

```yml docker-compose.yml
name: volume-normalizer

services:
  volume-normalizer:
    image: pjmeca/volume-normalizer:latest
    container_name: volume-normalizer
    volumes:
      - /your/main/music/path:/mnt # Change this
      #- /your/preset.ini:/root/.config/rsgain/presets/user_preset.ini:ro # Custom preset
      - /etc/localtime:/etc/localtime:ro
    environment:
      CRON_SCHEDULE: "0 4 * * *" # Customize your cron if needed
      # ADDITIONAL_ARGS: "-S" # Additional arguments
    restart: unless-stopped
```

Then run:

```
docker compose -f ./docker-compose.yml up -d
```

## Output example

```
Cron configured to run with 0 4 * * *: At 04:00
Starting rsgain...
[✔] Applying preset 'no_album'...
[✔] Building directory tree...
[✔] Found 224 directories...
[✔] Scanning directories for files...
[✔] Scanning with 4 threads...
Scanning Complete
Time Elapsed:      00:42:53
Files Scanned:     10830
Clip Adjustments:  308 (2.8% of files)
Average Gain:      -6.46 dB
Average Peak:      0.944932 (-0.49 dB)
Negative Gains:    9916 (91.6% of files)
Positive Gains:    914 (8.4% of files)
Job finished.
Sleeping until next run.
```

## TODO list

Here are some pending ideas that I might try to implement if needed. I am open to suggestions.

- [x] Reduce image size
- [x] ~~Optionally pass arguments to rsgain using environment variables~~ A preset file will be used instead (suggested in [#1](https://github.com/pjmeca/volume-normalizer/issues/1))
- [ ] Omit previously scanned files (possibly by storing them in a SQLite database)

## Changelog

- 1.4.0: Add HEALTHCHECK
- 1.3.2: Store environment variables in `/etc/environment` for cron to read
- 1.3.1: Fix line endings from CRLF to LF
- 1.3.0
  - Upgrade rsgain to v3.5.1
  - Customize rsgain arguments
- 1.2.0: Mount a custom preset file
- 1.1.0: Reduce Docker image size
- 1.0.0: Initial release

## Special Thanks To

- The [rsgain project](https://github.com/complexlogic/rsgain) for providing the core functionality of this image.
- The [cron project](https://github.com/lnquy/cron) for offering an easy way to display cron expressions in a human-friendly way.