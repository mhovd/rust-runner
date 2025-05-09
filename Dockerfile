FROM myoung34/github-runner:latest

USER root

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    bash \
 && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
 && echo 'source $HOME/.cargo/env' >> /etc/profile \
 && ln -s $HOME/.cargo/bin/* /usr/local/bin/ \
 && apt-get clean
