# Run

`jruby -S bundle install`

`jruby -Ilib -Ivendor ./bin/run.rb`

# Usage

```
erl -name client@127.0.0.1
Erlang/OTP 17 [erts-6.3] [source] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false] [dtrace]

Eshell V6.3  (abort with ^G)
(client@127.0.0.1)1> net:ping('jruby@127.0.0.1').
pong
(client@127.0.0.1)2> {server, 'jruby@127.0.0.1'} ! { self(), say_your_pid }.
{<0.38.0>,say_your_pid}
(client@127.0.0.1)3> flush().
Shell got <6210.1.0>
ok
(client@127.0.0.1)4> {server, 'jruby@127.0.0.1'} ! { self(), pid }.
{<0.38.0>,pid}
(client@127.0.0.1)5> flush().
Shell got <6210.1.0>
ok
(client@127.0.0.1)6> {server, 'jruby@127.0.0.1'} ! { self(), plus, 1, 2, 3 }.
{<0.38.0>,plus,1,2,3}
(client@127.0.0.1)7> flush().
Shell got {ok,6}
ok
(client@127.0.0.1)8> {server, 'jruby@127.0.0.1'} ! { self(), mult, 4, 5, 6, 7 }.
{<0.38.0>,mult,4,5,6,7}
(client@127.0.0.1)9> flush().
Shell got {ok,840}
ok
(client@127.0.0.1)10> {server, 'jruby@127.0.0.1'} ! { self(), poo }.
{<0.38.0>,poo}
(client@127.0.0.1)11> flush().
Shell got {error,"Don't know how to poo"}
ok
(client@127.0.0.1)12> {server, 'jruby@127.0.0.1'} ! stop.
stop
(client@127.0.0.1)13>
```
