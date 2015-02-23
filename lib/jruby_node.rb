require 'otp_erlang'
require 'pry'

class JrubyNode
  import com.ericsson.otp.erlang

  attr_reader :node, :mbox

  def initialize(node_name = 'jruby', mbox_name = 'server')
    @node = OtpNode.new(node_name)
    @mbox = node.create_mbox(mbox_name)
    puts 'Initialized'
  end

  def run_loop
    puts 'Listening...'
    loop do
      o = mbox.receive
      break if stop?(o)
      erlang_type = o.class.name.split('::').last.sub(/^OtpErlang/, '').downcase
      puts "#{erlang_type} received: #{o}"
      case o
      when OtpErlangAtom
        handle_atom(o)
      when OtpErlangTuple
        handle_tuple(o)
      else
        # do nothing
      end
    end
  end

  def handle_atom(atom)
  end

  def handle_tuple(tuple)
    elements = tuple.elements.to_a
    from = elements.shift
    cmd = elements.shift
    response = case cmd.to_s
    when /^(?:say_your_)?pid$/
      mbox.self
    when 'plus'
      r = elements.reduce(0) { |acc, n| acc + convert_numeric(n) }
      OtpErlangTuple.new([
        OtpErlangAtom.new('ok'),
        OtpErlangLong.new(r)
      ].to_java(OtpErlangObject))
    when 'mult'
      r = elements.reduce(1) { |acc, n| acc * convert_numeric(n) }
      OtpErlangTuple.new([
        OtpErlangAtom.new('ok'),
        OtpErlangLong.new(r)
      ].to_java(OtpErlangObject))
    else
      OtpErlangTuple.new([
        OtpErlangAtom.new('error'),
        OtpErlangList.new("Don't know how to #{cmd.to_s}")
      ].to_java(OtpErlangObject))
    end
    mbox.send(from, response)
  rescue StandardError => error
    binding.pry
  end

  def convert_numeric(erl_numeric)
    if erl_numeric.respond_to?(:long_value)
      erl_numeric.long_value
    elsif erl_numeric.respond_to?(:float_value)
      erl_numeric.float_value
    else
      0
    end
  end

  def stop? obj
    obj.to_s =~ /(?:stop|quit|halt)/
  end
end
