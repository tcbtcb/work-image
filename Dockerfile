FROM golang:1.14-buster

# set modules on and platform for golang

ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64

# install some basics

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \ 
    tree \
    wget \
    entr \
    tmux \
    ca-certificates \
    nmap \
    python-dev \
    python3 \
    python3-dev \
    python3-pip \
    ipython3 \
    cmake \
    libncurses5-dev \
    apt-utils \
    fontconfig \
    fonts-powerline \
    less \
    bsdmainutils \
  && apt-get clean

# update certs
RUN update-ca-certificates

# install some python stuff
RUN pip3 install pymongo jedi pylint pydicom google-cloud google-cloud-storage flywheel-sdk requests google-auth oauthclient PyYAML

# install node and additional packages
RUN curl -sL install-node.now.sh/lts | bash -s -- -y
RUN npm install --unsafe -g  dockerfile-language-server-nodejs

# get and build vim
RUN cd /tmp && git clone https://github.com/vim/vim.git
RUN cd /tmp/vim && ./configure --with-features=huge --enable-multibyte --enable-python3interp=yes --enable-perlinterp=yes  --enable-cscope --prefix=/usr/local 
RUN cd /tmp/vim && make VIMRUNTIMEDIR=/usr/local/share/vim/vim82 && make install

# get and install powerline fonts
RUN cd /root && git clone https://github.com/powerline/fonts && \
    mv fonts .fonts && \
    cd .fonts && \
    ./install.sh && \
    fc-cache -vf /root/.fonts/

# clone settings repo locally
RUN cd /root && git clone https://github.com/tcbtcb/work-image.git

# config/compile vim plugins
RUN cp /root/work-image/vimrc /root/.vimrc
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN cp /root/work-image/coc-settings.json /root/.vim/
RUN vim +PlugInstall +qall
RUN vim '+CocInstall -sync coc-ultisnips coc-json coc-yaml coc-python' +qall
RUN vim '+GoInstallBinaries' +qall
RUN vim '+helptags ALL' +qall

# install gcloud sdk
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-buster main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y google-cloud-sdk

# install flywheel golang sdk + other tools
RUN go get github.com/flywheel-io/sdk/api
RUN go get github.com/spf13/cobra
RUN go get github.com/gohugoio/hugo
RUN go get github.com/labstack/echo
RUN go get github.com/justjanne/powerline-go
RUN go get github.com/juliosueiras/terraform-lsp
RUN go get github.com/hashicorp/terraform
RUN go get github.com/cespare/reflex

# install bash + tmux files
RUN cp /root/work-image/bashrc /root/.bashrc
RUN cp /root/work-image/bash_profile /root/.bash_profile
RUN cd /root && git clone https://github.com/gpakosz/.tmux.git && ln -s -f .tmux/.tmux.conf
RUN cd /root && ln -s -f .tmux/.tmux.conf
RUN cp /root/work-image/tmux.conf.local /root/.tmux.conf.local

