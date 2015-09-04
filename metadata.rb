name             'ecflow'
maintainer       'Espen Myrland'
maintainer_email 'it-geo-tf@met.no'
license          'GPL v2'
description      'Installs/Configures ecflow'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.19'

%w{ ubuntu }.each do |os|
  supports os
end

depends 'apt',           '~> 2.6' 
depends 'gdebi',         '~> 1.1.0'
depends 'hostname',      '~> 0.3'
