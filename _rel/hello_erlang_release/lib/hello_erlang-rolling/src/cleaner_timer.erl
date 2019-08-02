-module(cleaner_timer).
-export([timers/0,start/0]).
	
start() ->
	spawn(?MODULE, timers, []).

timers() ->
	timer:sleep(10000),
	gen_server:call(cache_server,{cleaning}),
	timers().

