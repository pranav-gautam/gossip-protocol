-module(pg_push_sum).
-export([full_net_spawn/1, line_spawn/1,d2d_spawn/1,d3d_spawn/1,full_net_initialization/2,line_initialization/2,d2d_initialization/2,d3d_initialization/2,
    find_index/2,initiate_full_net/1,full_net_begin/2,initiate_line/1,line_begin/2,
    initiate_2d/1,d2d_begin/2,initiate_3d/1,d3d_begin/2]).
-import(math,[pow/2]).

full_net_spawn(K) ->
  spawn(fun() -> fullnet_looping(K,1,0) end).   

line_spawn(K) ->
  spawn(fun() -> line_looping(K,1,0) end).

d2d_spawn(K) ->
  spawn(fun() -> d2d_looping(K,1,0) end).

d3d_spawn(K) ->
  spawn(fun() -> d3d_looping(K,1,0) end).

fullnet_looping(Sum,Weights,Num) ->
  receive
    {USum,UWeights,initiate,List,Except,Starter} ->
      Neighbour = lists:nth(rand:uniform(length(List -- [Starter])), List -- [Starter] ),
    %     erlang:display(List),
    %   erlang:display(Starter),
        Storage = pow(10,-10),
        Ns = (Sum+USum)/2,
        Ws = (Weights+UWeights)/2,
        Ratio1 = Sum/Weights,
        Ratio2 = Ns/Ws,
        % erlang:display(Ratio2-Ratio1),
      if 
        Num == 3 -> New=0,erlang:display(suspend),
        Starter ! {Except};
        Ratio2-Ratio1 < Storage -> New = Num+1,
            Neighs = (Sum+USum)/2,
            Neighw = (Weights+UWeights)/2,
            Neighbour ! {Neighs,Neighw,initiate,List, Except, Neighbour};
        true -> New = 0,
            Neighs = (Sum+USum)/2,
            Neighw = (Weights+UWeights)/2,
            Neighbour ! {Neighs,Neighw,initiate,List, Except, Neighbour}
     end,
    % erlang:display(New),   
    fullnet_looping((Sum+USum)/2,(Weights+UWeights)/2,New);

    {Except} ->
        Except ! {10,self()}

  end.

line_looping(Sum,Weights,Num) ->
  receive
    {USum,UWeights,initiate,List,Except,Starter} ->

      Pos = find_index(Starter,List),
      Lengths = length(List),
      if 
        Pos == 1 -> Neighbour = lists:nth(2, List);
        Pos == Lengths -> Neighbour = lists:nth(Lengths-1, List);
        true -> Neighbour = lists:nth(rand:uniform(2), [lists:nth(Pos-1, List),lists:nth(Pos+1, List)])
      end,
  
    %     erlang:display(List),
    %   erlang:display(Starter),
    %   erlang:display(Neighbour),

        Storage = pow(10,-10),
        Ns = (Sum+USum)/2,
        Ws = (Weights+UWeights)/2,
        Ratio1 = Sum/Weights,
        Ratio2 = Ns/Ws,
        % erlang:display(Ratio2-Ratio1),
      if 
        Num == 3 -> New=0,erlang:display(suspend),
        Starter ! {Except};
        Ratio2-Ratio1 < Storage -> New = Num+1,
            Neighs = (Sum+USum)/2,
            Neighw = (Weights+UWeights)/2,
            Neighbour ! {Neighs,Neighw,initiate,List, Except, Neighbour};
        true -> New = 0,
            Neighs = (Sum+USum)/2,
            Neighw = (Weights+UWeights)/2,
            Neighbour ! {Neighs,Neighw,initiate,List, Except, Neighbour}
     end,
    % erlang:display(New),
    line_looping((Sum+USum)/2,(Weights+UWeights)/2,New);
    {Except} ->
        Except ! {10,self()}

  end.

d2d_looping(Sum,Weights,Num) ->
  receive
    {USum,UWeights,initiate,List,Except,Starter} ->

      Pos = find_index(Starter,List),
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
  
    %     erlang:display(List),
    %   erlang:display(Starter),
    %   erlang:display(Neighbour),

        Storage = pow(10,-10),
        Ns = (Sum+USum)/2,
        Ws = (Weights+UWeights)/2,
        Ratio1 = Sum/Weights,
        Ratio2 = Ns/Ws,
        % erlang:display(Ratio2-Ratio1),

      if 
        Num == 3 -> New=0,erlang:display(suspend),
        Starter ! {Except};
        Ratio2-Ratio1 < Storage -> New = Num+1,
            Neighs = (Sum+USum)/2,
            Neighw = (Weights+UWeights)/2,
            Neighbour ! {Neighs,Neighw,initiate,List, Except, Neighbour};
        true -> New = 0,
            Neighs = (Sum+USum)/2,
            Neighw = (Weights+UWeights)/2,
            Neighbour ! {Neighs,Neighw,initiate,List, Except, Neighbour}
     end,
    % erlang:display(New),
  
    d2d_looping((Sum+USum)/2,(Weights+UWeights)/2,New);

    {Except} ->

        Except ! {10,self()}

  end.


d3d_looping(Sum,Weights,Num) ->
  receive
    {USum,UWeights,initiate,List,Except,Starter} ->

      Pos = find_index(Starter,List),
    %   erlang:display(Pos),
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
                    Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos-1, List),lists:nth(Pos-4, List),lists:nth(Pos+1, List),lists:nth(rand:uniform(Lengths),List)])
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

        Pos rem 4 == 0 -> Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos-1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List),lists:nth(rand:uniform(Lengths),List)]);
        Pos rem 4 == 1 -> Neighbour = lists:nth(rand:uniform(4), [lists:nth(Pos+1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List),lists:nth(rand:uniform(Lengths),List)]);
        true -> Neighbour = lists:nth(rand:uniform(5), [lists:nth(Pos+1, List),lists:nth(Pos-4, List),lists:nth(Pos+4, List),lists:nth(Pos-1, List),lists:nth(rand:uniform(Lengths),List)])
      end,
  
    %     erlang:display(List),
    %   erlang:display(Starter),
    %   erlang:display(Neighbour),

        Storage = pow(10,-10),
        Ns = (Sum+USum)/2,
        Ws = (Weights+UWeights)/2,
        Ratio1 = Sum/Weights,
        Ratio2 = Ns/Ws,
        % erlang:display(Ratio2-Ratio1),

      if 
        Num == 3 -> New=0,erlang:display(suspend),
        Starter ! {Except};
        Ratio2-Ratio1 < Storage -> New = Num+1,
            Neighs = (Sum+USum)/2,
            Neighw = (Weights+UWeights)/2,
            Neighbour ! {Neighs,Neighw,initiate,List, Except, Neighbour};
        true -> New = 0,
            Neighs = (Sum+USum)/2,
            Neighw = (Weights+UWeights)/2,
            Neighbour ! {Neighs,Neighw,initiate,List, Except, Neighbour}
     end,
    % erlang:display(New),
  
    d3d_looping((Sum+USum)/2,(Weights+UWeights)/2,New);

    {Except} ->

        Except ! {10,self()}

  end.

find_index(Item, List) -> find_index(Item, List, 1).

find_index(_, [], _)  -> not_found;
find_index(Item, [Item|_], Index) -> Index;
find_index(Item, [_|Tl], Index) -> find_index(Item, Tl, Index+1).

full_net_initialization(0,Max)-> Max;
full_net_initialization(Cn,Max)->
    full_net_initialization(Cn-1,Max++[full_net_spawn(Cn)]).

line_initialization(0,Max)-> Max;
line_initialization(Cn,Max)->
    line_initialization(Cn-1,Max++[line_spawn(Cn)]).

d2d_initialization(0,Max)-> Max;
d2d_initialization(Cn,Max)->
    d2d_initialization(Cn-1,Max++[d2d_spawn(Cn)]).

d3d_initialization(0,Max)-> Max;
d3d_initialization(Cn,Max)->
    d3d_initialization(Cn-1,Max++[d3d_spawn(Cn)]).

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

    Starter ! {1,1,initiate, List, self(),Starter},
    receive
        {10, From} -> 
        erlang:display(From),
        Len = length(List--[From]),
        if Len==1 -> erlang:display(completed);
        
        true -> 
        full_net_begin(List -- [From],lists:nth(1, List--[From]))
        end
    end.

line_begin(List,Starter) ->

    Starter ! {1,1,initiate, List, self(),Starter},

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

    Starter ! {1,1,initiate, List, self(),Starter},

    receive
        {10, From} -> 
        erlang:display(From),
        Len = length(List--[From]),
        if Len==1 -> erlang:display(completed);
        
        true -> 
        d2d_begin(List -- [From],lists:nth(1, List--[From]))
        end
    end.

d3d_begin(List,Starter) ->

    Starter ! {1,1,initiate, List, self(),Starter},

    receive
        {10, From} -> 
        erlang:display(From),
        Len = length(List--[From]),
        if Len==1 -> erlang:display(completed);
        
        true -> 
        d3d_begin(List -- [From],lists:nth(1, List--[From]))
        end
    end.