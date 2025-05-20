FROM ubuntu:22.04

ENV LANG=C.UTF-8

# 1) Create a directory for your application code
WORKDIR /app

# 2) Install Python, pip, and required system libraries
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev \
    libfftw3-3 libyaml-0-2 libtag1v5 libsamplerate0 \
    ffmpeg wget git vim \
    && rm -rf /var/lib/apt/lists/*

# 3) Install Python packages with compatible numpy for essentia-tensorflow
RUN pip3 install --no-cache-dir \
    numpy==1.21.6 \
    essentia-tensorflow \
    requests \
    scikit-learn \
    pyyaml \
    six

# 4) Clone the Jellyfin‐Essentia‐Playlist project INTO /app
RUN git clone https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist.git /app

# 5) Download the Essentia mood/theme model
RUN mkdir -p /models && \
    wget -O /models/discogs-effnet-bs64-1.pb \
    https://essentia.upf.edu/models/music-style-classification/discogs-effnet/discogs-effnet-bs64-1.pb

# 6) Expose environment variables for Essentia
ENV ESSENTIA_MODELS_DIR=/models
ENV PYTHONPATH=/usr/local/lib/python3/dist-packages

# 7) Switch to /workspace when writing output, but ensure code still runs from /app
#    The CMD below explicitly calls /app/audio_jelly_tensorflow.py, 
#    while /workspace can be mounted by Kubernetes as a hostPath at runtime.

# Default working directory for runtime (so any relative writes go under /workspace)
WORKDIR /workspace

# 8) Run the main script from /app, then stay alive
CMD ["sh", "-c", "python3 -u audio_jelly_tensorflow.py || true && tail -f /dev/null"]
