FROM ubuntu:18.04
WORKDIR /home

# install some basics

RUN apt-get update && apt-get install -y \
  git \
	curl \ 
	wget \
	ca-certificates \
  python-dev \
  python3 \
  python3-dev
  python3-pip \
  cmake

# install ansible and flywheel sdk using pip

RUN pip3 install flywheel-sdk requests google-auth git+https://github.com/ansible/ansible.git@devel

# get and build vim

RUN cd /tmp && git clone https://github.com/vim/vim.git
RUN cd /tmp/vim && ./configure --with-features=huge --enable-multibyte --enable-python3interp=yes --enable-perlinterp=yes  --enable-cscope --prefix=/usr/local 
RUN cd /tmp/vim && make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 && make install

## config vim plugins

RUN git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim
COPY .vimrc /root/.vimrc
RUN vim -c 'PluginInstall' -c 'qa!'
RUN python3 /root/.vim/bundle/YouCompleteMe/install.py


