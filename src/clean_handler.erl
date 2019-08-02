-module(clean_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
    gen_server:call(cache_server,{cleaning}),
	Req1 = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>},
        <<"ok">>,
        Req0),
    {ok, Req1, State}.
