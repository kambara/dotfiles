require 'irb/completion'
require 'irb/ext/save-history'
require 'pp'
require 'rubygems'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 1000

## color:
## $ sudo gem install -y wirble

require 'wirble'
Wirble.init
Wirble.colorize
