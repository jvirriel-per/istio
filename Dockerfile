FROM docker.io/google/cloud-sdk:alpine
ENV ISTIO_VERSION=1.6.8
ENV KUBE_VERSION=v1.17.3
WORKDIR /istioctl

RUN apk update && apk upgrade && apk add curl  && apk add tar &&\
        rm -rf /var/lib/apt/lists/* && \
        rm /var/cache/apk/*

RUN curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.6.8 TARGET_ARCH=x86_64 sh -
# COPY /istio-${ISTIO_VERSION} ./istio-${ISTIO_VERSION}
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl
RUN chmod u+x kubectl && chmod u+x istio-${ISTIO_VERSION}/bin/istioctl
RUN mv istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl && mv kubectl /usr/local/bin/kubectl
 
RUN adduser -D istio
RUN chown istio:istio /usr/local/bin/istioctl && \
         chown istio:istio /usr/local/bin/kubectl && \
         chown istio:istio /istioctl/istio-${ISTIO_VERSION}
WORKDIR /app
USER istio
