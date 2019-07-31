FROM ubuntu:18.04

RUN apt update -q && apt install -y build-essential &&\
	apt install -y gcc-multilib && apt install -y qemu-system-x86
