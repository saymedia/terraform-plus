FROM hashicorp/terraform:0.11.9

ENV GRAFANA_VERSION=1.3.0
ENV GRAFANA_FILE=terraform-provider-grafana_${GRAFANA_VERSION}_linux_amd64.zip
ENV GRAFANA_SHA=021a5bb8e267343197a495c4e74ae9546aa66d749173d7845ce814c415bafda1

RUN mkdir -p ~/.terraform.d/plugins && \
    curl https://releases.hashicorp.com/terraform-provider-grafana/${GRAFANA_VERSION}/${GRAFANA_FILE} > ${GRAFANA_FILE} && \
    echo "${GRAFANA_SHA}  ${GRAFANA_FILE}" | sha256sum -c - && \
    unzip ${GRAFANA_FILE} -d ~/.terraform.d/plugins && \
    rm -f ${GRAFANA_FILE}

ENV INFLUXDB_VERSION=1.0.3
ENV INFLUXDB_FILE=terraform-provider-influxdb_${INFLUXDB_VERSION}_linux_amd64.zip
ENV INFLUXDB_SHA=8bc3733af361fc659fcb7f9580afcd9273408a71c652ad2a9ae04fdea60a15e2

RUN mkdir -p ~/.terraform.d/plugins && \
    curl https://releases.hashicorp.com/terraform-provider-influxdb/${INFLUXDB_VERSION}/${INFLUXDB_FILE} > ${INFLUXDB_FILE} && \
    echo "${INFLUXDB_SHA}  ${INFLUXDB_FILE}" | sha256sum -c - && \
    unzip ${INFLUXDB_FILE} -d ~/.terraform.d/plugins && \
    rm -f ${INFLUXDB_FILE}

ENV RUNDECK_VERSION=0.1.0
ENV RUNDECK_FILE=terraform-provider-rundeck_${RUNDECK_VERSION}_linux_amd64.zip
ENV RUNDECK_SHA=442a7a23e172dc1f736ecd20cabe45ca27f47209c8ab24aa0424ecf2c539fc87

RUN mkdir -p ~/.terraform.d/plugins && \
    curl https://releases.hashicorp.com/terraform-provider-rundeck/${RUNDECK_VERSION}/${RUNDECK_FILE} > ${RUNDECK_FILE} && \
    echo "${RUNDECK_SHA}  ${RUNDECK_FILE}" | sha256sum -c - && \
    unzip ${RUNDECK_FILE} -d ~/.terraform.d/plugins && \
    rm -f ${RUNDECK_FILE}

ENV TEMPLATE_VERSION=1.0.0
ENV TEMPLATE_FILE=terraform-provider-template_${TEMPLATE_VERSION}_linux_amd64.zip
ENV TEMPLATE_SHA=f54c2764bd4d4c62c1c769681206dde7aa94b64b814a43cb05680f1ec8911977

RUN mkdir -p ~/.terraform.d/plugins && \
    curl https://releases.hashicorp.com/terraform-provider-template/${TEMPLATE_VERSION}/${TEMPLATE_FILE} > ${TEMPLATE_FILE} && \
    echo "${TEMPLATE_SHA}  ${TEMPLATE_FILE}" | sha256sum -c - && \
    unzip ${TEMPLATE_FILE} -d ~/.terraform.d/plugins && \
    rm -f ${TEMPLATE_FILE}

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

ENV MYSQL_VERSION=1.5.1
ENV MYSQL_FILE=terraform-provider-mysql_${MYSQL_VERSION}_linux_amd64.zip
ENV MYSQL_SHA=3f375d9d7f91e580f33ecdd4131d91aef75dbf56ffeb4d67f1b173ae1cc2cc3b

RUN mkdir -p ~/.terraform.d/plugins && \
    curl https://releases.hashicorp.com/terraform-provider-mysql/${MYSQL_VERSION}/${MYSQL_FILE} > ${MYSQL_FILE} && \
    echo "${MYSQL_SHA}  ${MYSQL_FILE}" | sha256sum -c - && \
    unzip ${MYSQL_FILE} -d ~/.terraform.d/plugins && \
    rm -f ${MYSQL_FILE}

ENV NULL_VERSION=2.1.0
ENV NULL_FILE=terraform-provider-null_${NULL_VERSION}_linux_amd64.zip
ENV NULL_SHA=b27db66404ea0704fb076ef26bb5b5c556a31b81a8b2302ec705a7e46d93d3e0

RUN mkdir -p ~/.terraform.d/plugins && \
    curl https://releases.hashicorp.com/terraform-provider-null/${NULL_VERSION}/${NULL_FILE} > ${NULL_FILE} && \
    echo "${NULL_SHA}  ${NULL_FILE}" | sha256sum -c - && \
    unzip ${NULL_FILE} -d ~/.terraform.d/plugins && \
    rm -f ${NULL_FILE}
