FROM ubuntu:18.04
WORKDIR /home

# install some basics

RUN apt-get update && apt-get install -y \
  git \
	curl \ 
  tree \
	wget \
	ca-certificates \
  python-dev \
  python3 \
  python3-dev \
  python3-pip \
  ipython3 \
  cmake \
  libncurses5-dev

# install ansible and flywheel sdk using pip

RUN pip3 install google-api-python-client flywheel-sdk requests google-auth git+https://github.com/ansible/ansible.git@devel

# get and build vim

RUN cd /tmp && git clone https://github.com/vim/vim.git
RUN cd /tmp/vim && ./configure --with-features=huge --enable-multibyte --enable-python3interp=yes --enable-perlinterp=yes  --enable-cscope --prefix=/usr/local 
RUN cd /tmp/vim && make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 && make install

## config/compile vim plugins

#RUN git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN wget -P /root/ https://raw.githubusercontent.com/tcbtcb/work-image/master/.vimrc
RUN vim -c 'PlugInstall' -c 'qa!'
RUN python3 /root/.vim/plugged/YouCompleteMe/install.py
RUN find ~/.vim -type d -name "doc" -exec vim +helptags {} +qall \;

# install gcloud sdk
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-bionic main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y google-cloud-sdk

