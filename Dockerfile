FROM alpine:3.12 AS download-hcron
ARG HCRON_URL=https://github.com/lnquy/cron/releases/download/v1.0.1/hcron_1.0.1_linux_x86_64.tar.gz
RUN apk add --no-cache curl tar && \
    curl -L $HCRON_URL -o /tmp/hcron.tar.gz && \
    tar -xzf /tmp/hcron.tar.gz -C /usr/local/bin && \
    rm /tmp/hcron.tar.gz

# Based on the original Dockerfile by rsgain
# https://github.com/complexlogic/rsgain/blob/master/Dockerfile
FROM debian:bookworm
WORKDIR /app
ENV CRON_SCHEDULE="0 */1 * * *"
COPY --from=download-hcron /usr/local/bin/hcron .
ARG VERSION=3.5 \
    ARCH=amd64
RUN apt-get update && \
    apt-get install -y curl ca-certificates openssl cron && \
    curl -sSL -o /tmp/rsgain.deb "https://github.com/complexlogic/rsgain/releases/download/v${VERSION}/rsgain_${VERSION}_${ARCH}.deb" && \
    apt install -y /tmp/rsgain.deb && \
    rm -rf /var/lib/apt/lists/* /tmp/rsgain.deb && \
    apt-get clean
COPY start_rsgain.sh start.sh ./
RUN chmod +x start_rsgain.sh start.sh
CMD ["./start.sh"]