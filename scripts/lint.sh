#!/bin/bash

helm_root_dir='helm-kafka-mirror-maker'

. scripts/common.sh

function lint_chart() {
  chart_name=$1
  chart_file=$2

  echo -e "==> ${GREEN}Linting $chart_name...${RS}"
  output=`helm lint $chart_file --debug 2> /dev/null`
  if [ $? -ne 0 ]; then
    echo -e "===> ${RED} Linting errors for chart $chart_name ${RS}"
    echo -e "$output" | grep "\\["
    exit 1
  fi
  echo -e "$output" | grep "\\["
}

# Jenkins's working dir is not helm-kafka-mirror-maker, so copy to tmp dir before linting
if [[ $JENKINS_HOME ]]; then
  rm -rf /tmp/${helm_root_dir}
  cp -R . /tmp/${helm_root_dir}
  cd /tmp/${helm_root_dir}
fi

lint_chart og-kafka-mm .

for chart in $(ls -1 .); do
  lint_chart $chart ./$chart
done

echo -e "==> ${GREEN} No linting errors${RS}"
