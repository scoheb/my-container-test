
# Copyright 2019 Red Hat
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ------------------------------------------------------------------------
#
# This is a Dockerfile for the jboss-eap-7/eap73-openjdk11-openshift-rhel8:7.3.0 image.

FROM ubi8:8-released

USER root

# Add scripts used to configure the image
COPY modules /tmp/scripts/

# Add all artifacts to the /tmp/artifacts directory
COPY \
    maven-repo.zip \
    artifacts/txn-recovery-marker-jdbc-common-1.1.4.Final-redhat-00001.jar \
    artifacts/txn-recovery-marker-jdbc-hibernate5-1.1.4.Final-redhat-00001.jar \
    activemq-rar-5.11.0.redhat-630371.rar \
    artifacts/jolokia-jvm-1.6.2.redhat-00002-agent.jar \
    artifacts/rh-sso-7.3.1-eap7-adapter.zip \
    artifacts/rh-sso-7.3.1-saml-eap7-adapter.zip \
    artifacts/jmx_prometheus_javaagent-0.3.1.redhat-00006.jar \
    /tmp/artifacts/

# begin jboss.container.user:1.0

# Install required RPMs and ensure that the packages were installed
USER root
RUN dnf --setopt=tsflags=nodocs install -y unzip tar rsync shadow-utils \
    && rpm -q unzip tar rsync shadow-utils

# Environment variables
ENV \
    HOME="/home/jboss" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.user/configure.sh" ]

# end jboss.container.user:1.0
# begin jboss.container.openjdk.jdk:11

# Install required RPMs and ensure that the packages were installed
USER root
RUN dnf --setopt=tsflags=nodocs install -y java-11-openjdk-devel \
    && rpm -q java-11-openjdk-devel

# Environment variables
ENV \
    JAVA_HOME="/usr/lib/jvm/java-11" \
    JAVA_VENDOR="openjdk" \
    JAVA_VERSION="11.0" \
    JBOSS_CONTAINER_OPENJDK_JDK_MODULE="/opt/jboss/container/openjdk/jdk" 

# Labels
LABEL \
      org.jboss.product="openjdk"  \
      org.jboss.product.openjdk.version="11.0"  \
      org.jboss.product.version="11.0" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.openjdk.jdk/configure.sh" ]

# end jboss.container.openjdk.jdk:11
# begin jboss.container.maven.35.bash:3.5

# Install required RPMs and ensure that the packages were installed
USER root
RUN dnf --setopt=tsflags=nodocs install -y maven \
    && rpm -q maven

# Environment variables
ENV \
    JBOSS_CONTAINER_MAVEN_35_MODULE="/opt/jboss/container/maven/35/" \
    MAVEN_VERSION="3.5" 

# Labels
LABEL \
      io.fabric8.s2i.version.maven="3.5" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.maven.35.bash/configure.sh" ]

# end jboss.container.maven.35.bash:3.5
# begin eap-73-env:7.3.0

# Environment variables
ENV \
    JBOSS_EAP_VERSION="7.3.0" \
    JBOSS_HOME="/opt/eap" \
    JBOSS_PRODUCT="eap" \
    LAUNCH_JBOSS_IN_BACKGROUND="true" \
    PRODUCT_VERSION="7.3.0" \
    WILDFLY_VERSION="7.3.0.SP1-redhat-00001" 

# Labels
LABEL \
      com.redhat.deployments-dir="/opt/eap/standalone/deployments"  \
      com.redhat.dev-mode="DEBUG:true"  \
      com.redhat.dev-mode.port="DEBUG_PORT:8787"  \
      org.jboss.product="eap"  \
      org.jboss.product.eap.version="7.3.0"  \
      org.jboss.product.version="7.3.0" 

# Exposed ports
EXPOSE 8080
# end eap-73-env:7.3.0
# begin eap-73-env-latest:1.0

# end eap-73-env-latest:1.0
# begin jboss.container.eap.setup:1.0

