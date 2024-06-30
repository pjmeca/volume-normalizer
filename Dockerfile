FROM alpine:3.12 AS download-hcron
ARG HCRON_URL=https://github.com/lnquy/cron/releases/download/v1.0.1/hcron_1.0.1_linux_x86_64.tar.gz
RUN apk add --no-cache curl tar && \
    curl -L $HCRON_URL -o /tmp/hcron.tar.gz && \
    tar -xzf /tmp/hcron.tar.gz -C /usr/local/bin && \
    rm /tmp/hcron.tar.gz

# Based on the original Dockerfile by rsgain
# https://github.com/complexlogic/rsgain/blob/master/Dockerfile
FROM debian:bookworm
LABEL org.label-schema.name="pjmeca/volume-normalizer" \
    org.label-schema.description="This Docker image normalizes the volume of your entire music library using rsgain." \
    org.label-schema.url="https://hub.docker.com/r/pjmeca/volume-normalizer" \
    org.label-schema.vcs-url="https://github.com/pjmeca/volume-normalizer" \
    org.label-schema.version="1.2.0" \
    org.label-schema.schema-version="1.0.0-rc.1" \
    org.label-schema.docker.cmd="docker run -d --name volume-normalizer -v /your/main/music/path:/mnt -v /your/preset.ini:/root/.config/rsgain/presets/user_preset.ini:ro -v /etc/localtime:/etc/localtime:ro -e CRON_SCHEDULE=\"0 4 * * *\" --restart unless-stopped pjmeca/volume-normalizer:latest" \
    maintainer="pjmeca"
WORKDIR /app
ENV CRON_SCHEDULE="0 */1 * * *"
COPY --from=download-hcron /usr/local/bin/hcron .
ARG VERSION=3.5.1 \
    ARCH=amd64
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates openssl cron && \
    curl -sSL -o /tmp/rsgain.deb "https://github.com/complexlogic/rsgain/releases/download/v${VERSION}/rsgain_${VERSION}_${ARCH}.deb" && \
    apt install -y --no-install-recommends /tmp/rsgain.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/rsgain.deb
RUN mkdir -p ~/.config/rsgain/presets && \
    touch ~/.config/rsgain/presets/user_preset.ini
COPY start_rsgain.sh start.sh ./
RUN chmod +x start_rsgain.sh start.sh
CMD ["./start.sh"]