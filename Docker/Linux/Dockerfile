FROM ghcr.io/cirruslabs/flutter:3.22.0

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    clang \
    cmake \
    libgtk-3-dev \
    liblzma-dev \
    ninja-build \
    pkg-config \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN flutter config --enable-linux-desktop

CMD ["flutter", "--version"]
