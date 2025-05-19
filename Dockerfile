FROM ubuntu:22.04

ENV LANG C.UTF-8
WORKDIR /workspace

# Install system packages
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev \
    build-essential \
    libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 \
    ffmpeg libavcodec58 libavformat58 libavutil56 libavresample4 \
    wget git vim pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install essentia-tensorflow and other required Python packages
RUN pip3 install --no-cache-dir \
    essentia-tensorflow \
    requests \
    scikit-learn \
    numpy \
    pyyaml \
    six

# Clone the Jellyfin-Essentia-Playlist project
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git /workspace

# Set Python path for Essentia
ENV PYTHONPATH=/usr/local/lib/python3/dist-packages

# Run the container indefinitely by default
CMD ["tail", "-f", "/dev/null"]
