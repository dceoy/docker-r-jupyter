FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

COPY --from=dceoy/r-tidyverse:latest /usr/local /usr/local

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py

RUN set -e \
      && ln -sf /bin/bash /bin/sh

RUN set -e \
      && apt-get -y update \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https apt-utils ca-certificates gnupg \
      && echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" \
        > /etc/apt/sources.list.d/r.list \
      && apt-key adv --keyserver keyserver.ubuntu.com \
        --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        curl file g++ gcc gfortran git make libblas-dev libcurl4-gnutls-dev \
        libgit2-dev liblapack-dev libmariadb-client-lgpl-dev libpq-dev \
        libsqlite3-dev libssh2-1-dev libssl-dev libunwind-dev libxml2-dev \
        lmodern locales p7zip-full pandoc pbzip2 pigz python3.8-dev \
        texlive-fonts-recommended texlive-generic-recommended texlive-xetex \
        r-base \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && locale-gen en_US.UTF-8 \
      && update-locale

RUN set -e \
      && ln -sf /usr/bin/python3.8 /usr/bin/python \
      && ln -sf /usr/bin/python3.8 /usr/bin/python3 \
      && /usr/bin/python /tmp/get-pip.py \
      && pip install -U --no-cache-dir \
        bash_kernel jupyter jupyter_contrib_nbextensions jupyterthemes

RUN set -e \
      && clir update \
      && clir install --devt=cran dbplyr doParallel foreach ggpubr rmarkdown tidyverse \
      && clir validate dbplyr doParallel foreach ggpubr rmarkdown tidyverse

ENV HOME /home/notebook

RUN set -e \
      && mkdir ${HOME} \
      && /usr/bin/python -m bash_kernel.install \
      && clir install --devt=github IRkernel/IRkernel \
      && R -q -e 'IRkernel::installspec()' \
      && jupyter contrib nbextension install --system \
      && jt --theme oceans16 -f ubuntu --toolbar --nbname --vimext \
      && find ${HOME} -exec chmod 777 {} \;

EXPOSE 8888

ENTRYPOINT ["jupyter"]
CMD ["notebook", "--port=8888", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
