FROM dorowu/ubuntu-desktop-lxde-vnc:xenial

# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    ca-certificates \
    wget \
    curl \
    git  \
    python3-dev \
    mesa-utils \
    g++ \
    cmake \
    cmake-gui \
    doxygen \
    mpi-default-dev \
    openmpi-bin \
    openmpi-common \
    libusb-1.0-0-dev \
    libqhull* \
    libusb-dev \
    libgtest-dev \
    git-core \
    freeglut3-dev \
    pkg-config \
    build-essential \
    libxmu-dev \
    libxi-dev \
    libphonon-dev \
    libphonon-dev \
    phonon-backend-gstreamer \
    phonon-backend-vlc \
    graphviz \
    mono-complete \
    qt-sdk \
    libflann-dev \
    libflann1.8 \
    libboost1.58-all-dev \
    vim \
    && rm -rf /var/lib/apt/lists/*

########### Install PCL v 1.8 ###########
# Source https://askubuntu.com/questions/916260/how-to-install-point-cloud-library-v1-8-pcl-1-8-0-on-ubuntu-16-04-2-lts-for

# libeigen3
RUN wget --quiet http://launchpadlibrarian.net/209530212/libeigen3-dev_3.2.5-4_all.deb && \
    dpkg -i libeigen3-dev_3.2.5-4_all.deb && \
    rm libeigen3-dev_3.2.5-4_all.deb
RUN apt-mark hold libeigen3-dev

# Switch to ROOT
USER root

# VTK 7.1.0
RUN wget --quiet http://www.vtk.org/files/release/7.1/VTK-7.1.0.tar.gz && \
    tar -xf VTK-7.1.0.tar.gz && \
    rm VTK-7.1.0.tar.gz
RUN cd VTK-7.1.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j8 && \
    make install

# PCL 1.8.0
RUN wget --quiet https://github.com/PointCloudLibrary/pcl/archive/pcl-1.8.0.tar.gz && \
    tar -xf pcl-1.8.0.tar.gz && \
    rm pcl-1.8.0.tar.gz
RUN cd pcl-pcl-1.8.0 && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j8 && \
    make install

# clean tmp files
RUN rm -r /VTK-7.1.0 && \
    rm -r /pcl-pcl-1.8.0

# Install pip, numpy & cython python2&3
RUN wget --quiet https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    RUN pip3 install --upgrade pip
RUN pip3 install cython==0.25.2
RUN pip3 install numpy

RUN python2 get-pip.py && \
    rm get-pip.py
RUN pip2 install --upgrade pip
RUN pip2 install cython==0.25.2
RUN pip2 install numpy


# Clone python-pcl repo && Modify setup.py
RUN git clone https://github.com/strawlab/python-pcl.git && \
    cd python-pcl && \
    sed -i "s/# ext_args\['include_dirs'\]\.append('\/usr\/include\/vtk-5\.8')/ext_args\['include_dirs'\]\.append('\/usr\/local\/include\/vtk-7\.1')/g" setup.py && \
    sed -i "s/# ext_args\['library_dirs'\]\.append('\/usr\/lib')/ext_args\['library_dirs'\]\.append('\/usr\/lib')/g" setup.py && \
    sed -i "s/# Extension(\"pcl.pcl_visualization\"/Extension(\"pcl.pcl_visualization\"/g" setup.py

RUN cd python-pcl && \
    python3 setup.py build_ext -i && \
    python3 setup.py install

RUN cd python-pcl && \
    python2 setup.py build_ext -i && \
    python2 setup.py install

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
    kdevelop \
    && rm -rf /var/lib/apt/lists/*

# install qt
# RUN apt-get update && apt-get install -y \
#     qt5-default qtcreator qt-sdk \
#     && rm -rf /var/lib/apt/lists/*

# setup ros env
RUN echo "source "/opt/ros/$ROS_DISTRO/setup.bash"" > /root/.bashrc \
    && /bin/bash -c "source /root/.bashrc"