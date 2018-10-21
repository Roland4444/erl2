-module(hello).

-export([start/0, say_something/2, hello_world/0, test/0, p/0, readlines/0]).
hello_world() -> io:fwrite("hello, world\n").

say_something(What, 0) ->
  done;
say_something(What, Times) ->
  io:format("~p~n", [What]),
  say_something(What, Times - 1).

start() ->
  Pid =spawn(hello, p, []),
  Pid2 =spawn(hello, p, []),
  Pid ! {Pid2, readlines()} ,

  timer:sleep(5000).

p() ->
  receive
    {Pid, Msg} when is_pid(Pid) ->
      io:format("Hello from proc: ~p, mesg: ~p~n", [Pid, Msg]),
      Pid ! Msg,
      p();
    stop ->
      ok;
    _ ->
      io:format("Unknown type of message~n", []),
      p()
  end.




test() ->
  say_something("hello", 100).

readlines() ->
  {ok, Device} = file:open("foo.txt", [read]),
  io:format(get_all_lines(Device)).

get_all_lines(Device) ->
  case io:get_line(Device, "") of
    eof  -> [];
    Line -> Line ++ get_all_lines(Device)
  end.