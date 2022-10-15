-module(pg_gossip).
-export([full_net_spawn/0, line_spawn/0,d2d_spawn/0,d3d_spawn/0,full_net_initialization/2,line_initialization/2,d2d_initialization/2,d3d_initialization/2,
    find_index/2,initiate_full_net/1,full_net_begin/2,initiate_line/1,line_begin/2,
    initiate_2d/1,d2d_begin/2,initiate_3d/1,d3d_begin/2]).

full_net_spawn() ->
  
  spawn(fun() -> fullnet_looping(0) end).

line_spawn() ->
    spawn(fun() -> line_looping(0) end).

d2d_spawn() ->
    spawn(fun() -> d2d_looping(0) end).

d3d_spawn() ->
    spawn(fun() -> d3d_looping(0) end).

fullnet_looping(Num) ->
  receive
    {initiate,List,Except,Starter} ->
      Neighbour = lists:nth(rand:uniform(length(List -- [Starter])), List -- [Starter] ),
    %     erlang:display(List),
    %   erlang:display(Starter),
    %   erlang:display(Num+1),
    %   erlang:display(qqqqqqq),
      Starter ! {Num+1,Except},
      if 
        Num+1 == 10 -> erlang:display(suspend);
        true -> Neighbour ! {initiate,List, Except, Neighbour}
    end,
      fullnet_looping(Num + 1);
    {10,Except} -> 
             Except ! {10,self()},
             fullnet_looping(Num);
    {Num,Except} -> 

        fullnet_looping(Num)
  end.


line_looping(Num) ->
  receive
    {initiate,List,Except,Starter} ->
      Pos = find_index(Starter,List),
      Lengths = length(List),
      if 
        Pos == 1 -> Neighbour = lists:nth(2, List);
        Pos == Lengths -> Neighbour = lists:nth(Lengths-1, List);
        true -> Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(Pos+1, List)])
      end,
    %   erlang:display(List),
    %   erlang:display(Starter),
    %   erlang:display(Num+1),
    %   erlang:display(qqqqqqq),
      Starter ! {Num+1,Except},
      if 
        Num+1 == 10 -> erlang:display(suspend);
        true -> Neighbour ! {initiate,List, Except, Neighbour}
      end,
      line_looping(Num + 1);
    {10,Except} -> 
             Except ! {10,self()},
             line_looping(Num);
    {Num,Except} -> 
        line_looping(Num)
  end.


d2d_looping(Num) ->
  receive
    {initiate,List,Except,Starter} ->
      Pos = find_index(Starter,List),
    %   erlang:display(Pos),
      Lengths = length(List),
      if 
        Pos == Lengths -> 
            if 
                Pos-4=<0 ->
                    Neighbour = lists:nth(rand:uniform(1), [lists:nth(Pos-1, List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(Pos-4, List)])
            end;
        Pos == 1 -> 
            if 
                Pos+4>Lengths -> 
                    Neighbour = lists:nth(rand:uniform(1), [lists:nth(Pos+1, List)]);
                true -> 
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos+1, List),lists:nth(Pos+4, List)])
            end;
        Pos == 2 -> 
            if 
                Pos+4>Lengths ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(Pos+1, List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos+1, List),lists:nth(Pos+4, List)])
            end;

        Pos == 3 -> 
            if 
             Pos+4>Lengths ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(Pos+1, List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos+1, List),lists:nth(Pos+4, List)])
            end;

        Pos == 4 ->  
            if
                Pos+4>Lengths -> 
                    Neighbour = lists:nth(rand:uniform(1), [lists:nth(Pos-1, List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(Pos+4, List)])
            end;

        Pos == Lengths-1 -> 
            if 
                Pos-4=<0 ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(Pos+1, List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos-4, List),lists:nth(Pos+1, List)])
            end;

        Pos == Lengths-2 -> 
            if
                Pos-4=<0 ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(Pos+1, List)]);
                true->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos-4, List),lists:nth(Pos+1, List)])
            end;

        Pos == Lengths-3 -> 
            if
                Pos-4=<0 ->
                    Neighbour = lists:nth(rand:uniform(1), [lists:nth(Pos+1, List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos+1, List),lists:nth(Pos-4, List)])
            end;

        Pos rem 4 == 0 ->
                Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List)]);
        Pos rem 4 == 1 -> Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos+1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List)]);
        true -> Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos+1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List),lists:nth(Pos-1, List)])
      end,
    %   erlang:display(List),
    %   erlang:display(Starter),
      
    %   erlang:display(Neighbour),

    %   erlang:display(Num+1),
    %   erlang:display(qqqqqqq),
      Starter ! {Num+1,Except},
      if 
        Num+1 == 10 -> erlang:display(suspend);
        true -> Neighbour ! {initiate,List, Except, Neighbour}
      end,
                    
      d2d_looping(Num + 1);
    {10,Except} -> 
             Except ! {10,self()},
             d2d_looping(Num);
    {Num,Except} -> 

        d2d_looping(Num)
  end.

