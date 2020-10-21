FROM golang:1.15-buster as gobuild

# set modules on and platform for golang
ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64

# install flywheel golang sdk + other go tools
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
RUN go get github.com/spf13/viper
RUN go get github.com/dnaeon/go-vcr/recorder
RUN go get github.com/jesseduffield/lazygit
RUN go get github.com/jonwho/go-iex/v4

# install gitlab lab cli (per the somewhat strange instructions on the github page)
RUN cd /root && git clone https://github.com/zaquestion/lab.git
RUN cd /root/lab && go install -ldflags "-X \"main.version=$(git  rev-parse --short=10 HEAD)\"" .

# install a version of tf
RUN cd /root && git clone https://github.com/hashicorp/terraform.git 
RUN cd /root/terraform && git checkout tags/v0.12.29 && go install

# retrieve/install terraform-sops provider
RUN go get github.com/carlpett/terraform-provider-sops && \
  mkdir -p /root/.terraform.d/plugins/ && \
  cp /go/bin/terraform-provider-sops /root/.terraform.d/plugins/

FROM golang:1.15-buster
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
    ninja-build \ 
    gettext \
    libtool \
    libtool-bin \
    autoconf \
    automake \
    g++ \
    unzip \
  && apt-get clean

RUN apt-get update && apt-get install -y \
    python3-pip \
  && apt-get clean

# update certs
RUN update-ca-certificates

# install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update
RUN apt-get install -y kubectl

# install some python stuff
RUN pip3 install ranger-fm pynvim pipenv flywheel-cli pymongo awscli jedi pylint flywheel-sdk requests google-auth oauthclient PyYAML pandas matplotlib sklearn tensorflow

# install node and additional packages
RUN curl -sL install-node.now.sh/lts | bash -s -- -y
RUN npm install --unsafe -g neovim dockerfile-language-server-nodejs

# get and build neovim
RUN git clone https://github.com/neovim/neovim.git && cd neovim && make CMAKE_BUILD_TYPE=Release && make install
RUN ln -s /usr/local/bin/nvim /usr/local/bin/vim

# install hstr
RUN echo "deb https://www.mindforger.com/debian stretch main" >> /etc/apt/sources.list
RUN wget -qO - https://www.mindforger.com/gpgpubkey.txt | apt-key add -
RUN apt-get update
RUN apt-get install -y hstr

# get and install powerline fonts
RUN cd /root && git clone https://github.com/powerline/fonts && \
    mv fonts .fonts && \
    cd .fonts && \
    ./install.sh && \
    fc-cache -vf /root/.fonts/

# do some cleanup
RUN apt-get clean && apt-get autoclean
RUN rm -rf /root/.cache/

# create users
RUN useradd -m -s /bin/bash thadbrown
RUN echo "thadbrown ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN groupadd golang
RUN usermod -a -G golang thadbrown
RUN chgrp -R golang /go
RUN chmod -R g+rwx /go

# configure thadbrown user 
USER thadbrown
WORKDIR /home/thadbrown

# for some reason, manually set coc log location with env
ENV NVIM_COC_LOG_FILE=/tmp/coc.log

# clone settings repo locally
RUN git clone https://github.com/tcbtcb/work-image.git

# config/install vim plugins
RUN mkdir -p /home/thadbrown/.config/nvim
RUN cp /home/thadbrown/work-image/init.vim /home/thadbrown/.config/nvim/
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN mkdir -p /home/thadbrown/.config/coc
RUN nvim +'PlugInstall' +qa --headless
RUN nvim +'CocInstall -sync coc-snippets coc-go coc-python coc-emmet coc-css coc-html coc-prettier coc-json coc-tsserver' +qa --headless

# # install bash + tmux files
RUN cp /home/thadbrown/work-image/bashrc /home/thadbrown/.bashrc 
RUN cp /home/thadbrown/work-image/bash_profile /home/thadbrown/.bash_profile
RUN cp /home/thadbrown/work-image/tmux.conf /home/thadbrown/.tmux.conf

# install gcloud 
RUN curl https://sdk.cloud.google.com > install.sh
RUN chmod +x install.sh
RUN ./install.sh --disable-prompts

WORKDIR /go/src/gitlab.com/flywheel-io

# configure root user 
USER root
WORKDIR /root

# for some reason, manually set coc log location with env
ENV NVIM_COC_LOG_FILE=/tmp/coc.log

# clone settings repo locally
RUN git clone https://github.com/tcbtcb/work-image.git

# config/install vim plugins
RUN mkdir -p /root/.config/nvim
RUN cp /root/work-image/init.vim /root/.config/nvim/
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN mkdir -p /root/.config/coc
RUN nvim +'PlugInstall' +qa --headless
RUN nvim +'CocInstall -sync coc-snippets coc-go coc-python coc-emmet coc-css coc-html coc-prettier coc-json coc-tsserver' +qa --headless

# # install bash + tmux files
RUN cp /root/work-image/bashrc /root/.bashrc 
RUN cp /root/work-image/bash_profile /root/.bash_profile
RUN cp /root/work-image/tmux.conf /root/.tmux.conf

# install gcloud 
RUN curl https://sdk.cloud.google.com > install.sh
RUN chmod +x install.sh
RUN ./install.sh --disable-prompts

RUN rm /tmp/coc.log
WORKDIR /go/src/github.com/tcbtcb

