# 🎶 Jellyfin-Smart-Music

**Jellyfin-Smart-Music** is a Dockerized environment that brings smart playlist generation to [Jellyfin](https://jellyfin.org) using deep audio analysis via [Essentia](https://essentia.upf.edu/) with TensorFlow.
#
This project packages all required dependencies into a container and runs the [`Jellyfin-Essentia-Playlist`](https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist) script, which analyzes your Jellyfin music library and builds playlists based on tempo, key, energy, and more.

## 🎶 Jellyfin-Smart-Music
Jellyfin-Smart-Music is a Dockerized environment that brings smart playlist generation to Jellyfin using deep audio analysis via Essentia and TensorFlow.

This project packages all required dependencies into a container and runs the Jellyfin-Essentia-Playlist script, which analyzes your Jellyfin music library and builds playlists based on tempo, key, energy, and more.

## 🧭 Project Overview
* 🔍 Uses Essentia + TensorFlow 1.15 for audio feature extraction
* 📂 Runs the Jellyfin-Essentia-Playlist Python tool for smart playlist generation
* ✅ All dependencies are bundled — no manual setup needed
* 🛠️ Two runtime options:
  * Always-On Deployment: Ideal for development or interactive use
  * Scheduled CronJob: Runs automatically once daily

## 🏗️ Status: Development / MVP
This is a Minimum Viable Product (MVP), perfect for development, testing, and experimentation.

Why this setup?
* 🕒 Saves hours of dependency wrangling
* ⚡ Enables rapid iteration and tweaking
* 🎛️ Makes deep audio analysis available in one kubectl apply

## 🐳 Quick Start (K3s / Kubernetes)
✅ Prerequisites
* A running K3s or Kubernetes cluster
* A working Jellyfin server
* kubectl access to deploy manifests
* Mount a workspace volume for persistence
* Supply your Jellyfin API credentials via config (see below)

## 📦 Deployment Modes
We provide two manifests and corresponding Docker image tags:

🌀**1. Always-On Deployment**
* File: alwayson-deployment.yaml
* Image: ghcr.io/neptunehub/jellyfin-smart-music:latest-alwayson
* Runs continuously in the background
* Best for manual, interactive, or dev-focused workflows

🕒 **2. Scheduled CronJob**
* File: cronjob-deployment.yaml
* Image: ghcr.io/neptunehub/jellyfin-smart-music:latest-cronjob
* Runs once daily at 23:00 (11 PM) or edit the cronjob manifest for different timing
* Ideal for unattended playlist regeneration

## ⚙️ Configuration via ConfigMap
You **do not** need to modify the container image to pass your Jellyfin credentials and clustering settings.

All key parameters (like user ID, token, algorithm choice) are now injected via a Kubernetes ConfigMap, replacing the default config.py.

✅ This makes the container portable and user-configurable.

## 🧪 How the Script Runs
In Always-On mode, the script **audio_jelly_tensorflow.py** runs automatically on container start.

In CronJob mode, it executes once daily at the scheduled time.

You can still kubectl exec into the container to run or modify the script manually.

## 💡 Notes
Don't forget to mount the /workspace volume if you want to persist analysis results or the SQLite database.

Your actual credentials and analysis behavior are defined in the config.py injected via the ConfigMap.

Example volume mount:
```
volumeMounts:
  - name: workspace-volume
    mountPath: /workspace
```

## 🚀 Future Possibilities
This MVP lays the groundwork for further development:

* 💡 **Integration into Music Clients:** Native support in Jellyfin apps for smart playlists
* ⚙️ **Continuous Automation:** Full background worker support and schedule customization
* 🖥️ **Web UI or Plugin:** Web-based controls for playlist logic and filters
* 🔁 **Cross-Platform Sync** Export playlists to .m3u or sync to external platforms

## Happy playlisting 🎧
Pull requests and suggestions welcome!

## 🧠 Acknowledgements and Dependencies

This project integrates a variety of open-source libraries, machine learning models, and containerization technologies. Deep gratitude to the developers and researchers behind these excellent tools:

### 🎵 Audio Analysis (Essentia)

- [**Essentia**](https://essentia.upf.edu/) – An open-source C++ library for audio and music analysis, developed at the Music Technology Group of the Universitat Pompeu Fabra in Barcelona.
  - `MonoLoader`, `RhythmExtractor2013`, and `KeyExtractor` are used to extract tempo and musical key features.
  - `TensorflowPredictMusiCNN` and `TensorflowPredict2D` are used for generating music embeddings and predicting mood labels from a pre-trained deep learning model.

### 📊 Machine Learning

- [**scikit-learn**](https://scikit-learn.org/) – Used for clustering and dimensionality reduction:
  - `KMeans` and `DBSCAN` for grouping similar tracks.
  - `PCA` for optional dimensionality reduction prior to clustering.

### 🐍 Python Libraries

- `numpy` – Efficient numerical operations and array handling.
- `sqlite3` – Lightweight local storage of analysis results and metadata.
- `requests` – HTTP client for interacting with the Jellyfin API.
- `collections.defaultdict` – For organizing data and simplifying dictionary usage.
- `shutil`, `os` – File management during temporary downloads and cleanup.

### 🤖 Mood Classification Model

- **MusiCNN embedding model** – Developed as part of the [AcousticBrainz project](https://acousticbrainz.org/), based on a convolutional neural network trained for music tagging and embedding.
- **Mood prediction model** – A TensorFlow-based model trained to map MusiCNN embeddings to mood probabilities (you must provide or train your own compatible model).

### 🎛️ Media Server API

- [**Jellyfin**](https://jellyfin.org/) – This script interacts with Jellyfin’s API to retrieve media metadata, download audio tracks, and create playlists automatically.

### 📦 Containerization & Runtime

- **Docker / OCI-compatible Containers** – The entire application is packaged as a container, ensuring consistent and portable deployment across environments.
- A container runtime (such as **Docker**, **containerd**, or **Kubernetes**) is required to run the service.  
  Thanks to the open container ecosystem for enabling simplified deployment, orchestration, and scaling.

