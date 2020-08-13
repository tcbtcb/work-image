FROM golang:1.14-buster as gobuild

# set modules on and platform for golang
ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64

# install flywheel golang sdk + other tools
RUN go get github.com/flywheel-io/sdk/api
RUN go get github.com/spf13/cobra
RUN go get github.com/gohugoio/hugo
RUN go get github.com/labstack/echo
RUN go get github.com/justjanne/powerline-go
RUN go get github.com/juliosueiras/terraform-lsp
RUN go get github.com/cespare/reflex
RUN go get go.mozilla.org/sops/v3/cmd/sops
RUN go get github.com/mikefarah/yq/v3
RUN go get github.com/derailed/k9s
RUN go get github.com/tobgu/qframe
RUN go get golang.org/x/tools/gopls@latest

# install gitlab lab cli (per the somewhat strange instructions on the github page)
RUN cd /root && git clone https://github.com/zaquestion/lab.git
RUN cd /root/lab && go install -ldflags "-X \"main.version=$(git  rev-parse --short=10 HEAD)\"" .

# install a version of tf
RUN cd /root && git clone https://github.com/hashicorp/terraform.git 
RUN cd /root/terraform && git checkout tags/v0.12.24 && go install

# retrieve/install terraform-sops provider
RUN go get github.com/carlpett/terraform-provider-sops && \
  mkdir -p /root/.terraform.d/plugins/ && \
  cp /go/bin/terraform-provider-sops /root/.terraform.d/plugins/

FROM golang:1.14-buster
COPY --from=gobuild /go/bin/* /go/bin/

# set modules on and platform for golang
ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64

# install some basics
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    git \
    curl \ 
    tree \
    wget \
    entr \
    tmux \
    ca-certificates \
    nmap \
    cmake \
    libncurses5-dev \
    apt-utils \
    fontconfig \
    fonts-powerline \
    man \
    less \
    rsync \
    bsdmainutils \
    jq \
    apt-transport-https \
    gnupg2 \
    pkg-config \
    libfreetype6-dev \
    yamllint \
  && apt-get clean

RUN apt-get update && apt-get install -y \
    python3-pip \
  && apt-get clean

# update certs
RUN update-ca-certificates

# install hub
RUN wget https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz
RUN tar -xvf hub-linux-amd64-2.14.2.tgz && cd hub-linux-amd64-2.14.2 && sudo ./install 

# install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# install some python stuff
RUN pip3 install pipenv flywheel-cli pymongo ansible awscli jedi pylint flywheel-sdk requests google-auth oauthclient PyYAML pyEX pandas matplotlib

# install node and additional packages
RUN curl -sL install-node.now.sh/lts | bash -s -- -y
RUN npm install --unsafe -g  dockerfile-language-server-nodejs

# get and build vim
RUN cd /tmp && git clone https://github.com/vim/vim.git
RUN cd /tmp/vim && ./configure --with-features=huge --enable-multibyte --enable-python3interp=yes --enable-perlinterp=yes  --enable-cscope --prefix=/usr/local 
RUN cd /tmp/vim && make VIMRUNTIMEDIR=/usr/local/share/vim/vim82 && make install

# install hstr
RUN echo -e "deb https://www.mindforger.com/debian stretch main" >> /etc/apt/sources.list
RUN wget -qO - https://www.mindforger.com/gpgpubkey.txt | apt-key add -
RUN apt-get update
RUN apt-get install hstr

# get and install powerline fonts
RUN cd /root && git clone https://github.com/powerline/fonts && \
    mv fonts .fonts && \
    cd .fonts && \
    ./install.sh && \
    fc-cache -vf /root/.fonts/

# create users
RUN useradd -m -s /bin/bash thadbrown
RUN useradd -m -s /bin/bash tcb
RUN echo "thadbrown ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN echo "tcb ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN groupadd golang
RUN usermod -a -G golang tcb
RUN usermod -a -G golang thadbrown
RUN chgrp -R golang /go
RUN chmod -R g+rwx /go

# configure thadbrown user 
USER thadbrown
WORKDIR /home/thadbrown

# for some reason, manually set coc log location with env
ENV NVIM_COC_LOG_FILE=/tmp/coc.log

# install IEX SDK
RUN go get github.com/jonwho/go-iex

# clone settings repo locally
RUN git clone https://github.com/tcbtcb/work-image.git

# config/install vim plugins
RUN cp work-image/vimrc ~/.vimrc
RUN curl -fLo /home/thadbrown/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN cp work-image/coc-settings.json ~/.vim/
RUN mkdir -p /home/thadbrown/.config/coc
RUN vim +PlugInstall +qall
RUN vim '+CocInstall -sync coc-snippets coc-go coc-python coc-emmet coc-css coc-html coc-prettier coc-json coc-tsserver' +qall

# install bash + tmux files
RUN cp ~/work-image/bashrc ~/.bashrc 
RUN cp ~/work-image/bash_profile ~/.bash_profile
RUN git clone https://github.com/gpakosz/.tmux.git && ln -s -f .tmux/.tmux.conf
RUN ln -s -f .tmux/.tmux.conf
RUN cp ~/work-image/tmux.conf.local ~/.tmux.conf.local

# install gcloud 
RUN curl https://sdk.cloud.google.com > install.sh
RUN chmod +x install.sh
RUN ./install.sh --disable-prompts

WORKDIR /go/src/gitlab.com/flywheel-io

# configure tcb user 
USER tcb
WORKDIR /home/tcb

# clone settings repo locally
RUN git clone https://github.com/tcbtcb/work-image.git

# install bash + tmux files
RUN cp ~/work-image/bashrc ~/.bashrc 
RUN cp ~/work-image/bash_profile ~/.bash_profile
RUN git clone https://github.com/gpakosz/.tmux.git && ln -s -f .tmux/.tmux.conf
RUN ln -s -f .tmux/.tmux.conf
RUN cp ~/work-image/tmux.conf.local ~/.tmux.conf.local

# install gcloud 
RUN curl https://sdk.cloud.google.com > install.sh
RUN chmod +x install.sh
RUN ./install.sh --disable-prompts

# start w/ thadbrown user
USER thadbrown
WORKDIR /go/src/gitlab.com/flywheel-io
