-module(road).
-export([main/1]).
 
main([FileName]) ->
    {ok, Bin} = file:read_file(FileName),
    Map = parse_map(Bin),
    io:format("~p~n",[optimal_path(Map)]),
    erlang:halt(0).

parse_map(Binary) when is_binary(Binary) ->
    parse_map(binary_to_list(Binary));

parse_map(Str) when is_list(Str) ->
   Values = [list_to_integer(X) || X <- string:tokens(Str,"\r\n\t")],
   group_vals(Values,[]).

group_vals([],Acc) ->
    lists:reverse(Acc);

group_vals([A,B,C | Rest], Acc) ->
    group_vals(Rest, [{A,B,C} | Acc]).

shortest_step({A,B,X}, {{DistA,PathA}, {DistB,PathB}}) ->
    OptA1 = {DistA + A, [{a,A}|PathA]},
    OptA2 = {DistB + B + X, [{x,X}, {b,B}|PathB]},
    OptB1 = {DistB + B, [{b,B}|PathB]},
    OptB2 = {DistA + A + X, [{x,X}, {a,A}|PathA]},
    {erlang:min(OptA1, OptA2), erlang:min(OptB1, OptB2)}.

optimal_path(Map) ->
    {A,B} = lists:foldl(fun shortest_step/2, {{0,[]}, {0,[]}}, Map),
    {_Dist,Path} = if hd(element(2,A)) =/= {x,0} -> A;
    hd(element(2,B)) =/= {x,0} -> B
    end,
    lists:reverse(Path).