# Environment variables
ENV \
    SSO_FORCE_LEGACY_SECURITY="true" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.setup/configure.sh" ]

# end jboss.container.eap.setup:1.0
# begin eap-install-cleanup:1.0

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/eap-install-cleanup/install.sh" ]

# end eap-install-cleanup:1.0
# begin jboss.container.maven.api:1.0

# end jboss.container.maven.api:1.0
# begin jboss.container.java.jvm.api:1.0

# end jboss.container.java.jvm.api:1.0
# begin jboss.container.proxy.api:2.0

# end jboss.container.proxy.api:2.0
# begin jboss.container.java.proxy.bash:2.0

# Environment variables
ENV \
    JBOSS_CONTAINER_JAVA_PROXY_MODULE="/opt/jboss/container/java/proxy" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.java.proxy.bash/configure.sh" ]
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.java.proxy.bash/backward_compatibility.sh" ]

# end jboss.container.java.proxy.bash:2.0
# begin jboss.container.java.jvm.bash:1.0

# Environment variables
ENV \
    JBOSS_CONTAINER_JAVA_JVM_MODULE="/opt/jboss/container/java/jvm" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.java.jvm.bash/configure.sh" ]
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.java.jvm.bash/backward_compatibility.sh" ]

# end jboss.container.java.jvm.bash:1.0
# begin jboss.container.util.logging.bash:1.0

# Environment variables
ENV \
    JBOSS_CONTAINER_UTIL_LOGGING_MODULE="/opt/jboss/container/util/logging/" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.util.logging.bash/configure.sh" ]
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.util.logging.bash/backward_compatibility.sh" ]

# end jboss.container.util.logging.bash:1.0
# begin jboss.container.maven.default.bash:1.0

# Environment variables
ENV \
    JBOSS_CONTAINER_MAVEN_DEFAULT_MODULE="/opt/jboss/container/maven/default/" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.maven.default.bash/configure.sh" ]
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.maven.default.bash/backward_compatibility.sh" ]

# end jboss.container.maven.default.bash:1.0
# begin dynamic-resources:1.0

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/dynamic-resources/install.sh" ]

# end dynamic-resources:1.0
# begin jboss.container.s2i.core.api:1.0

# Environment variables
ENV \
    S2I_SOURCE_DEPLOYMENTS_FILTER="*" 

# Labels
LABEL \
      io.openshift.s2i.destination="/tmp"  \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i"  \
      org.jboss.container.deployments-dir="/deployments" 

# end jboss.container.s2i.core.api:1.0
# begin jboss.container.maven.s2i.api:1.0

# end jboss.container.maven.s2i.api:1.0
# begin jboss.container.s2i.core.bash:1.0

# Environment variables
ENV \
    JBOSS_CONTAINER_S2I_CORE_MODULE="/opt/jboss/container/s2i/core/" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.s2i.core.bash/configure.sh" ]

# end jboss.container.s2i.core.bash:1.0
# begin jboss.container.maven.s2i.bash:1.0

# Environment variables
ENV \
    JBOSS_CONTAINER_MAVEN_S2I_MODULE="/opt/jboss/container/maven/s2i" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.maven.s2i.bash/configure.sh" ]

# end jboss.container.maven.s2i.bash:1.0
# begin jboss.container.wildfly.s2i.bash:1.0

