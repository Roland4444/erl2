%%%-------------------------------------------------------------------
%%% @author roland
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Oct 2018 17:35
%%%-------------------------------------------------------------------
-module(tut15).
-export([start/0, ping/2, pong/0, filename/0, readlines/0]).

ping(0, Pong_PID) ->
  Pong_PID ! finished,
  io:format("ping finished~n", []);

ping(N, Pong_PID) ->
  Pong_PID ! {ping, self()},
  receive
    pong ->
      io:format("Ping received pong~n", [])
  end,
  ping(N - 1, Pong_PID).

pong() ->
  receive
    finished ->
      io:format("Pong finished~n", []);
    {ping, Ping_PID} ->
      io:format("Pong received ping~n", []),
      Ping_PID ! pong,
      pong()
  end.

start() ->
  Pong_PID = spawn(tut15, pong, []),
  spawn(tut15, ping, [3, Pong_PID]).

filename() ->
  Print = ["you"],
  file:write_file("foo.txt",  binary:encode_unsigned(01010101, big)).

get_all_lines(Device) ->
  case io:get_line(Device, "") of
    eof  -> [];
    Line -> Line ++ get_all_lines(Device)
  end.

readlines() ->
  {ok, Device} = file:open("foo.txt", [read]),
  io:format(get_all_lines(Device)).

