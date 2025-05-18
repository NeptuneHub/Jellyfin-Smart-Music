FROM debian:bookworm

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
    && rm -rf /var/lib/apt/lists/*

# Set python3.11 as default python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Upgrade pip and install Python packages
RUN python3.11 -m pip install --upgrade pip
RUN python3.11 -m pip install numpy scipy requests scikit-learn tensorflow==2.15.0

# Clone Essentia repo before build
WORKDIR /opt
RUN git clone https://github.com/MTG/essentia.git --recursive

# Create build directory inside cloned repo
WORKDIR /opt/essentia
RUN mkdir -p build

# Build Essentia with TensorFlow extractors enabled
WORKDIR /opt/essentia/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_PYTHON_BINDINGS=ON \
    -DPYTHON_EXECUTABLE=/usr/bin/python3.11 \
    -DBUILD_TENSORFLOW_EXTRACTORS=ON \
    -DEIGEN3_INCLUDE_DIR=/usr/include/eigen3 \
    -Wdev

RUN make -j$(nproc)
RUN make install && ldconfig

# Clone your Jellyfin-Essentia-Playlist repository
WORKDIR /workspace
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git
WORKDIR /workspace/Jellyfin-Essentia-Playlist

# Default command
CMD ["/bin/bash"]
