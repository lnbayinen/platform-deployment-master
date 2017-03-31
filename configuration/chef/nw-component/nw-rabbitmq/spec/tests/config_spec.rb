require_relative '../spec_helper.rb'

describe 'nw-rabbitmq::config' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
      node.normal['nw-rabbitmq']['service_names'] = %w(rabbitmq-server)
      node.normal['nw-rabbitmq']['amqp_port'] = 5672
      node.normal['nw-rabbitmq']['amqps_port'] = 5671
      node.normal['nw-rabbitmq']['mgmt_port'] = 15_672
      node.normal['nw-rabbitmq']['cacertfile'] = '/foo/bar.pem'
      node.normal['nw-rabbitmq']['certfile'] = '/foo/baz.pem'
      node.normal['nw-rabbitmq']['keyfile'] = '/foo/quux.pem'
      node.normal['nw-rabbitmq']['tls_versions'] = %w(tlsv1.2)
      node.normal['nw-rabbitmq']['ciphers'] = [
        '{rsa, aes256_cbc, sha256}'
      ]
      node.normal['nw-rabbitmq']['accounts'] = [{
        'name' => 'rabbitmq',
        'uid' => 514
      }]
    end.converge(described_recipe)
  end

  conf_file = '/etc/rabbitmq/rabbitmq.config'
  service_name = 'rabbitmq-server'
  service_resource = "service[#{service_name}]"
  template_properties = {
    owner: 'rabbitmq',
    group: 'rabbitmq',
    mode: 0o440
  }
  ## Desired template output
  config = <<-EOF
%%%%%%
%% NOTICE
%%
%% This file is managed by automated processes, and contains no user
%% serviceable parts.
%%
%% Do not modify!
%%%%%%

[
  {rabbit, [
    {auth_mechanisms, ['PLAIN', 'EXTERNAL']},
    %% Unrestrict the guest account
    {loopback_users, []},
    {tcp_listeners, [5672]},
    {ssl_listeners, [5671]},
    {ssl_cert_login_from,  common_name},
    {ssl_options, [
      {cacertfile,           "/foo/bar.pem"},
      {certfile,             "/foo/baz.pem"},
      {keyfile,              "/foo/quux.pem"},
      {verify,               verify_peer},
      {fail_if_no_peer_cert, true},
      {ciphers,              [
        {rsa, aes256_cbc, sha256}
      ]},
      %% Restrict available versions of SSL/TLS for security
      {versions, ['tlsv1.2']}
    ]}
  ]},
  {rabbitmq_management, [
    {listener, [
      {ssl, true},
      {ssl_opts, [
        {cacertfile, "/foo/bar.pem"},
        {certfile,   "/foo/baz.pem"},
        {keyfile,    "/foo/quux.pem"}
      ]},
      {port, 15672}
    ]}
  ]},
  %% Configures TLS use for any AMQP clients within RabbitMQ,
  %% e.g. fedration or shovels.
  {amqp_client, [
    {ssl_options, [
      {cacertfile,           "/foo/bar.pem"},
      {certfile,             "/foo/baz.pem"},
      {keyfile,              "/foo/quux.pem"},
      {verify,               verify_peer},
      {fail_if_no_peer_cert, true},
      {ciphers,              [
        {rsa, aes256_cbc, sha256}
      ]},
      %% Restrict available versions of SSL/TLS for security
      {versions, ['tlsv1.2']}
    ]}
  ]},
  %% Restrict available versions of SSL/TLS for security
  {ssl, [
    {versions, ['tlsv1.2']}
  ]}

].
  EOF

  it 'sets proper ownership and permissions on the configuration file' do
    expect(chef_run).to create_template(conf_file).with(template_properties)
  end

  it 'notifies the RabbitMQ service to restart on template change' do
    stub_service = chef_run.service(service_name)
    expect(stub_service).to do_nothing

    template = chef_run.template(conf_file)
    expect(template).to notify(service_resource).to(:restart).immediately
  end

  it 'deploys the RabbitMQ configuration file with expected content' do
    expect(chef_run).to render_file(conf_file).with_content(config)
  end
end
