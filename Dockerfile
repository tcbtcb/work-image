FROM golang:1.23-bookworm

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
    ripgrep \
    fonts-firacode \
    postgresql-client \
    libpq-dev \
    locales \
    bash-completion \ 
    libssl-dev \
    libsqlite3-dev \
    libffi-dev \
  && apt-get clean

# install python 3.11 by hand
RUN wget https://www.python.org/ftp/python/3.11.1/Python-3.11.1.tgz
RUN tar -xvf Python-3.11.1.tgz
RUN cd Python-3.11.1 && ./configure --enable-optimizations && make -j 2 && make altinstall

# clea up a bit 
RUN rm -rf Python-3.11.1

# configure python3 to use 3.11
RUN unlink /usr/bin/python3
RUN ln -s /usr/local/bin/python3.11 /usr/bin/python3

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
  && apt-get clean

# update certs
RUN update-ca-certificates

# install some python stuff
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install yamllint pynvim jedi black pymongo flywheel-sdk requests PyYAML pandas matplotlib

# get and build neovim
RUN git clone https://github.com/neovim/neovim.git && cd neovim && make CMAKE_BUILD_TYPE=Release && make install
RUN ln -s /usr/local/bin/nvim /usr/local/bin/vim

# do some cleanup
RUN apt-get clean && apt-get autoclean
RUN rm -rf /root/.cache/

# configure root user 
USER root
WORKDIR /root

# get go tools 
RUN wget https://storage.googleapis.com/rsj-episodes/tcb-gotools3.tar
RUN tar -xf tcb-gotools3.tar 
RUN rsync -aPh /root/home/tcb/go/bin/ /go/bin/
RUN rm -rf /root/home/tcb

# # install tfenv
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv
RUN export PATH=/root/.tfenv/bin:$PATH && tfenv install 0.13.7 

# locales
RUN LANG=en_US.UTF-8 locale-gen --purge en_US.UTF-8

# get nodejs
RUN curl -sL install-node.now.sh/lts | bash -s -- -y

# clone settings repo locally
RUN git clone https://github.com/tcbtcb/work-image.git

# set up nvim
RUN mkdir -p /root/.config/nvim
RUN mv /root/work-image/nvim/bootstrap_packer.tar /root/.config/nvim/
RUN cd /root/.config/nvim && tar -xvf bootstrap_packer.tar && mv works/* . 
RUN nvim +qa --headless
RUN rm -rf /root/.config/nvim/*
RUN ls /root/.config/nvim/
RUN rsync -aPh /root/work-image/nvim/nvim/ /root/.config/nvim/
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
RUN echo "i = 42" >> whelp.js
RUN timeout 120 nvim whelp.js -c ":LspInstall tsserver" || :

# try to set up gopls without the damn go get install
# RUN mkdir -p /root/.local/share/nvim/lsp_servers/go
# RUN cp /go/bin/gopls /root/.local/share/nvim/lsp_servers/go/
# RUN cp /root/work-image/nvim/nvim-lsp-installer-receipt.json /root/.local/share/nvim/lsp_servers/go/

# config bash
RUN cp /root/work-image/bashrc /root/.bashrc

# install starship prompt
RUN curl -fsSL https://starship.rs/install.sh >> install.sh
RUN chmod +x install.sh
RUN ./install.sh -y
RUN rm install.sh
RUN cp /root/work-image/starship.toml /root/.config/starship.toml

# install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN rm -rf aws*

# install azure CLI
# RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
RUN touch /etc/apt/sources.list.d/azure-cli.list
RUN echo 'deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bookworm main' >> /etc/apt/sources.list.d/azure-cli.list
RUN apt-get update && apt-get install -y azure-cli

# install gcloud 
RUN mkdir /opt/gcloud
WORKDIR /opt/gcloud
RUN curl https://sdk.cloud.google.com > install.sh
RUN chmod +x install.sh
RUN ./install.sh --disable-prompts --install-dir=/opt/gcloud

# install glab
RUN curl -s https://raw.githubusercontent.com/profclems/glab/trunk/scripts/install.sh | sh

# set up git
RUN git config --global safe.directory '*'
RUN git config --global user.email "thadbrown@flywheel.io"
RUN git config --global user.name "Thad Brown"
RUN git config --global pull.rebase false

# clean up homedir
RUN rm -rf /root/*

WORKDIR /go/src/gitlab.com/flywheel-io/