# Environment variables
ENV \
    GALLEON_LOCAL_MAVEN_REPO="/opt/jboss/container/wildfly/s2i/galleon/galleon-m2-repository" \
    GALLEON_MAVEN_BUILD_IMG_SETTINGS_XML="/opt/jboss/container/wildfly/s2i/galleon/build-image-settings.xml" \
    GALLEON_MAVEN_SETTINGS_XML="/opt/jboss/container/wildfly/s2i/galleon/settings.xml" \
    GALLEON_VERSION="4.1.2.Final" \
    GALLEON_WILDFLY_VERSION="4.1.2.Final" \
    JBOSS_CONTAINER_WILDFLY_S2I_GALLEON_DIR="/opt/jboss/container/wildfly/s2i/galleon" \
    JBOSS_CONTAINER_WILDFLY_S2I_GALLEON_PROVISION="/opt/jboss/container/wildfly/s2i/galleon/provisioning/generic_provisioning" \
    JBOSS_CONTAINER_WILDFLY_S2I_MODULE="/opt/jboss/container/wildfly/s2i" \
    S2I_COPY_SERVER="true" \
    S2I_SOURCE_DEPLOYMENTS_FILTER="*.war *.ear *.rar *.jar" \
    TMP_GALLEON_LOCAL_MAVEN_REPO="/opt/jboss/container/wildfly/s2i/galleon/tmp-galleon-m2-repository" \
    WILDFLY_S2I_OUTPUT_DIR="/s2i-output" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.s2i.bash/configure.sh" ]

# end jboss.container.wildfly.s2i.bash:1.0
# begin jboss.container.eap.s2i.galleon:1.0

# Install required RPMs and ensure that the packages were installed
USER root
RUN dnf --setopt=tsflags=nodocs install -y diffutils \
    && rpm -q diffutils

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.s2i.galleon/configure.sh" ]
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.s2i.galleon/backward_compatibility.sh" ]

# end jboss.container.eap.s2i.galleon:1.0
# begin jboss.container.eap.galleon:1.0

# Environment variables
ENV \
    DELETE_BUILD_ARTIFACTS="true" \
    GALLEON_BUILD_FP_MAVEN_ARGS_APPEND="-Dcom.redhat.xpaas.repo.jbossorg" \
    GALLEON_DEFAULT_FAT_SERVER="/opt/jboss/container/eap/galleon/definitions/fat-default-server" \
    GALLEON_DEFAULT_SERVER="/opt/jboss/container/eap/galleon/definitions/slim-default-server" \
    GALLEON_DEFINITIONS="/opt/jboss/container/eap/galleon/definitions" \
    GALLEON_FP_COMMON_PKG_NAME="eap.s2i.common" \
    GALLEON_FP_PATH="/opt/jboss/container/eap/galleon/eap-s2i-galleon-pack" \
    GALLEON_PROVISON_FP_MAVEN_ARGS_APPEND="-Dcom.redhat.xpaas.repo.jbossorg" \
    GALLEON_S2I_FP_ARTIFACT_ID="eap-s2i-galleon-pack" \
    GALLEON_S2I_FP_GROUP_ID="org.jboss.eap.galleon.s2i" \
    GALLEON_S2I_PRODUCER_NAME="eap-s2i" \
    JBOSS_CONTAINER_EAP_GALLEON_FP_PACKAGES="/opt/jboss/container/eap/galleon/eap-s2i-galleon-pack/src/main/resources/packages" \
    OFFLINER_URLS="--url https://repo1.maven.org/maven2/ --url https://repository.jboss.org/nexus/content/groups/public/ --url https://maven.repository.redhat.com/ga/" \
    S2I_FP_VERSION="18.0.0.Final" \
    WILDFLY_DIST_MAVEN_LOCATION="https://repository.jboss.org/nexus/content/groups/public/org/wildfly/wildfly-dist" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.galleon/configure.sh" ]

# end jboss.container.eap.galleon:1.0
# begin jboss.container.eap.galleon.build-settings:osbs

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.galleon.build-settings/configure.sh" ]

# end jboss.container.eap.galleon.build-settings:osbs
# begin jboss.container.eap.openshift.modules:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.openshift.modules/configure.sh" ]

# end jboss.container.eap.openshift.modules:1.0
# begin os-eap-activemq-rar:1.1

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/os-eap-activemq-rar/configure.sh" ]

# end os-eap-activemq-rar:1.1
# begin jboss.container.eap.amq6:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.amq6/configure.sh" ]

