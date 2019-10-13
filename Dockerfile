FROM golang:1.12.9-buster

# install some basics

RUN apt-get update && apt-get install -y \
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
  libncurses5-dev

# install ansible and flywheel sdk using pip

RUN pip3 install pymongo jedi pydicom google-cloud google-cloud-storage google-api-python-client flywheel-sdk requests google-auth oauthclient

# install node and additional packages

RUN curl -sL install-node.now.sh/lts | bash -s -- -y
RUN npm install --unsafe -g  dockerfile-language-server-nodejs

# get and build vim

RUN cd /tmp && git clone https://github.com/vim/vim.git
RUN cd /tmp/vim && ./configure --with-features=huge --enable-multibyte --enable-python3interp=yes --enable-perlinterp=yes  --enable-cscope --prefix=/usr/local 
RUN cd /tmp/vim && make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 && make install

## config/compile vim plugins

RUN curl -fLo /root/.vimrc https://raw.githubusercontent.com/tcbtcb/work-image/master/.vimrc
RUN curl -fLo /root/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN curl -fLo /root/.vim/coc-settings.json https://raw.githubusercontent.com/tcbtcb/work-image/master/coc-settings.json
RUN vim +PlugInstall +qall
RUN vim '+CocInstall -sync coc-json coc-yaml coc-python coc-tsserver' +qall
RUN vim '+helptags ALL' +qall

# install gcloud sdk
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-bionic main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y google-cloud-sdk

# install flywheel golang sdk 
RUN go get github.com/flywheel-io/sdk/api

