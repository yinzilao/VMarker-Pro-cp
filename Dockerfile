FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install Python 3.10 and system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3.10 python3.10-dev python3.10-venv python3-pip \
        git wget build-essential \
        libgl1-mesa-glx libglfw3 libosmesa6-dev \
        libsm6 libxext6 libxrender-dev \
        x11-apps ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Make Python 3.10 default
RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    python -m pip install --upgrade pip

# Set working directory and copy repo
WORKDIR /workspace
COPY . /workspace

# Install PyTorch with CUDA 11.8 (cu118) — compatible with older libs
RUN pip install --extra-index-url https://download.pytorch.org/whl/cu118 \
    torch==2.0.0+cu118 torchvision==0.15.1+cu118 torchaudio==2.0.1+cu118

# Install Python dependencies from requirements.sh
RUN chmod +x requirements.sh && ./requirements.sh

# Configure for OpenGL offscreen rendering
ENV PYOPENGL_PLATFORM=osmesa

# Start with bash shell
ENTRYPOINT ["/bin/bash"]
