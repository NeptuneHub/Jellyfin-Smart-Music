FROM ubuntu:22.04

ENV LANG=C.UTF-8
WORKDIR /workspace

# Install Python, pip, and required system libraries
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev \
    libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 \
    ffmpeg wget git vim \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages with specific numpy version
RUN pip3 install --no-cache-dir \
    numpy==1.23.5 \
    essentia-tensorflow \
    requests \
    scikit-learn \
    pyyaml \
    six

# Create models directory and download the correct model
RUN mkdir -p /models && \
    wget -O /models/music_mood_tempo-effnet-bs64-1.pb \
    https://essentia.upf.edu/models/classification-head/music_mood_tempo-effnet-bs64-1.pb

# Clone your Jellyfin playlist project
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git /workspace

# Set PYTHONPATH to ensure Python finds Essentia
ENV PYTHONPATH=/usr/local/lib/python3/dist-packages
ENV ESSENTIA_MODELS_DIR=/models

# Default command (for testing: keep container alive)
CMD ["tail", "-f", "/dev/null"]
