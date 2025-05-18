FROM debian:bullseye

# Set non-interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    vim \
    python3.11 \
    python3.11-venv \
    python3.11-dev \
    python3-pip \
    libfftw3-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libsamplerate0-dev \
    libtag1-dev \
    libyaml-dev \
    libeigen3-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libtensorflow-dev \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory
WORKDIR /opt

# Clone essentia source
RUN git clone https://github.com/MTG/essentia.git --recursive

# Compile essentia with TensorFlow support
WORKDIR /opt/essentia/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_PYTHON_BINDINGS=ON \
    -DPYTHON_EXECUTABLE=/usr/bin/python3.11 \
    -DBUILD_TENSORFLOW_EXTRACTORS=ON \
    -DEIGEN3_INCLUDE_DIR=/usr/include/eigen3
RUN make -j$(nproc)
RUN make install && ldconfig

# Install Python dependencies
WORKDIR /opt
RUN python3.11 -m pip install --upgrade pip
RUN python3.11 -m pip install numpy scipy requests sklearn tensorflow==2.15.0

# Clone your Jellyfin-Essentia-Playlist repo
WORKDIR /workspace
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git
WORKDIR /workspace/Jellyfin-Essentia-Playlist

# Set default entrypoint
CMD ["/bin/bash"]
