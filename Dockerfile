FROM golang:1.17-buster as gobuild

# set modules on and platform for golang
ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64

# install flywheel golang sdk + other go tools
RUN go get github.com/flywheel-io/sdk/api
RUN go get github.com/hashicorp/terraform-ls
RUN go get go.mozilla.org/sops/v3/cmd/sops
RUN go get golang.org/x/tools/gopls@latest
RUN go get github.com/piquette/finance-go
RUN go get github.com/jonwho/go-iex
RUN go get github.com/influxdata/influxdb-client-go/v2

# install a version of tf
RUN cd /root && git clone https://github.com/hashicorp/terraform.git 
RUN cd /root/terraform && git checkout tags/v0.12.29 && go install

# install teleport
RUN cd /root && git clone https://github.com/gravitational/teleport.git
RUN cd /root/teleport/ && make
RUN cp -r /root/teleport/build/* /go/bin/

# install gitlab lab cli (per the somewhat strange instructions on the github page)
RUN cd /root && git clone https://github.com/zaquestion/lab.git
RUN cd /root/lab && go install -ldflags "-X \"main.version=$(git  rev-parse --short=10 HEAD)\"" .

# retrieve/install terraform-sops provider
RUN go get github.com/carlpett/terraform-provider-sops && \
  mkdir -p /root/.terraform.d/plugins/ && \
  cp /go/bin/terraform-provider-sops /root/.terraform.d/plugins/

FROM golang:1.17-buster
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
    libopenblas-dev \
    gfortran \
    automake \
    g++ \
    unzip \
    lsb-release \
    libxext-dev \
    ranger \
    fzf \
    fonts-firacode \
    postgresql-client \
    libpq-dev \
    locales \
    bash-completion \ 
    libssl-dev \
  && apt-get clean

RUN apt-get update && apt-get install -y \
    python3-pip \
  && apt-get clean

# update certs
RUN update-ca-certificates

# install some python stuff
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install pynvim jedi black pymongo awscli flywheel-sdk requests PyYAML pandas matplotlib

# get and build neovim
RUN git clone https://github.com/neovim/neovim.git && cd neovim && make CMAKE_BUILD_TYPE=Release && make install
RUN ln -s /usr/local/bin/nvim /usr/local/bin/vim

# install hstr, kubectl, and yarn
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y kubectl yarn

# do some cleanup
RUN apt-get clean && apt-get autoclean
RUN rm -rf /root/.cache/

# configure root user 
USER root
WORKDIR /root

# locales
RUN LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8

# get nodejs
RUN curl -sL install-node.now.sh/lts | bash -s -- -y

# install some node lang servers
RUN npm install --unsafe -g neovim prettier pyright vscode-css-languageserver-bin bash-language-server vscode-html-languageserver-bin dockerfile-language-server-nodejs typescript typescript-language-server yaml-language-server vscode-json-languageserver

# clone settings repo locally
RUN git clone https://github.com/tcbtcb/work-image.git

# config/install vim plugins
RUN mkdir -p /root/.config
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN rsync -aPh /root/work-image/nvim/ /root/.config/nvim/
RUN nvim +'PlugInstall' +qa --headless
RUN cd /root/.config/nvim/plugged/coc.nvim && npm install && npm run build
RUN timeout 120 nvim --headless || :
RUN timeout 60 nvim --headless || :
RUN timeout 60 nvim --headless || :

# config bash
RUN cp /root/work-image/bashrc /root/.bashrc
RUN kubectl completion bash >> /etc/bash_completion.d/kubectl
RUN cp /root/work-image/tmux.conf /root/.tmux.conf

# install starship prompt
RUN curl -fsSL https://starship.rs/install.sh >> install.sh
RUN chmod +x install.sh
RUN ./install.sh -y
RUN rm install.sh
RUN cp /root/work-image/starship.toml /root/.config/starship.toml

# install gcloud 
RUN mkdir /opt/gcloud
WORKDIR /opt/gcloud
RUN curl https://sdk.cloud.google.com > install.sh
RUN chmod +x install.sh
RUN ./install.sh --disable-prompts --install-dir=/opt/gcloud
RUN cp /opt/gcloud/google-cloud-sdk/completion.bash.inc /etc/bash_completion.d/completion.bash.inc

WORKDIR /go/src/gitlab.com/flywheel-io/

# configure thadbrown user 
RUN useradd -m -s /bin/bash -u 501 thadbrown
USER thadbrown
WORKDIR /home/thadbrown

# locales
RUN LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8

# clone settings repo locally
RUN git clone https://github.com/tcbtcb/work-image.git

# config/install vim plugins
RUN mkdir -p /home/thadbrown/.config
RUN sh -c 'curl -fLo /home/thadbrown/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN rsync -aPh /home/thadbrown/work-image/nvim/ /home/thadbrown/.config/nvim/
RUN nvim +'PlugInstall' +qa --headless
RUN cd /home/thadbrown/.config/nvim/plugged/coc.nvim && npm install && npm run build
RUN timeout 120 nvim --headless || :
RUN timeout 60 nvim --headless || :
RUN timeout 60 nvim --headless || :

# config bash
RUN cp /home/thadbrown/work-image/bashrc /home/thadbrown/.bashrc
RUN cp /home/thadbrown/work-image/tmux.conf /home/thadbrown/.tmux.conf

# install starship prompt
RUN curl -fsSL https://starship.rs/install.sh >> install.sh
RUN chmod +x install.sh
RUN ./install.sh -y
RUN rm install.sh
RUN cp /home/thadbrown/work-image/starship.toml /home/thadbrown/.config/starship.toml

WORKDIR /go/src/gitlab.com/flywheel-io/
