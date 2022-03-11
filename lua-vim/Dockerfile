FROM golang:1.17-bullseye 

RUN apt-get update 
RUN apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
RUN cd /root && git clone https://github.com/neovim/neovim
RUN cd /root/neovim && make
RUN cd /root/neovim && make install
