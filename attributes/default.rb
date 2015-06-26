default['set_fqdn'] = '*'

default['ecflow']['view']['version'] = '4.0.4-1'
default['ecflow']['server']['version'] = '4.0.3-1'
default['ecflow']['client']['version'] = '4.0.3-1'
default['ecflow']['python']['version'] = '4.0.3-1'
default['ecflow']['arch'] = 'amd64'

default['ecflow']['daemon']['port'] = 3141
# ecflow is launched as this user
default['ecflow']['daemon']['user'] = 'ecflow'

# Logfiles and check point files will be written here. 
default['ecflow']['daemon']['home'] = '/home/ecflow'

# Suite definitions and families must be placed here. 
default['ecflow']['ecf_base'] = '/home/metop'
default['ecflow']['ecf_home'] = "#{node['ecflow']['ecf_base']}/ecflow"

# user with write access to the ecflow-tasks.
default['ecflow']['ecf_base_user'] = 'metop'
default['ecflow']['ecf_base_group'] = 'metop'

# Installs a teststuite with a simple 'hello' task
default['ecflow']['install_testsuite'] = true

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
                    }
                }, 
                'ecflow-client' => {
                    '4.0.3-1' => {
                        'url' =>'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow_4.0.3-1_amd64.deb', 
                        'sha256' => '6e0ad82cedad561f88f6fe2044f49a5a5904af0519d9faa82f705c8695364863'
                    }
                }, 
                'ecflow-view' => {
                    '4.0.4-1' => {
                        'url'=> 'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow-view_4.0.4-1_amd64.deb', 
                        'sha256'=>'310614dc3add5e42902996a5172aa7de558f032358a520663363b28be8a2a8e4'
                    }, 
                }, 
                'ecflow-python' => {
                    '4.0.3-1' => {
                        'url'=>'https://software.ecmwf.int/wiki/download/attachments/36536662/ecflow-python_4.0.3-1_amd64.deb',
                        'sha256'=>'24bfb9c53eecdf4a0720b0ef210f7cdb8c3a2581a8f76d6fe778a181f185cca6'
                    }
                }
            }
        }
    }
}
