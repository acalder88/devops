FROM 775504875675.dkr.ecr.us-east-1.amazonaws.com/development/common/xtiva-mini-base
MAINTAINER Alejandro Calderon <acalderon@psl.com.co>
LABEL description="Saasadmin - bootstrap: containerused to bootstrap the saas application."
COPY poc-cd.jar /opt/xtiva/
COPY TaskListRunner.sh /
WORKDIR /opt/xtiva
ENTRYPOINT /TaskListRunner.sh
