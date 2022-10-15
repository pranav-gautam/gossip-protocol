-module(pg_time). 
-import(pg_gossip,[]).
-import(pg_push_sum,[]).
-export([calculate_time/0]).

calculate_time() ->
Start = erlang:monotonic_time(1000),
pg_push_sum:initiate_3d(1000),
End = erlang:monotonic_time(1000),
Runtime = End-Start,

% erlang:display(Runtime),
io:format("Runtime: ~B milliseconds~n",[Runtime]),
erlang:halt().