FROM ubuntu:18.04

ENV LANG C.UTF-8

# Install system dependencies and tools
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    python3-pip \
    python3-numpy-dev \
    python3-six \
    libfftw3-3 \
    libyaml-0-2 \
    libtag1v5 \
    libsamplerate0 \
    libavcodec57 \
    libavformat57 \
    libavutil55 \
    libavresample3 \
    wget \
    curl \
    pkg-config \
    libeigen3-dev \
    vim \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python packages
RUN python3 -m pip install --upgrade pip setuptools \
    && pip3 install --no-cache-dir \
        tensorflow==1.15.0 \
        requests \
        scikit-learn \
        numpy \
        pyyaml

# Install build-time dependencies and build Essentia
RUN apt-get update && apt-get install -y \
    libfftw3-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libavresample-dev \
    libsamplerate0-dev \
    libtag1-dev \
    libyaml-dev

# Build and install Essentia with TensorFlow support
RUN mkdir -p /essentia /usr/local/lib/pkgconfig \
    && cd /essentia \
    && git clone https://github.com/MTG/essentia.git \
    && cd /essentia/essentia \
    && git submodule update --init --recursive \
    && src/3rdparty/tensorflow/setup_from_python.sh \
    && echo "Requires: python3" >> /usr/local/lib/pkgconfig/tensorflow.pc \
    && python3 waf configure --build-static --with-python --with-examples --with-vamp --with-tensorflow \
    && python3 waf && python3 waf install && ldconfig

# Clean up build dependencies
RUN apt-get remove -y \
    build-essential \
    libyaml-dev \
    libfftw3-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libavresample-dev \
    libsamplerate0-dev \
    libtag1-dev \
    python3-numpy-dev \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /essentia

# Download pretrained TensorFlow mood model used by Essentia
RUN mkdir -p /models \
    && curl --fail --show-error --location \
       -o /models/music_mood_tempo-effnet-bs64-1.pb \
       https://essentia.upf.edu/models/classifiers/music/music_mood_tempo-effnet-bs64-1.pb

# Set environment variable so Essentia can find the model
ENV ESSENTIA_MODELS_DIR=/models

# Clone your playlist repository
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git /workspace

# Set PYTHONPATH and working directory
ENV PYTHONPATH=/usr/local/lib/python3/dist-packages
WORKDIR /workspace

# Prevent the container from exiting immediately
CMD ["tail", "-f", "/dev/null"]
