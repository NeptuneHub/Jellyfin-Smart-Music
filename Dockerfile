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

# Create and activate a virtual environment for python packages
WORKDIR /opt
RUN python3.11 -m venv venv

# Upgrade pip and install python packages inside the venv
RUN /opt/venv/bin/pip install --upgrade pip
RUN /opt/venv/bin/pip install numpy scipy requests scikit-learn tensorflow==2.15.0

# Clone Essentia repo
RUN git clone --recursive https://github.com/MTG/essentia.git /opt/essentia

# Create build directory inside essentia repo
RUN mkdir -p /opt/essentia/build

# Build Essentia with Python bindings & TensorFlow extractors using venv python
WORKDIR /opt/essentia/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release \
    -DBUILD_SHARED_LIBS=OFF \
    -DBUILD_PYTHON_BINDINGS=ON \
    -DPYTHON_EXECUTABLE=/opt/venv/bin/python \
    -DBUILD_TENSORFLOW_EXTRACTORS=ON \
    -DEIGEN3_INCLUDE_DIR=/usr/include/eigen3

RUN make -j$(nproc)
RUN make install && ldconfig

# Clone Jellyfin-Essentia-Playlist repo
WORKDIR /workspace
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git

WORKDIR /workspace/Jellyfin-Essentia-Playlist

# Activate the virtual environment by default on container start
ENV PATH="/opt/venv/bin:$PATH"

CMD ["/bin/bash"]
