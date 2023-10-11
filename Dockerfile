FROM ubuntu

RUN apt update
RUN apt install -y wget unzip python3 python-is-python3 python3.10-venv git autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev

RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install 3.2.2
RUN bash -lc "rbenv global 3.2.2; gem install bundler"

WORKDIR /root
RUN wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
RUN unzip aws-sam-cli-linux-x86_64.zip -d /root/sam-installation
RUN /root/sam-installation/install

RUN git clone https://github.com/aws/aws-sam-cli.git
RUN python -m venv .venv
#RUN source .venv/bin/activate; cd aws-sam-cli; make init; ln -s /usr/bin/samdev $(which samdev)
RUN bash -lc "source .venv/bin/activate && cd aws-sam-cli && make init && ln -s /root/.venv/bin/samdev /usr/bin/"
ADD test_upgrade_to_ruby_3_2 /lambda
