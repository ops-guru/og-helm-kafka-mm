#!/bin/bash -x

set -e
set -u

/opt/kafka/bin/kafka-mirror-maker.sh \
				--num.streams "${KAFKA_MM_NUMSTREAMS:-1}" \
				--whitelist "${KAFKA_MM_WHITELIST:-.*}" \
				--abort.on.send.failure true new.consumer \
				--producer.config "${KAFKA_MM_CFG_ROOT}/producer.properties" \
				--consumer.config "${KAFKA_MM_CFG_ROOT}/consumer.properties"
