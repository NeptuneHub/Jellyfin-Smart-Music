FROM python:3.9-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libyaml-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libsamplerate0-dev \
    libtag1-dev \
    libfftw3-dev \
    libeigen3-dev \
    libboost-all-dev \
    build-essential \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip install --upgrade pip \
 && pip install essentia-tensorflow tensorflow-cpu numpy requests scikit-learn

# Set working directory
WORKDIR /workspace

# Add your files (script, config, etc.)
COPY . .

# Download model if not provided
RUN mkdir -p /models && \
    wget -O /models/music_mood_tempo-effnet-bs64-1.pb https://essentia.upf.edu/models/music_mood_tempo-effnet-bs64-1.pb

# Set model environment variable
ENV ESSENTIA_MODELS_DIR=/models

# Run the main script
CMD ["python", "audio_jelly_tensorflow.py"]
