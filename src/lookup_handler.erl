-module(lookup_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
    {ok, KeyValues, _} = cowboy_req:read_urlencoded_body(Req0),
    {_, Key} = lists:keyfind(<<"data">>, 1, KeyValues),
    Result = gen_server:call(cache_server,{lookup,{Key}}),
    {_,NewResult} = Result,
	Req1 = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>},
        NewResult,
        Req0),
    {ok, Req1, State}.
