#
# Cookbook Name:: ecflow
# Recipe:: install_testsuite
#
# Copyright (C) 2015 Espen Myrland
#
#

remote_directory "#{node['ecflow']['ecf_home']}/testsuite" do
    source "testsuite"
    files_backup 0
    files_owner node['ecflow']['ecf_base_user']
    files_group  node['ecflow']['daemon']['user']
    files_mode "0755"
    owner node['ecflow']['ecf_base_user']
    group node['ecflow']['daemon']['user']
    mode "0775"
end

execute "create suite definition" do
    cwd "#{node['ecflow']['ecf_home']}/testsuite"
    user node['ecflow']['ecf_base_user']
    command "python testsuite_def.py"
    # This means you ned to remove the def on the box, to regenerate it ..:
    not_if { File.exist?("#{node['ecflow']['ecf_home']}/testsuite/testsuite.def") } 
end

execute "replace suite" do
    cwd "#{node['ecflow']['ecf_home']}/testsuite"
    user node['ecflow']['ecf_base_user']
    command "ecflow_client  --replace /testsuite testsuite.def"
    not_if "ecflow_client --get_state /testsuite| grep STATE"
end

execute "begin suite" do
    cwd "#{node['ecflow']['ecf_home']}/testsuite"
    user node['ecflow']['ecf_base_user']
    command "ecflow_client  --begin=testsuite"
    not_if "ecflow_client --get_state /testsuite| grep begun"
end
