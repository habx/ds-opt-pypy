FROM pypy:3.6-stretch

RUN echo "deb http://ftp.debian.org/debian testing main" >> /etc/apt/sources.list && \
    apt-get update && apt-get install -t testing -y g++

RUN wget https://habx-artifacts.s3-eu-west-1.amazonaws.com/ortools-cppyy.tar.gz && \
    tar xvzf ortools-cppyy.tar.gz && \
    mkdir -p /usr/local/site-packages/cppyy_backend/lib && \
    mkdir -p /usr/local/site-packages/cppyy_backend/include && \
    cp -pr ortools-cppyy/lib/* /usr/local/site-packages/cppyy_backend/lib/ && \
    cp -pr ortools-cppyy/lib/* /usr/lib/ && \
    cp -pr ortools-cppyy/include/* /usr/local/site-packages/cppyy_backend/include/

COPY requirements.txt .

# GCC 8+ is needed to build cppyy
RUN apt-get -y install libgeos-dev && \
    pip3 install -r requirements.txt

RUN rm /usr/bin/python3 && \
    ln -s /usr/local/bin/pypy3 /usr/bin/python3

RUN cp -pr ortools_space_planner_pypy/ /usr/local/site-packages/

ENV CPPYY_DISABLE_FASTPATH=1
CMD ["bin/worker.py"]
