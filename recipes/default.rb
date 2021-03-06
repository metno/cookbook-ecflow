#
# Cookbook Name:: ecflow
# Recipe:: default
#
# Copyright (C) 2015 Espen Myrland
#
#

include_recipe "gdebi"
include_recipe "hostname::default"

if Chef::Config[:solo]
    raise 'This recipe requires Chef Search. Chef Solo does not support search.'
end


ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
ENV['ECF_WORKSPACE'] = node['ecflow']['ecf_workspace']
ENV['ECF_BASE'] = node['ecflow']['ecf_base']
ENV['LOGPORT'] = node['ecflow']['log_server']['port'].to_s

# Dont need this:
ENV['ECF_HOME'] = node['ecflow']['ecf_home']

# Install the server
arch = node['ecflow']['arch']
server_url = node['ecflow']['downloads'][node['platform']][arch][node['platform_version']]['ecflow-server'][node['ecflow']['server']['version']]['url']
server_sha256 = node['ecflow']['downloads'][node['platform']][arch][node['platform_version']]['ecflow-server'][node['ecflow']['server']['version']]['sha256']

dest_server = "#{Chef::Config['file_cache_path']}/ecflow-server_#{node['ecflow']['server']['version']}_#{arch}.deb"
remote_file dest_server do
    source server_url
    mode 0644
    checksum server_sha256
    not_if "dpkg -l ecflow-server | grep #{node['ecflow']['server']['version']}"
end

package "ecflow-server" do
    provider Chef::Provider::Package::Gdebi
    source dest_server
    action :install
    not_if "dpkg -l ecflow-server | grep #{node['ecflow']['server']['version']}"
end

# Replace shebang. /bin/sh on ubuntu is not bash
# So scripts give syntax errors
execute "replace shebang" do
    command "sed  -i 's$^#!/bin/sh$$#!/bin/bash$' /usr/bin/ecflow_start.sh"
    not_if "grep '#!/bin/bash' /usr/bin/ecflow_start.sh"
end

execute "replace shebang" do
    command "sed  -i 's$^#!/bin/sh$$#!/bin/bash$' /usr/bin/ecflow_stop.sh"
    not_if "grep '#!/bin/bash' /usr/bin/ecflow_stop.sh"
end

# Install the client
client_url = node['ecflow']['downloads'][node['platform']][arch][node['platform_version']]['ecflow-client'][node['ecflow']['client']['version']]['url']
client_sha256 = node['ecflow']['downloads'][node['platform']][arch][node['platform_version']]['ecflow-client'][node['ecflow']['client']['version']]['sha256']

dest_client = "#{Chef::Config['file_cache_path']}/ecflow_#{node['ecflow']['client']['version']}_#{arch}.deb"
remote_file dest_client do
    source client_url
    mode 0644
    checksum client_sha256
    not_if "dpkg -l ecflow | grep #{node['ecflow']['server']['version']}"
end

package "ecflow-client" do
    provider Chef::Provider::Package::Gdebi
    source dest_client
    action :install
    not_if "dpkg -l ecflow | grep #{node['ecflow']['server']['version']}"
end

# Install the viewer
#TODO: 
#Use version 4.0.1 to avoid the dreadful "no output to be expected when TRYNO is 0!" on requeue.  
#(I cannot find this for Trusty. Must maybe patch source )
view_url = node['ecflow']['downloads'][node['platform']][arch][node['platform_version']]['ecflow-view'][node['ecflow']['view']['version']]['url']
view_sha256 = node['ecflow']['downloads'][node['platform']][arch][node['platform_version']]['ecflow-view'][node['ecflow']['view']['version']]['sha256']

dest_view = "#{Chef::Config['file_cache_path']}/ecflow-view_#{node['ecflow']['client']['version']}_#{arch}.deb"
remote_file dest_view do
    source view_url
    mode 0644
    checksum view_sha256
    not_if "dpkg -l ecflowview | grep #{node['ecflow']['server']['version']}"
end

package "ecflow-view" do
    provider Chef::Provider::Package::Gdebi
    source dest_view
    action :install
    not_if "dpkg -l ecflowview | grep #{node['ecflow']['server']['version']}"
end

# Install the python library
python_url = node['ecflow']['downloads'][node['platform']][arch][node['platform_version']]['ecflow-python'][node['ecflow']['python']['version']]['url']
python_sha256 = node['ecflow']['downloads'][node['platform']][arch][node['platform_version']]['ecflow-python'][node['ecflow']['python']['version']]['sha256']

dest_python = "#{Chef::Config['file_cache_path']}/ecflow-python_#{node['ecflow']['python']['version']}_#{arch}.deb"
remote_file dest_python do
    source python_url
    mode 0644
    checksum python_sha256
    not_if "dpkg -l ecflow-python | grep #{node['ecflow']['server']['version']}"
end

package "ecflow-python" do
    provider Chef::Provider::Package::Gdebi
    source dest_python
    action :install
    not_if "dpkg -l ecflow-python | grep #{node['ecflow']['server']['version']}"
