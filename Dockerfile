FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    python-rosinstall-generator \
    python-wstool \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros core packages
ENV ROS_DISTRO kinetic

# install ros desktop-full packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

# install java
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    openjdk-8-jre \
    && rm -rf /var/lib/apt/lists/*

# install cpp
RUN apt-get update && apt-get install -y \ 
    build-essential g++ cmake libavcodec-dev libavformat-dev libjpeg.dev libtiff4.dev libswscale-dev libjasper-dev \
    wget kdevelop \
    && rm -rf /var/lib/apt/lists/*

# install qt
# RUN apt-get update && apt-get install -y \
#     qt5-default qtcreator qt-sdk \
#     && rm -rf /var/lib/apt/lists/*

# setup entrypoint
USER root
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash"