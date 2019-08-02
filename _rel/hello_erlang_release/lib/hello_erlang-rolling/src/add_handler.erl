-module(add_handler).
-behavior(cowboy_handler).

-export([init/2]).
init(Req0, State) ->
    {ok, KeyValues, _} = cowboy_req:read_urlencoded_body(Req0),
    {_, Key} = lists:keyfind(<<"data">>, 1, KeyValues),
    {_, Value} = lists:keyfind(<<"value">>, 1, KeyValues),
    {_, Time} = lists:keyfind(<<"time">>, 1, KeyValues),
    TimeInMilliseconds = list_to_integer(binary_to_list(Time)),
    gen_server:call(cache_server,{insert,{Key,Value,TimeInMilliseconds}}),
	Req1 = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/html">>},
        <<"Added">>,
        Req0),
    {ok, Req1, State}.
