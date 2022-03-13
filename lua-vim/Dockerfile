FROM golang:1.17-bullseye 

RUN apt-get update 

# build neovim from source
RUN apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen rsync
RUN cd /root && git clone https://github.com/neovim/neovim
RUN cd /root/neovim && make
RUN cd /root/neovim && make install


# # get config
# WORKDIR /root
# RUN git clone https://github.com/tcbtcb/work-image.git
# RUN ls
# RUN mkdir -p /root/.config/nvim
# RUN rsync -aPh /root/work-image/lua-vim/nvim/ /root/.config/nvim/
# RUN nvim +qa --headless
# RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
# 
# install some extra stuff 
RUN curl -sL install-node.now.sh/lts | bash -s -- -y