# end jboss.container.eap.amq6:1.0
# begin os-eap-migration:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/os-eap-migration/configure.sh" ]

# end os-eap-migration:1.0
# begin jboss.container.eap.launch:1.0

# Install required RPMs and ensure that the packages were installed
USER root
RUN dnf --setopt=tsflags=nodocs install -y hostname \
    && rpm -q hostname

# Environment variables
ENV \
    DEFAULT_ADMIN_USERNAME="eapadmin" 

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.launch/configure.sh" ]

# end jboss.container.eap.launch:1.0
# begin jboss.container.wildfly.launch.admin:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.admin/configure.sh" ]

# end jboss.container.wildfly.launch.admin:1.0
# begin jboss.container.wildfly.launch.access-log-valve:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.access-log-valve/configure.sh" ]

# end jboss.container.wildfly.launch.access-log-valve:1.0
# begin jboss.container.wildfly.launch-config.config:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch-config.config/configure.sh" ]

# end jboss.container.wildfly.launch-config.config:1.0
# begin jboss.container.wildfly.launch-config.os:1.0

# Environment variables
ENV \
    JBOSS_MODULES_SYSTEM_PKGS="org.jboss.logmanager,jdk.nashorn.api,com.sun.crypto.provider" 

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch-config.os/configure.sh" ]

# end jboss.container.wildfly.launch-config.os:1.0
# begin jboss.container.wildfly.launch.os.node-name:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.os.node-name/configure.sh" ]

# end jboss.container.wildfly.launch.os.node-name:1.0
# begin jboss.container.wildfly.launch.datasources:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.datasources/configure.sh" ]

# end jboss.container.wildfly.launch.datasources:1.0
# begin jboss.container.wildfly.launch.extensions:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.extensions/configure.sh" ]

# end jboss.container.wildfly.launch.extensions:1.0
# begin jboss.container.wildfly.launch.json-logging:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.json-logging/configure.sh" ]

# end jboss.container.wildfly.launch.json-logging:1.0
# begin jboss.container.wildfly.launch.jgroups:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.jgroups/configure.sh" ]

# end jboss.container.wildfly.launch.jgroups:1.0
# begin jboss.container.wildfly.launch.filters:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.filters/configure.sh" ]

# end jboss.container.wildfly.launch.filters:1.0
# begin jboss.container.wildfly.launch.logger-category:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.logger-category/configure.sh" ]

# end jboss.container.wildfly.launch.logger-category:1.0
# begin jboss.container.wildfly.launch.mp-config:1.0

# Environment variables
ENV \
    MICROPROFILE_CONFIG_DIR_ORDINAL="500" 

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.mp-config/configure.sh" ]

# end jboss.container.wildfly.launch.mp-config:1.0
# begin jboss.container.wildfly.launch.tracing:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.tracing/configure.sh" ]

# end jboss.container.wildfly.launch.tracing:1.0
# begin jboss.container.wildfly.launch.deployment-scanner:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.deployment-scanner/configure.sh" ]

# end jboss.container.wildfly.launch.deployment-scanner:1.0
# begin jboss.container.wildfly.launch.keycloak:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.keycloak/configure.sh" ]

# end jboss.container.wildfly.launch.keycloak:1.0
# begin jboss.container.wildfly.launch.https:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.https/configure.sh" ]

# end jboss.container.wildfly.launch.https:1.0
# begin jboss.container.wildfly.launch.security-domains:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.security-domains/configure.sh" ]

# end jboss.container.wildfly.launch.security-domains:1.0
# begin jboss.container.wildfly.launch.elytron:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.elytron/configure.sh" ]

# end jboss.container.wildfly.launch.elytron:1.0
# begin jboss.container.wildfly.launch.port-offset:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.port-offset/configure.sh" ]

# end jboss.container.wildfly.launch.port-offset:1.0
# begin jboss.container.wildfly.launch.resource-adapters:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.resource-adapters/configure.sh" ]

