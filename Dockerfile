FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

MAINTAINER Leon Zhang <albireo@live.cn>

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
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros core packages
ENV ROS_DISTRO kinetic
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-core=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

# install ros base packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-ros-base=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

# install ros robot packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-robot=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

# install ros desktop packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

# install ros desktop-full packages
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full=1.3.2-0* \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    wget kdevelop \
    && rm -rf /var/lib/apt/lists/*

# install pcl lib
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    make cmake build-essential git \
    libeigen3-dev \
    libflann-dev \
    libusb-1.0-0-dev \
    libvtk6-qt-dev \
    libpcap-dev \
    libboost-all-dev \
    libproj-dev \
    && rm -rf /var/lib/apt/lists/*

# install pcl
RUN \
    git config --global http.sslVerify false && \
    git clone --branch pcl-1.8.0 --depth 1 https://github.com/PointCloudLibrary/pcl.git pcl-trunk && \
    cd pcl-trunk && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j 4 && make install && \
    make clean

RUN ldconfig

# install java
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    && openjdk-8-jre \
    && rm -rf /var/lib/apt/lists/*

# install cpp
RUN apt-get update && apt-get install -y \ 
    build-essential g++ cmake libavcodec-dev libavformat-dev libjpeg.dev libtiff4.dev libswscale-dev libjasper-dev \
    && rm -rf /var/lib/apt/lists/*

# install qt
# RUN apt-get update && apt-get install -y \
#     qt5-default qtcreator qt-sdk \
#     && rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./ros_entrypoint.sh /

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]