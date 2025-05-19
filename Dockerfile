FROM ubuntu:22.04

ENV LANG=C.UTF-8
WORKDIR /workspace

# Install Python, pip, and required system libraries
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev \
    libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 \
    ffmpeg wget git vim \
    && rm -rf /var/lib/apt/lists/*

# Install Essentia + dependencies from PyPI
RUN pip3 install --no-cache-dir \
    essentia-tensorflow \
    requests \
    scikit-learn \
    numpy \
    pyyaml \
    six

# Clone your Jellyfin playlist project
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git /workspace

# Set PYTHONPATH to ensure Python finds Essentia
ENV PYTHONPATH=/usr/local/lib/python3/dist-packages

# Default command (for testing: keep container alive)
CMD ["tail", "-f", "/dev/null"]