# end jboss.container.wildfly.launch.resource-adapters:1.0
# begin jboss.container.wildfly.launch.messaging:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.launch.messaging/configure.sh" ]

# end jboss.container.wildfly.launch.messaging:1.0
# begin jboss.container.wildfly.galleon.fp-content.keycloak:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.galleon.fp-content.keycloak/configure.sh" ]

# end jboss.container.wildfly.galleon.fp-content.keycloak:1.0
# begin jboss.container.jolokia.api:1.0

# Environment variables
ENV \
    AB_JOLOKIA_AUTH_OPENSHIFT="true" \
    AB_JOLOKIA_HTTPS="true" \
    AB_JOLOKIA_PASSWORD_RANDOM="true" 

# end jboss.container.jolokia.api:1.0
# begin jboss.container.jolokia.bash:1.0

# Environment variables
ENV \
    AB_JOLOKIA_AUTH_OPENSHIFT="true" \
    AB_JOLOKIA_HTTPS="true" \
    AB_JOLOKIA_PASSWORD_RANDOM="true" \
    JBOSS_CONTAINER_JOLOKIA_MODULE="/opt/jboss/container/jolokia" \
    JOLOKIA_VERSION="1.6.2" 

# Labels
LABEL \
      io.fabric8.s2i.version.jolokia="1.6.2-redhat-00002" 

# Exposed ports
EXPOSE 8778
# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.jolokia.bash/configure.sh" ]
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.jolokia.bash/backward_compatibility.sh" ]

# end jboss.container.jolokia.bash:1.0
# begin jboss.container.wildfly.galleon.fp-content.jolokia:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.galleon.fp-content.jolokia/configure.sh" ]

# end jboss.container.wildfly.galleon.fp-content.jolokia:1.0
# begin jboss.container.wildfly.galleon.fp-content.java:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.galleon.fp-content.java/configure.sh" ]

# end jboss.container.wildfly.galleon.fp-content.java:1.0
# begin jboss.container.wildfly.galleon.fp-content.base-layers:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.galleon.fp-content.base-layers/configure.sh" ]

# end jboss.container.wildfly.galleon.fp-content.base-layers:1.0
# begin jboss.container.wildfly.galleon.fp-content.mvn:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.galleon.fp-content.mvn/configure.sh" ]

# end jboss.container.wildfly.galleon.fp-content.mvn:1.0
# begin jboss.container.wildfly.galleon.fp-content.ejb-tx-recovery:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.galleon.fp-content.ejb-tx-recovery/configure.sh" ]

# end jboss.container.wildfly.galleon.fp-content.ejb-tx-recovery:1.0
# begin os-eap-probes-common:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/os-eap-probes-common/configure.sh" ]

# end os-eap-probes-common:1.0
# begin os-eap-probes:3.0

# Install required RPMs and ensure that the packages were installed
USER root
RUN dnf --setopt=tsflags=nodocs install -y python3-requests \
    && rpm -q python3-requests

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/os-eap-probes/configure.sh" ]

# end os-eap-probes:3.0
# begin os-eap70-sso:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/os-eap70-sso/configure.sh" ]

# end os-eap70-sso:1.0
# begin jboss.container.eap.hawkular:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.hawkular/configure.sh" ]

# end jboss.container.eap.hawkular:1.0
# begin openshift-layer:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/openshift-layer/configure_layers.sh" ]

# end openshift-layer:1.0
# begin openshift-passwd:1.0

# end openshift-passwd:1.0
# begin jboss.container.prometheus.api:1.0

# end jboss.container.prometheus.api:1.0
# begin jboss.container.prometheus.bash:1.0

