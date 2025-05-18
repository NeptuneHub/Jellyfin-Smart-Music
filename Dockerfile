FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies, including some extras for build and debugging
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    vim \
    pkg-config \
    libcurl4-openssl-dev \
    libblas-dev \
    liblapack-dev \
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

# Set python3.11 as default
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Create working directory
WORKDIR /opt

# Clone essentia repo with submodules
RUN git clone https://github.com/MTG/essentia.git --recursive

# Build essentia with TensorFlow support - verbose output, stop and print errors if any
WORKDIR /opt/essentia/build

RUN cmake .. -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_PYTHON_BINDINGS=ON \
    -DPYTHON_EXECUTABLE=/usr/bin/python3.11 \
    -DBUILD_TENSORFLOW_EXTRACTORS=ON \
    -DEIGEN3_INCLUDE_DIR=/usr/include/eigen3 \
    -Wdev || (cat CMakeFiles/CMakeError.log && cat CMakeFiles/CMakeOutput.log && exit 1)

RUN make VERBOSE=1 -j$(nproc)
RUN make install && ldconfig

# Upgrade pip and install python dependencies
WORKDIR /opt
RUN python3.11 -m pip install --upgrade pip
RUN python3.11 -m pip install numpy scipy requests scikit-learn tensorflow==2.15.0

# Clone your Jellyfin-Essentia-Playlist repo
WORKDIR /workspace
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git
WORKDIR /workspace/Jellyfin-Essentia-Playlist

# Default to interactive shell for debugging after build
CMD ["/bin/bash"]
