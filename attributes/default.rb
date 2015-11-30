default['set_fqdn'] = '*'

default['ecflow']['view']['version'] = '4.0.8-1'
default['ecflow']['server']['version'] = '4.0.8-1'
default['ecflow']['client']['version'] = '4.0.8-1'
default['ecflow']['python']['version'] = '4.0.8-1'
default['ecflow']['arch'] = 'amd64'

default['ecflow']['daemon']['port'] = 3141
# ecflow is launched as this user
default['ecflow']['daemon']['user'] = 'ecflow'

# Logfiles and check point files will be written here. 
default['ecflow']['daemon']['home'] = '/home/ecflow'

# Here goes the ecf - expanded runnable scripts and output, scripts linked from ecf_base
default['ecflow']['ecf_workspace'] = "#{node['ecflow']['daemon']['home']}/ecf_workspace"
default['ecflow']['ecf_home'] = "#{node['ecflow']['daemon']['home']}/ecflow_server"

# user which owns the task repository. (git ).
default['ecflow']['ecf_base_user'] = 'metop'
default['ecflow']['ecf_base_user_home'] = '/home/metop'
default['ecflow']['ecf_base_group'] = 'metop'

# Suite definitions and scripts are placed here. 
default['ecflow']['ecf_base'] = "#{node['ecflow']['ecf_base_user_home']}/ecf_base"

default['ecflow']['ecf_environment'] = 'test'

# Installs a teststuite with a simple 'hello' task
default['ecflow']['install_testsuite'] = true

default['ecflow']['floating_ip_address'] = nil;

if node['ecflow']['floating_ip_address']
    default['ecflow']['public_ip_address'] = node['ecflow']['floating_ip_address']
elsif node['openstack'] &&  node['openstack']['public_ipv4']
    default['ecflow']['public_ip_address'] = node['openstack']['public_ipv4']
else 
    default['ecflow']['public_ip_address'] = node['ipaddress'] 
end


default['ecflow']['log_server']['port'] = 9316
default['ecflow']['log_server']['host'] = node['ecflow']['public_ip_address']

default['ecflow']['downloads'] =   {
    'ubuntu' => {
        'amd64' => 
        { 
            '14.04' => 
            {
                'ecflow-server' => {
                    '4.0.3-1' => {
                        'url' =>'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow-server_4.0.3-1_amd64.deb', 
                        'sha256' => '05b5f259bf24b9aeb05c092e42f3a7736fbfc1b75cfd716be984f041c4d83aa9'
                    },
                    '4.0.8-1' => {
                        'url' =>'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow-server_4.0.8-1_amd64.deb', 
                        'sha256' => '3b6c0ca2ed21c93b95aed15b330a4a9326f2daa4b64d9cd1424c995c3d86112f'
                    }
                }, 
                'ecflow-client' => {
                    '4.0.3-1' => {
                        'url' =>'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow_4.0.3-1_amd64.deb', 
                        'sha256' => '6e0ad82cedad561f88f6fe2044f49a5a5904af0519d9faa82f705c8695364863'
                    },
                    '4.0.8-1' => {
                        'url' =>'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow_4.0.8-1_amd64.deb', 
                        'sha256' => '0fd6aa12437c8f34e7bddccd4b8aeb57c27755bceb4182101fe9127f2cdab235'
                    }
                }, 
                'ecflow-view' => {
                    '4.0.4-1' => {
                        'url'=> 'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow-view_4.0.4-1_amd64.deb', 
                        'sha256'=>'310614dc3add5e42902996a5172aa7de558f032358a520663363b28be8a2a8e4'
                    }, 
                   '4.0.8-1' => {
                        'url'=> 'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow-view_4.0.8-1_amd64.deb', 
                        'sha256'=>'2f34454325083700bd4d2aac5fc285d1ca061f3f499b28e7d5d1cbc5bee8ff13'
                    }, 
                }, 
                'ecflow-python' => {
                    '4.0.3-1' => {
                        'url'=>'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow-python_4.0.3-1_amd64.deb',
                        'sha256'=>'24bfb9c53eecdf4a0720b0ef210f7cdb8c3a2581a8f76d6fe778a181f185cca6'
                    },
                   '4.0.8-1' => {
                        'url'=>'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow-python_4.0.8-1_amd64.deb',
                        'sha256'=>'7a961d7fb69e3a5105f575ae79d534a9cf9bff8ae9fa3d74fa45524b27e29aa0'
                    }
                }
            }
        }
    }
}