# Environment variables
ENV \
    AB_PROMETHEUS_JMX_EXPORTER_CONFIG="/opt/jboss/container/prometheus/etc/jmx-exporter-config.yaml" \
    AB_PROMETHEUS_JMX_EXPORTER_PORT="9799" \
    JBOSS_CONTAINER_PROMETHEUS_MODULE="/opt/jboss/container/prometheus" 

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.prometheus.bash/configure.sh" ]

# end jboss.container.prometheus.bash:1.0
# begin jboss.container.eap.prometheus.jmx-exporter-config:1.0

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.prometheus.jmx-exporter-config/configure.sh" ]

# end jboss.container.eap.prometheus.jmx-exporter-config:1.0
# begin jboss.container.eap.prometheus.config:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.prometheus.config/configure.sh" ]

# end jboss.container.eap.prometheus.config:1.0
# begin os-eap-txnrecovery.bash:1.0

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/os-eap-txnrecovery.bash/install_as_root.sh" ]

# end os-eap-txnrecovery.bash:1.0
# begin os-eap-txnrecovery.run:python3

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/os-eap-txnrecovery.run/install_as_root.sh" ]

# end os-eap-txnrecovery.run:python3
# begin jboss.container.wildfly.galleon.build-feature-pack:1.0

# Environment variables
ENV \
    OFFLINER_VERSION="1.6" 

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.galleon.build-feature-pack/configure.sh" ]

# end jboss.container.wildfly.galleon.build-feature-pack:1.0
# begin jboss.container.wildfly.galleon.provision-server:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.wildfly.galleon.provision-server/configure.sh" ]

# end jboss.container.wildfly.galleon.provision-server:1.0
# begin jboss.container.eap.final-setup:1.0

# Custom scripts
USER 185
RUN [ "bash", "-x", "/tmp/scripts/jboss.container.eap.final-setup/configure.sh" ]

# end jboss.container.eap.final-setup:1.0
# begin os-eap-python:3.6

# Install required RPMs and ensure that the packages were installed
USER root
RUN dnf --setopt=tsflags=nodocs install -y python36 \
    && rpm -q python36

# Custom scripts
USER root
RUN [ "bash", "-x", "/tmp/scripts/os-eap-python/configure.sh" ]

# end os-eap-python:3.6
# begin jboss-eap-7/eap73-openjdk11-openshift-rhel8:7.3.0

# Environment variables
ENV \
    HTTPS_ENABLE_HTTP2="true" \
    JBOSS_IMAGE_NAME="jboss-eap-7/eap73-openjdk11-openshift-rhel8" \
    JBOSS_IMAGE_VERSION="7.3.0" 

# Labels
LABEL \
      com.redhat.component="jboss-eap-7-eap73-openjdk11-openshift-rhel8-container"  \
      description="Red Hat JBoss Enterprise Application Platform 7.3 OpenShift container image."  \
      io.cekit.version="3.2.1"  \
      io.k8s.description="Platform for building and running JavaEE applications on JBoss EAP 7.3"  \
      io.k8s.display-name="JBoss EAP 7.3"  \
      io.openshift.expose-services="8080:http"  \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i"  \
      io.openshift.tags="builder,javaee,eap,eap7"  \
      maintainer="Red Hat"  \
      name="jboss-eap-7/eap73-openjdk11-openshift-rhel8"  \
      summary="Red Hat JBoss Enterprise Application Platform 7.3 OpenShift container image."  \
      version="7.3.0" 

# Exposed ports
EXPOSE 8443
# end jboss-eap-7/eap73-openjdk11-openshift-rhel8:7.3.0

USER root
RUN [ ! -d /tmp/scripts ] || rm -rf /tmp/scripts
RUN [ ! -d /tmp/artifacts ] || rm -rf /tmp/artifacts

# Clear package manager metadata
RUN dnf clean all && [ ! -d /var/cache/yum ] || rm -rf /var/cache/yum



# Run user
USER 185

# Specify the working directory
WORKDIR /home/jboss

# Specify run cmd
CMD ["/opt/eap/bin/openshift-launch.sh"]
