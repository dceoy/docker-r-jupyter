FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

COPY --from=dceoy/r-tidyverse:latest /usr/local /usr/local

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py

RUN set -e \
      && ln -sf bash /bin/sh \
      && ln -s python3 /usr/bin/python

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        apt-transport-https apt-utils ca-certificates curl file g++ gcc \
        gfortran git make libblas-dev libcurl4-gnutls-dev libgit2-dev \
        liblapack-dev libmariadb-dev libpq-dev libsqlite3-dev libssh-dev \
        libssl-dev libunwind-dev libxml2-dev lmodern locales p7zip-full \
        pandoc pbzip2 pigz python3-dev texlive-fonts-recommended \
        texlive-plain-generic texlive-xetex r-base \
      && apt-get -y autoremove \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && locale-gen en_US.UTF-8 \
      && update-locale

RUN set -e \
      && /usr/bin/python3 /tmp/get-pip.py \
      && pip install -U --no-cache-dir \
        bash_kernel jupyter jupyter_contrib_nbextensions jupyterthemes

RUN set -e \
      && clir update \
      && clir install --devt=cran dbplyr doParallel foreach ggpubr rmarkdown tidyverse \
      && clir validate dbplyr doParallel foreach ggpubr rmarkdown tidyverse

ENV HOME /home/notebook

RUN set -e \
      && mkdir ${HOME} \
      && /usr/bin/python3 -m bash_kernel.install \
      && clir install --devt=github IRkernel/IRkernel \
      && R -q -e 'IRkernel::installspec()' \
      && jupyter contrib nbextension install --system \
      && jt --theme oceans16 -f ubuntu --toolbar --nbname --vimext \
      && find ${HOME} -exec chmod 777 {} \;

EXPOSE 8888

ENTRYPOINT ["jupyter"]
CMD ["notebook", "--port=8888", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
