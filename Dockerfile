FROM ubuntu:16.04
WORKDIR /home

RUN apt-get update && apt-get install -y \
	curl \ 
	wget \
	ca-certificates \
	build-essential \
	ipython \
	python-pip \
	git 

RUN git clone https://github.com/flywheel-io/sdk workspace/src/flywheel.io/sdk 
RUN ln -s workspace/src/flywheel.io/sdk sdk 

# make go sdk 

RUN ./sdk/make.sh

# build bridge 

RUN ./sdk/bridge/make.sh

# update pip and install pythong sdk

RUN pip install sdk/bridge/dist/python
RUN pip install --upgrade pip
