FROM ubuntu:20.04

# Avoid tzdata and other interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3.8 python3.8-dev python3.8-distutils \
    curl wget git vim pkg-config \
    libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 \
    libavcodec58 libavformat58 libavutil56 libavresample4 \
    libeigen3-dev libyaml-dev libfftw3-dev libavcodec-dev \
    libavformat-dev libavresample-dev libsamplerate0-dev libtag1-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pip for Python 3.8
RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.8

# Install Python packages
RUN python3.8 -m pip install --upgrade pip setuptools wheel \
    && python3.8 -m pip install \
        numpy \
        scikit-learn \
        requests \
        cython \
        tensorflow==2.12.0 \
        protobuf==3.20

# Build and install Essentia from source
RUN mkdir -p /essentia && cd /essentia \
    && git clone https://github.com/MTG/essentia.git \
    && cd essentia \
    && git submodule update --init --recursive \
    && python3.8 src/3rdparty/tensorflow/setup_from_python.py \
    && echo "Requires: python3" >> /usr/local/lib/pkgconfig/tensorflow.pc \
    && python3.8 waf configure --build-static --with-python --with-examples --with-vamp --with-tensorflow \
    && python3.8 waf \
    && python3.8 waf install \
    && ldconfig

# Clone your project
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git /workspace

# Set environment for Python path and working dir
ENV PYTHONPATH=/usr/local/lib/python3.8/dist-packages
WORKDIR /workspace

# Default command
CMD ["tail", "-f", "/dev/null"]
