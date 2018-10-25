FROM dceoy/r-tidyverse:latest

ADD https://bootstrap.pypa.io/get-pip.py /tmp/get-pip.py

RUN set -e \
      && apt-get -y update \
      && apt-get -y dist-upgrade \
      && apt-get -y autoremove \
      && apt-get -y install --no-install-recommends --no-install-suggests \
        python3-dev \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN set -e \
      && python3 /tmp/get-pip.py \
      && pip install -U --no-cache-dir \
        bash_kernel jupyter jupyter_contrib_nbextensions jupyterthemes

ENV HOME /home/notebook

RUN set -e \
      && mkdir ${HOME} \
      && python3 -m bash_kernel.install \
      && clir install --devt=github IRkernel/IRkernel \
      && R -q -e 'IRkernel::installspec()' \
      && jupyter contrib nbextension install --system \
      && jt --theme oceans16 --toolbar --nbname --vimext \
      && find ${HOME} -exec chmod 777 {} \;

EXPOSE 8888

ENTRYPOINT ["jupyter"]
CMD ["notebook", "--port=8888", "--ip=0.0.0.0", "--allow-root", "--no-browser"]
