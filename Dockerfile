FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

# Pre-reqs
RUN apt-get update && apt-get install --no-install-recommends -y \
    git vim build-essential python3-dev python3-venv python3-pip openssl
# Instantiate venv and pre-activate
RUN pip3 install virtualenv
RUN virtualenv /venv
# Credit, Itamar Turner-Trauring: https://pythonspeed.com/articles/activate-virtualenv-dockerfile/
ENV VIRTUAL_ENV=/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install --upgrade pip setuptools && \
    pip3 install torch torchvision torchaudio

# Install AutoGPTQ
RUN pip install auto-gptq \
 && git clone https://github.com/PanQiWei/AutoGPTQ.git /AutoGPTQ \
 && cd /AutoGPTQ \
 && pip install . \
 && cd / \
 && rm -fr AutoGPTQ

# Install AutoGPTQ-API and requirements
RUN git clone https://github.com/mzbac/AutoGPTQ-API /app

WORKDIR /app
RUN pip install -r requirements.txt
RUN pip3 install google protobuf

# Create a Self-Signed certificate
RUN printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth"  > /tmp/config \
 && openssl req -x509 \
                -out cert.pem \
                -keyout key.pem \
                -newkey rsa:2048 \
                -nodes -sha256 \
                 -subj '/CN=localhost' \
                 -extensions EXT \
                 -config /tmp/config


RUN perl -pi -e 's/use_triton = False/use_triton = True/' blocking_api.py


VOLUME /app/models

CMD python blocking_api.py
