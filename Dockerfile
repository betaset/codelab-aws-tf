# This is the docker image used with igor.
# It contains all necesarry tools for this codelab.
# Base image is ubuntu to keep it similar to known host systems.

FROM ubuntu

CMD /bin/bash

ENV SWAMP_VERSION=0.10.0 \
    TF_VERSION=0.12.18 \
    AWS_REGION=eu-central-1

# add custom bashrc
COPY docker/bash.bashrc.custom.sh /etc/bash.bashrc.custom
RUN echo '. /etc/bash.bashrc.custom' >> /etc/bash.bashrc

# install stuff
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    python3-pip \
    build-essential \
    python3-dev \
    python3-setuptools \
    python3-wheel \
 && rm -rf /var/cache/apt

# install awscli
RUN pip3 install awscli \
 && rm -rf /root/.cache

# install swamp
RUN curl -sfL https://github.com/felixb/swamp/releases/download/v${SWAMP_VERSION}/swamp_amd64 > /usr/local/bin/swamp \
 && chmod +x /usr/local/bin/swamp

# install terraform
RUN curl -sfL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip > /tmp/tf.zip \
 && unzip /tmp/tf.zip \
 && mv terraform /usr/local/bin/ \
 && rm /tmp/tf.zip
