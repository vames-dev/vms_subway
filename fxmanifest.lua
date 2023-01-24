fx_version 'adamant'
game 'gta5'
lua54 'yes'

description "vms_subway"
author "vames™️#1400"
version '1.0.0'

ui_page 'ui/ui.html'
files {
    'ui/*.*', 
    'ui/**/*.*'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}