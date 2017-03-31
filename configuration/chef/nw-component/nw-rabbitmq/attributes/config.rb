# AMQP listener (plain text)
default['nw-rabbitmq']['ampq_port'] = nil
# AMQPS listener (TLS)
default['nw-rabbitmq']['ampqs_port'] = nil
# HTTP management/REST API
default['nw-rabbitmq']['mgmt_port'] = nil
# TLS certificate paths
default['nw-rabbitmq']['cacertfile'] = nil
default['nw-rabbitmq']['certfile'] = nil
default['nw-rabbitmq']['keyfile'] = nil
# Versions of SSL/TLS that RabbitMQ is permitted to use
# Should strings in the form: {rsa, aes256_cbc, sha256}
default['nw-rabbitmq']['tls_versions'] = []
# Permitted TLS ciphers
default['nw-rabbitmq']['ciphers'] = []
