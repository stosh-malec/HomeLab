# HomeLab

This repository contains my personal homelab configurations, deployed using Kubernetes and Helm.

## Applications

Here's a list of the applications currently running in my homelab:

* **Minecraft Server:**
    * A dedicated Minecraft server for playing with friends.
    * Limited remote access over Twingate
    * Modpack: DBS Minecraft Refined.
* **Satisfactory Server:**
    * A dedicated Satisfactory server.
    * Limited remote access over Twingate
* **Longhorn:**
    * A HA distributed storage system for Kubernetes.
    * Provides persistent storage for applications.
    * Automatic Cloud Backups
* **Twingate:**
    * A modern VPN solution for secure remote access to homelab services.
    * Enables secure, limited access to internal applications/game servers for myself and friends

## Kubernetes Setup

* Kubernetes cluster running on 3 single board computers.
    * Each node is equipped with an Intel i9 processor, 16GB DDR4 RAM, and a 1TB NVMe SSDs.