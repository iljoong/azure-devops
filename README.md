# Sample DevOps CI/CD

## Overview

This sample demonstrates how to create CI/CD pipeline for real-world scenarios and it has following features:

- CI/CD for Windows based application (dotent core webapi app) to VMSS.
- Building a VM image using packer.
- Publishing an image to shared image gallery for multi-region and cross subscription deployment.
- Releasing to VMSS with image and installing a certificate and config IIS.
- Upgrading certificate of VMSS without downtime

Please refer [config.md](./config.md) for setup and test this sample.
