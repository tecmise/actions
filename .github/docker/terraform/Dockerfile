FROM hashicorp/terraform:1.1.4
ENV TZ="America/Sao_Paulo"
ENV TIME_STAMP="${TIME_STAMP}"
RUN apk update
RUN apk add --no-cache tzdata curl coreutils py-pip bash
RUN cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /terraform-files

ARG TERRAFORM_FOLDER

COPY $TERRAFORM_FOLDER .

