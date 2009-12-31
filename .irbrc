require 'irb/completion'

## history:
## wget http://arika.org/archive/irb-history.rb-0.0.0.3
## and put file on
## /usr/lib/ruby/site_ruby/1.8 or $ ruby -rrbconfig -e 'puts Config::CONFIG["sitelibdir"]'
require 'irb-history'

IRB.conf[:AUTO_INDENT] = true

require 'rubygems'

## color:
## sudo gem install -y wirble
require 'wirble'
Wirble.init
Wirble.colorize
