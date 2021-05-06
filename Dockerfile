FROM golang:1.16-buster as gobuild

# set modules on and platform for golang
ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64

# install flywheel golang sdk + other go tools
RUN go get github.com/flywheel-io/sdk/api
RUN go get -u github.com/spf13/cobra/cobra@v1.0.0
RUN go get github.com/labstack/echo
RUN go get github.com/hashicorp/terraform-ls
RUN go get github.com/cespare/reflex
RUN go get go.mozilla.org/sops/v3/cmd/sops
RUN go get golang.org/x/tools/gopls@latest
RUN go get github.com/spf13/viper
RUN go get github.com/jesseduffield/lazygit
RUN go get github.com/piquette/finance-go
RUN go get github.com/jonwho/go-iex
RUN go get gorm.io/gorm
RUN go get gorm.io/driver/postgres

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

FROM golang:1.16-buster
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
    fonts-firacode \
    postgresql-client \
    libpq-dev \
    bash-completion \ 
  && apt-get clean

RUN apt-get update && apt-get install -y \
    python3-pip \
  && apt-get clean

# update certs
RUN update-ca-certificates

# install some python stuff
RUN pip3 install pynvim jedi psycopg2 black iexfinance pipenv pymongo awscli flywheel-sdk requests PyYAML pandas matplotlib scipy sklearn statsmodels

# get and build neovim
RUN git clone https://github.com/neovim/neovim.git && cd neovim && make CMAKE_BUILD_TYPE=Release && make install
RUN ln -s /usr/local/bin/nvim /usr/local/bin/vim

# install hstr, kubectl, and yarn
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install kubectl yarn

# do some cleanup
RUN apt-get clean && apt-get autoclean
RUN rm -rf /root/.cache/

# install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -q -y
RUN export PATH="$HOME/.cargo/bin:$PATH"
RUN git clone https://github.com/cantino/mcfly && cd mcfly && /root/.cargo/bin/cargo  install --path .

# configure root user 
USER root
WORKDIR /root

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
RUN timeout 180 nvim --headless || :
RUN cd /root/.config/nvim/plugged && npm install && npm run build

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

# ranger config 
RUN git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
RUN cp /root/work-image/rc.conf /root/.config/ranger/rc.conf

# install gcloud 
RUN mkdir /opt/gcloud
WORKDIR /opt/gcloud
RUN curl https://sdk.cloud.google.com > install.sh
RUN chmod +x install.sh
RUN ./install.sh --disable-prompts --install-dir=/opt/gcloud
RUN cp /opt/gcloud/google-cloud-sdk/completion.bash.inc /etc/bash_completion.d/completion.bash.inc

WORKDIR /go/src/github.com/tcbtcb
