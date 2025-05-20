# 🎶 Jellyfin-Smart-Music

**Jellyfin-Smart-Music** is a Dockerized environment that brings smart playlist generation to [Jellyfin](https://jellyfin.org) using deep audio analysis via [Essentia](https://essentia.upf.edu/) with TensorFlow.

This project packages all required dependencies into a container and runs the [`Jellyfin-Essentia-Playlist`](https://github.com/NeptuneHub/Jellyfin-Essentia-Playlist) script, which analyzes your Jellyfin music library and builds playlists based on tempo, key, energy, and more.

## 🧭 Project Overview
* 🔍 Uses **Essentia** + **TensorFlow 1.15** for music feature extraction.
*  📂 Clones and runs `Jellyfin-Essentia-Playlist`, a custom Python-based analysis tool.
*  ✅ All dependencies are pre-installed — no system setup required.
*  🛠️ Intended as a **DEV environment** for manual analysis and experimentation.

## 🏗️ Status: Development Environment / MVP

This image is a **Minimum Viable Product (MVP)** designed for development and testing. You can run and edit the script interactively inside the container without needing to manage complex build chains or library dependencies.

### Why This Matters

* Saves hours of dependency resolution.
* Enables quick script iteration.
* Makes Essentia+TensorFlow accessible in one `docker run`.


## 🐳  Quick Start (via K3s Deployment)
If you're running a K3s or Kubernetes environment, you can deploy Jellyfin-Smart-Music with a simple manifest:

### Prerequisites

* K3S running
* A running Jellyfin server
* Set up your config.py inside the container (or mount it as a volume) with your Jellyfin API token and user ID

### 🛠️ Installation Manifest
We provide two Kubernetes manifests and corresponding image tags:

Always-On (alwayson-namespace-deployment.yaml + :latest-alwayson):
Runs continuously (ideal for dev/interactive use).

CronJob (cronjob-namespace-cronjob.yaml + :latest-cronjob):
Executes once daily at 11 PM.

💡 Note1: Mount /workspace and set your Jellyfin ENV vars/API keys as needed.
💡 Note2: You may want to mount volumes and set environment variables for Jellyfin access (API keys, etc.), depending on how you plan to run the script.

### 🔧 Running the Script
Once deployed, you can exec into the container:

```bash
kubectl exec -n playlist -it deploy/jellyfin-smart-music -- bash
```
Then run the script manually:
```bash
cd /workspace
python3 audio_jelly.py
```
🧪 This is a dev-focused container, so you can tweak the script and rerun it easily.

## 🚀 Future Possibilities

This MVP lays the groundwork for more advanced features:

1. **💡 Integration into Existing Players**  
   Embed smart playlist generation into open-source music clients for Jellyfin

2. **⚙️ Background Automation**  
   Turn the script into a long-running background worker that automatically generates playlists on a schedule.

3. **🖥️ Web UI or Plugin**  
   Add controls for clustering, filtering, or playlist regeneration directly inside the Jellyfin music clients

4. **🔁 Cross-Platform Playlist Export**  
   Support exporting playlists in formats like `.m3u` or syncing them across services.
