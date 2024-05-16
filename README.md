# pjmeca/volume-normalizer

This Docker image normalizes the volume of your entire music library using [rsgain](https://github.com/complexlogic/rsgain). Your audio files will not be modified; only a metadata tag with the ReplayGain value will be added or updated (more details can be found in the [rsgain repo](https://github.com/complexlogic/rsgain)).

I created this image because I couldn't find a way to run rsgain periodically using cron in a container, as it can take a long time to process all the files in a large library.

You can find the Dockerfile and all the resources I used to create this image in [my GitHub repository](https://github.com/pjmeca). If you find this useful, please leave a ⭐. Feel free to request new features *or make a pull request if you're up for it!* 💪

## Usage

The following example creates a container that normalizes your music library everyday at 4 AM.

### Using docker run:

```sh
docker run -d --name volume-normalizer -v /your/main/music/path:/mnt -v /etc/localtime:/etc/localtime:ro -e CRON_SCHEDULE="0 4 * * *" --restart unless-stopped pjmeca/volume-normalizer:latest
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
      - /etc/localtime:/etc/localtime:ro
    environment:
      CRON_SCHEDULE: "0 4 * * *" # Customize your cron if needed
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

- [ ] Reduce image size
- [ ] Optionally pass arguments to rsgain using environment variables
- [ ] Omit previously scanned files (possibly by storing them in a SQLite database)