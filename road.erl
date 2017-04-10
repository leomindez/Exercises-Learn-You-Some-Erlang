-module(road).
-export([main/0,parse_map/1,group_vals/2]).

main() ->
    File = "road.txt",
    {ok, Binary} = file:read_file(File),
    parse_map(Binary).

parse_map(Binary) when is_binary(Binary) ->
    parse_map(binary_to_list(Binary));

parse_map(Str) when is_list(Str) ->
   Values = [list_to_integer(X) || X <- string:tokens(Str,"\r\n\t")],
   group_vals(Values,[]).

group_vals([],Acc) ->
    lists:reverse(Acc);

group_vals([A,B,C | Rest], Acc) ->
    group_vals(Rest, [{A,B,C} | Acc]).