end

execute "create home dir for ecf_base_user if ldap user" do
    command "mkdir -p #{node['ecflow']['ecf_base_user_home']}"
    only_if "getent passwd #{node['ecflow']['ecf_base_user']}"
end

execute "create home dir for ecf daemon user if ldap user" do
    command "mkdir -p #{node['ecflow']['daemon']['home']}"
    only_if "getent passwd #{node['ecflow']['daemon']['user']}"
end

user node['ecflow']['daemon']['user'] do
    supports :manage_home => true
    comment 'ECFLOW daemon user'
    home node['ecflow']['daemon']['home']
    shell '/bin/bash'
    not_if "getent passwd #{node['ecflow']['daemon']['user']}" #LDAP user
end

user node['ecflow']['ecf_base_user'] do
    supports :manage_home => true
    comment 'ECFLOW base user'
    home node['ecflow']['ecf_base_user_home']
    shell '/bin/bash'
    not_if "getent passwd #{node['ecflow']['ecf_base_user']}" #LDAP user
end

directory node['ecflow']['ecf_base_user_home'] do
    owner node['ecflow']['ecf_base_user']
    group node['ecflow']['ecf_base_user']
    mode 0755
    only_if "getent passwd #{node['ecflow']['ecf_base_user']}" # LDAP User
end

directory node['ecflow']['daemon']['home'] do
    owner node['ecflow']['daemon']['user']
    group node['ecflow']['daemon']['user']
    mode 0755
end

directory node['ecflow']['ecf_server_dir'] do
    owner node['ecflow']['daemon']['user']
    group node['ecflow']['daemon']['user']
    mode 0755
end

directory node['ecflow']['ecf_base'] do
    group node['ecflow']['ecf_base_user']
    owner node['ecflow']['daemon']['user']
    mode 0775
    ignore_failure true
end

directory node['ecflow']['ecf_workspace'] do
    owner node['ecflow']['ecf_base_user']
    group node['ecflow']['daemon']['user']
    mode 0775
    action :create
    ignore_failure true
end

# Bug in chef setting mode 2775 in the directory directive 
# above gives weird permissions
# 2: Gives permission denied if mounted
%x( mountpoint -q node['ecflow']['ecf_workspace'])
unless ( $? == 0 ) # If not is mountpoint
    execute 'chmod' do
        command "chmod g+s #{node['ecflow']['ecf_workspace']}"
    end
end

# Setup env
template '/etc/profile.d/ecflow-env.sh' do
    source 'ecflow-env.sh.erb'
    mode 0755
    owner 'root'
    group 'root'
end

# Install init script

template '/etc/init.d/ecflow-server' do
    source 'init.sh.erb'
    mode 0755
    owner 'root'
    group 'root'
    notifies :start, 'service[ecflow-server]', :immediately
end

%w{/usr/bin/ecflow_logsvr.pl /usr/bin/ecflow_start.sh /usr/bin/ecflow_stop.sh }.each do |filename|
    file filename do
        mode '0755'
        owner 'root'
        group 'root'
    end
end

template '/etc/init.d/ecflow-logsvr' do
    source 'ecflow-logsvr.erb'
    owner 'root'
    group 'root'
    mode '0755'
end

service "ecflow-server" do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action [ :enable, :start]
end

service "ecflow-logsvr" do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action [ :enable, :start]
end


# Crontab which copies ecflow checkpoint files from other nodes in environment
# And have it ready if needed.
servers = search(:node, "chef_environment:#{node.chef_environment} AND recipes:ecflow\\:\\:default")
servers.each do |server|
    if server['ecflow']['public_ip_address'] == node['ecflow']['public_ip_address'] then # Skip "myself"
      next
    end
    if node['ecflow']['ecf_environment'] != 'production' then
        next
    end
    cron "copy checkpoint file from #{server['hostname']}" do
        mailto node['ecflow']['daemon']['user']
        user node['ecflow']['daemon']['user']
        command "scp #{server['ecflow']['public_ip_address']}:#{server['ecflow']['ecf_home']}/#{server['hostname']}.#{node['ecflow']['daemon']['port']}.check  #{node['ecflow']['ecf_home']}/. > /dev/null"
        minute '5'
    end
    # In case the newest is corrupt, also copy previous chekpoint file
    cron "copy previous checkpoint file from #{server['hostname']}" do
        mailto node['ecflow']['daemon']['user']
        user node['ecflow']['daemon']['user']
        command "scp #{server['ecflow']['public_ip_address']}:#{server['ecflow']['ecf_home']}/#{server['hostname']}.#{node['ecflow']['daemon']['port']}.check.b  #{node['ecflow']['ecf_home']}/. > /dev/null"
        minute '5'
    end
end


# Install a testsuite as a starting point
include_recipe 'ecflow::install_testsuite' if node['ecflow']['install_testsuite']
