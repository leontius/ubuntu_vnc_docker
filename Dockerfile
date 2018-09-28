FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

RUN apt-get update && apt-get install -y wget git kdevelop && apt-get install -y libpcl-dev \
    && rm -rf /var/lib/apt/lists/*

# java 环境
RUN apt-get update && apt-get install -y openjdk-8-jdk \
    && rm -rf /var/lib/apt/lists/*

# cpp环境
RUN apt-get update && apt-get install -y build-essential g++ cmake libavcodec-dev libavformat-dev libjpeg.dev libtiff4.dev libswscale-dev libjasper-dev \
    && rm -rf /var/lib/apt/lists/*

# qt
RUN apt-get update && apt-get install -y qt5-default qtcreator qt-sdk \
    && rm -rf /var/lib/apt/lists/*