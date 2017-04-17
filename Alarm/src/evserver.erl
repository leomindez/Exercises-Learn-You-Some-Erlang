-module(evserver).
-export([init/0]).

-record(state, {events,clients}).
-record(event, {name="",description="",pid,timeout={{1970,1,1},{0,0,0}}}).


init() ->
    loop(#state{events = orddict:new(),clients = orddict:new()}).

loop(S = #state{}) -> 
    receive 
        {Pid, MsgRef, {subscribe, Client}} ->
            Ref = erlang:monitor(process,Client),
            NewClients = orddict:store(Ref, Client, S#state.clients),
            Pid ! {MsgRef, ok},
            loop(S#state{clients = NewClients});
        
    end.

valid_datetime({Date,Time}) ->
    try
        calendar:valid_date(Date) andalso valid_time(Time)
    catch
        error:function_clause -> false
    end;

valid_datetime() ->
    false.

valid_time({H,M,S}) -> valid_time(H,M,S).

valid_time(H,M,S) when H >= 0, H < 24, 
                       M >= 0, M < 60,
                       S >= 0, S < 60 -> true;
                       
valid_time(_,_,_) -> false.