#!/usr/bin/env jruby

require 'jruby_node'

node = JrubyNode.new('jruby@127.0.0.1')
node.run_loop
