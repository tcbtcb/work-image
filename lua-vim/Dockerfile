FROM golang:1.17-bullseye 

RUN apt-get update 

# build neovim from source
RUN apt-get install -y vim python3-venv ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen rsync
RUN cd /root && git clone https://github.com/neovim/neovim
RUN cd /root/neovim && make
RUN cd /root/neovim && make install


# # get config
WORKDIR /root
RUN git clone https://github.com/tcbtcb/work-image.git
RUN mkdir -p /root/.config/nvim
RUN mv /root/work-image/lua-vim/config/bootstrap_packer.tar /root/.config/nvim/
RUN cd /root/.config/nvim && tar -xvf bootstrap_packer.tar && mv works/* . 
RUN nvim +qa --headless
RUN rm -rf /root/.config/nvim/*
RUN rsync -aPh /root/work-image/lua-vim/config.bak/nvim/ /root/.config/nvim/
# RUN nvim --headless 'PackerInstall' +qa 
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
RUN timeout 120 nvim --headless || :
# 
# install some extra stuff 
# RUN curl -sL install-node.now.sh/lts | bash -s -- -y
