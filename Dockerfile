FROM hashicorp/terraform:0.11.9

ENV CONSUL_VERSION=2.2.0
ENV CONSUL_FILE=terraform-provider-consul_${CONSUL_VERSION}_linux_amd64.zip
ENV CONSUL_SHA=c2e813c49557c2f997bdd0df0b2b9d17bdf456d251ab8eff30b76e7827fece3c

RUN mkdir -p ~/.terraform.d/plugins && \
    curl https://releases.hashicorp.com/terraform-provider-consul/${CONSUL_VERSION}/${CONSUL_FILE} > ${CONSUL_FILE} && \
    echo "${CONSUL_SHA}  ${CONSUL_FILE}" | sha256sum -c - && \
    unzip ${CONSUL_FILE} -d ~/.terraform.d/plugins && \
    rm -f ${CONSUL_FILE}

ENV AWS_VERSION=1.41.0
ENV AWS_FILE=terraform-provider-aws_${AWS_VERSION}_linux_amd64.zip
ENV AWS_SHA=0cce66e43cbeea6cdd1a4c3519cfed9fac9906404d087ec72e3b51b2e08f6f02

RUN mkdir -p ~/.terraform.d/plugins && \
    curl https://releases.hashicorp.com/terraform-provider-aws/${AWS_VERSION}/${AWS_FILE} > ${AWS_FILE} && \
    echo "${AWS_SHA}  ${AWS_FILE}" | sha256sum -c - && \
    unzip ${AWS_FILE} -d ~/.terraform.d/plugins && \
    rm -f ${AWS_FILE}

