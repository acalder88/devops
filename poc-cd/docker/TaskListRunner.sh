#!/bin/bash
#===============================================================================
# FILE          :   TaskListRunner.sh
# USAGE         :   This is the entrypoint for the containers of the framework
# DESCRIPTION   :   This script is used to launch all the required tasks to
#                   start a container in marathon context
# OPTIONS       :   none
# REQUIREMENTS  :   Will be called by the entrypoint setup in each Dockerfile
# BUGS          :   none
# NOTES         :   Commont Version
# AUTHOR        :   Fabrizio Sgura (FS), fsgura@psl.com.co
# ORGANIZATION  :   PSL Productora de Software ltda
# CREATED       :   05/18/2016 12:34
# VERSION       :   Version 4.0
#===============================================================================
# DEBUG SET OPTIONS (when testing syntax execute bash -n ThisScriptName)
# debug option, uncomment to trace script steps
#set -o xtrace
#set -o errexit -o nounset -o pipefail
#===============================================================================
#-------------------------------------------------------------------------------
# Global variables to autoidentify the current application coordinates
#-------------------------------------------------------------------------------
# The following variable identifies the master marathon group containing the
# The next variable identifies the name of the service
#  (i.e. xc-gw->cloud-gateway, xc-ms-metadata->microservice metadata, etc.)
APP_NAME=$(echo $MARATHON_APP_ID | cut -d/ -f4)
#-------------------------------------------------------------------------------
# Variables to  define common files path/name
#-------------------------------------------------------------------------------
# The container working directory where components are installed
MAIN_WORKDIR="/opt/xtiva"
# A java detailed profile environment
JAVA_PROFILE_FILE="/etc/profile.d/java.sh"
# The toolbox profile
XTIVA_TOOLBOX_FILE="/etc/profile.d/xtiva-toolbox.sh"
# The currently used java environment path (refers to the toolbox filesystem
# mounted in the /usr/local location
JDK_PATH="/usr/local/usr/java/jdk1.8.0_65"
#-------------------------------------------------------------------------------
# Specific  variables for defined cases
#-------------------------------------------------------------------------------
# This function is used to build a profile file depending on the parameters
# It also applies the profile to the environment
build_profile_file()
{
  PROFILE_FILE=${1}
  PROFILE_BODY=${2}
  PROFILE_HEADER='#!/bin/bash
'
  PROFILE_CONTENT=${PROFILE_HEADER}${PROFILE_BODY}
  touch ${PROFILE_FILE}
  cat << EOT > ${PROFILE_FILE}
${PROFILE_CONTENT}
EOT
  chmod ug+x ${PROFILE_FILE}
  source ${PROFILE_FILE}
}
#
# This function simply applies the predefined java environment variables
java_env_profile()
{
  JAVA_PROFILE_BODY='JDK_PATH="'${JDK_PATH}'"
JAVA_HOME="'${JDK_PATH}'"
PATH=$PATH:$JAVA_HOME/bin
CLASSPATH=$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/tools.jar

export JRE_PATH JAVA_HOME PATH CLASSPATH
'
  build_profile_file ${JAVA_PROFILE_FILE} "${JAVA_PROFILE_BODY}"
}
#
# This function add details to the container profile to correctly use the
# toolbox
xtiva_toolbox_profile()
{
  XTIVA_TOOLBOX_BODY='PATH=$PATH:/usr/local/usr/bin:/usr/local/usr/sbin

export PATH
'
  build_profile_file ${XTIVA_TOOLBOX_FILE} "${XTIVA_TOOLBOX_BODY}"
}
#
# This function defines some pre-start tasks
pre_start()
{
  #
  # Symlinks for system libraries
  local dirs_to_update="include lib lib64 share"
  for dir_to_update in ${dirs_to_update}
  do
    [[ -d /usr/${dir_to_update} ]] && rm -fr /usr/${dir_to_update}
    ln -sfn /usr/local/usr/${dir_to_update} /usr
  done
  #
  # local OS library path file
  cat <<EOT > /etc/ld.so.conf.d/01local.conf
/lib
/lib64
/usr/lib
/usr/lib64
EOT
  #
  # local perl references required by nginx
  cat <<EOT > /etc/ld.so.conf.d/50perl.conf
/usr/lib64/perl5
/usr/lib64/perl5/vendor_perl
EOT
  #
  # additional library path for toolbox
  cat <<EOT > /etc/ld.so.conf.d/99toolbox.conf
/usr/local/lib
/usr/local/lib64
/usr/local/usr/lib
/usr/local/usr/lib64
EOT
  #
  # Symlink required for aws and dcos
  [[ ! -e /usr/bin/python3 ]] && /bin/ln -s /usr/local/bin/python3 /usr/bin/python3
  [[ ! -e /usr/bin/perl ]] && /bin/ln -s /usr/local/bin/perl /usr/bin/perl
  #
  # Apply library path for the container
  /usr/sbin/ldconfig
}
#
# This is the main function
main()
{
  #
  # common phase
  pre_start
  #
  # check if it's a web container otherwise apply common configuration
  CHECK_IS_WEB=$(echo ${APP_NAME} | grep web)
  if [ "${CHECK_IS_WEB}" != "" ]
  then
    mkdir -p /var/log/nginx
    mkdir -p /var/lib/nginx/tmp
  else
    java_env_profile
  fi
  wjava=$(which java)
  $wjava -jar /opt/xtiva/poc-cd.jar
}
#
# Execute all
main
