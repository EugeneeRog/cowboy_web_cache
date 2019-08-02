-module(hello_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
	Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/html">>},
        <<"<form method=\'post\' action=\'/clean/\'><button type='submit' >clean</button></form>
        <form method=\'post\' action=\'/result/\'><input type='text' placeholder='key' name='data' /><button type='submit' >find</button></form>
        <form method=\'post\' action=\'/add/\'><input type='text' placeholder='key' name='data' /><input type='text' placeholder='value' name='value' /><input type='text' placeholder='time' name='time' /><button type='submit' >add</button></form>
        ">>,
        Req0),
    {ok, Req, State}.