d3d_looping(Num) ->
  receive
    {initiate,List,Except,Starter} ->
      Pos = find_index(Starter,List),
    
      Lengths = length(List),
      if 
        Pos == Lengths -> 
            if 
                Pos-4=<0 ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(rand:uniform(Lengths),List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos-4, List),lists:nth(rand:uniform(Lengths),List)])
            end;
        Pos == 1 -> 
            if 
                Pos+4>Lengths -> 
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)]);
                true -> 
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos+1, List),lists:nth(Pos+4, List),lists:nth(rand:uniform(Lengths),List)])
            end;
        Pos == 2 -> 
            if 
                Pos+4>Lengths ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos-1, List),lists:nth(Pos+1, List),lists:nth(Pos+4, List),lists:nth(rand:uniform(Lengths),List)])
            end;

        Pos == 3 -> 
            if 
             Pos+4>Lengths ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos-1, List),lists:nth(Pos+1, List),lists:nth(Pos+4, List),lists:nth(rand:uniform(Lengths),List)])
            end;

        Pos == 4 ->  
            if
                Pos+4>Lengths -> 
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(rand:uniform(Lengths),List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos+4, List),lists:nth(rand:uniform(Lengths),List)])
            end;



        Pos == Lengths-1 -> 
            if 
                Pos-4=<0 ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos-1, List),lists:nth(Pos-4,List),lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)])
            end;

        Pos == Lengths-2 -> 
            if
                Pos-4=<0 ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos-1, List),lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)]);
                true->
                    Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos-1, List),lists:nth(Pos-4, List),lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)])
            end;

        Pos == Lengths-3 -> 
            if
                Pos-4=<0 ->
                    Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)]);
                true ->
                    Neighbour = lists:nth(rand:uniform(3), [lists:nth(Pos+1, List),lists:nth(Pos-4, List),lists:nth(rand:uniform(Lengths),List)])
            end;

        Pos rem 4 == 0 ->
                Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos-1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List),lists:nth(rand:uniform(Lengths),List)]);
        Pos rem 4 == 1 -> Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos+1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List),lists:nth(rand:uniform(Lengths),List)]);
        true -> Neighbour = lists:nth(rand:uniform(5), [lists:nth(Pos+1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List),lists:nth(Pos-1, List),lists:nth(rand:uniform(Lengths),List)])
      end,
    %   erlang:display(List),
    %   erlang:display(Starter),
      
    %   erlang:display(Neighbour),

    %   erlang:display(Num+1),
    %   erlang:display(qqqqqqq),
      Starter ! {Num+1,Except},
      if 
        Num+1 == 10 -> erlang:display(suspend);
        true -> Neighbour ! {initiate,List, Except, Neighbour}
      end,
              

      
      d3d_looping(Num + 1);
    {10,Except} -> 
             Except ! {10,self()},
             d3d_looping(Num);
    {Num,Except} ->

        d3d_looping(Num)
  end.


find_index(Item, List) -> find_index(Item, List, 1).

find_index(_, [], _)  -> not_found;
find_index(Item, [Item|_], Index) -> Index;
find_index(Item, [_|Tl], Index) -> find_index(Item, Tl, Index+1).


full_net_initialization(0,Max)-> Max;
full_net_initialization(Cn,Max)->
    full_net_initialization(Cn-1,Max++[full_net_spawn()]).

line_initialization(0,Max)-> Max;
line_initialization(Cn,Max)->
    line_initialization(Cn-1,Max++[line_spawn()]).

d2d_initialization(0,Max)-> Max;
d2d_initialization(Cn,Max)->
    d2d_initialization(Cn-1,Max++[d2d_spawn()]).

d3d_initialization(0,Max)-> Max;
d3d_initialization(Cn,Max)->
    d3d_initialization(Cn-1,Max++[d3d_spawn()]).

initiate_full_net(Count) ->
    List = full_net_initialization(Count,[]),
    Starter = lists:nth(1, List),
    full_net_begin(List,Starter).

initiate_line(Count) ->
    List = line_initialization(Count,[]),
    Starter = lists:nth(1, List),
    line_begin(List,Starter).

initiate_2d(Count) ->
    List = d2d_initialization(Count,[]),
    Starter = lists:nth(1, List),
    d2d_begin(List,Starter).

initiate_3d(Count) ->
    List = d3d_initialization(Count,[]),
    Starter = lists:nth(1, List),
    d3d_begin(List,Starter).

full_net_begin(List,Starter) ->
    Starter ! {initiate, List, self(),Starter},
    receive
        {10, From} -> 
        erlang:display(From),
        Len = length(List--[From]),
        if Len==1 -> erlang:display(completed);
        true -> 
        full_net_begin(List-- [From],lists:nth(1, List--[From]))
        end
    end.

line_begin(List,Starter) ->
    Starter ! {initiate,List, self(),Starter},
    receive
        {10, From} -> 
        erlang:display(From),
        Len = length(List--[From]),
        if Len==1 -> erlang:display(completed);
        true -> 
        line_begin(List -- [From],lists:nth(1, List--[From]))
        end
    end.

d2d_begin(List,Starter) ->

    Starter ! {initiate,List, self(),Starter},
    receive
        {10, From} -> 
        erlang:display(From),
        Len = length(List--[From]),
        if Len==1 -> erlang:display(done);
        true -> 
        d2d_begin(List -- [From],lists:nth(1, List--[From]))
        end
    end.

d3d_begin(List,Starter) ->

    Starter ! {initiate, List, self(),Starter},

    receive
        {10, From} -> 
        erlang:display(From),
        Len = length(List--[From]),
        if Len==1 -> erlang:display(done);
        true -> 
        d3d_begin(List -- [From],lists:nth(1, List--[From]))
        end
    end.