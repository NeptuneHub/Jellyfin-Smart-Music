FROM ubuntu:22.04

ENV LANG=C.UTF-8

WORKDIR /workspace

# Install system packages
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev \
    build-essential \
    libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 \
    ffmpeg libavcodec-dev libavformat-dev libavutil-dev libavresample-dev \
    wget git vim pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN pip3 install --no-cache-dir \
    essentia-tensorflow \
    requests \
    scikit-learn \
    numpy \
    pyyaml \
    six

# Clone your Jellyfin Essentia Playlist project
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git /workspace

# Set PYTHONPATH so Essentia is discoverable
ENV PYTHONPATH=/usr/local/lib/python3/dist-packages

# Default command to keep container running
CMD ["tail", "-f", "/dev/null"]
