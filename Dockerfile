FROM golang:1.15-buster as gobuild

# set modules on and platform for golang
ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64

# install flywheel golang sdk + other go tools
RUN go get github.com/flywheel-io/sdk/api
RUN go get -u github.com/spf13/cobra/cobra@v1.0.0
RUN go get github.com/gohugoio/hugo
RUN go get github.com/labstack/echo
RUN go get github.com/juliosueiras/terraform-lsp
RUN go get github.com/cespare/reflex
RUN go get go.mozilla.org/sops/v3/cmd/sops
RUN go get golang.org/x/tools/gopls@latest
RUN go get github.com/spf13/viper
RUN go get github.com/jesseduffield/lazygit
RUN go get github.com/piquette/finance-go
RUN go get github.com/jonwho/go-iex

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
    libopenblas-dev \
    gfortran \
    automake \
    g++ \
    unzip \
    zsh \
    fonts-firacode \
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
RUN pip3 install ranger-fm pynvim pipenv pymongo python-language-server awscli flywheel-sdk requests PyYAML pandas matplotlib scipy sklearn statsmodels

# get and build neovim
RUN git clone https://github.com/neovim/neovim.git && cd neovim && make CMAKE_BUILD_TYPE=Release && make install
RUN ln -s /usr/local/bin/nvim /usr/local/bin/vim

# install hstr
RUN echo "deb http://www.mindforger.com/debian stretch main" >> /etc/apt/sources.list
RUN wget -qO - http://www.mindforger.com/gpgpubkey.txt | apt-key add -
RUN apt-get update
RUN apt-get install -y hstr

# do some cleanup
RUN apt-get clean && apt-get autoclean
RUN rm -rf /root/.cache/

# configure root user 
USER root
WORKDIR /root

# change shell 
RUN chsh --shell /usr/bin/zsh root

# get nodejs
RUN curl -sL install-node.now.sh/lts | bash -s -- -y

# install some node lang servers
RUN npm install --unsafe -g typescript-language-server neovim vscode-css-languageserver-bin dockerfile-language-server-nodejs bash-language-server

# clone settings repo locally
RUN git clone https://github.com/tcbtcb/work-image.git

# config/install vim plugins
RUN mkdir -p /root/.config/nvim
RUN cp /root/work-image/init.vim /root/.config/nvim/
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN nvim +'PlugInstall' +qa --headless
RUN nvim +'CocInstall -sync coc-snippets coc-go coc-python coc-css coc-html coc-prettier coc-json coc-tsserver coc-yaml coc-sh' +qa --headless

# install bash + tmux files
RUN cp /root/work-image/bashrc /root/.bashrc 
RUN cp /root/work-image/bash_profile /root/.bash_profile
RUN cp /root/work-image/tmux.conf /root/.tmux.conf

# config zsh (experimental)
RUN cp /root/work-image/zshrc /root/.zshrc
RUN mkdir /root/.zsh
WORKDIR /root/.zsh
RUN git clone git@github.com:zdharma/fast-syntax-highlighting.git
RUN wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/lib/completion.zsh
RUN git clone git@github.com:zsh-users/zsh-autosuggestions.git

WORKDIR /root

# install gcloud 
RUN curl https://sdk.cloud.google.com > install.sh
RUN chmod +x install.sh
RUN ./install.sh --disable-prompts

WORKDIR /go/src/github.com/tcbtcb
