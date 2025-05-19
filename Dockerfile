FROM ubuntu:22.04

ENV LANG=C.UTF-8
WORKDIR /workspace

# Install Python, pip, and required system libraries
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev \
    libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 \
    ffmpeg wget git vim \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages with compatible numpy for essentia-tensorflow
RUN pip3 install --no-cache-dir \
    numpy==1.21.6 \
    essentia-tensorflow \
    requests \
    scikit-learn \
    pyyaml \
    six

# Clone your Jellyfin playlist project
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git /workspace

# Download the correct Essentia mood/theme model
RUN mkdir -p /models && \
    wget -O /models/mtg_jamendo_moodtheme-discogs-effnet-1.pb \
    https://essentia.upf.edu/models/classification-heads/mtg_jamendo_moodtheme/mtg_jamendo_moodtheme-discogs-effnet-1.pb

# Set environment variable for Essentia to find the model
ENV ESSENTIA_MODELS_DIR=/models

# Set PYTHONPATH to ensure Python finds Essentia
ENV PYTHONPATH=/usr/local/lib/python3/dist-packages

# Default command (for testing/debugging)
CMD ["tail", "-f", "/dev/null"]
