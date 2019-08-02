-module(hello_erlang_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    cache_server:start(),
	Dispatch = cowboy_router:compile([
        {'_', [
            {"/", hello_handler, []},
            {"/add/", add_handler, []},
            {"/result/", lookup_handler, []},
            {"/clean/", clean_handler, []}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080}],
        #{env => #{dispatch => Dispatch}}
    ),
    hello_erlang_sup:start_link().

stop(_State) ->
	ok.
