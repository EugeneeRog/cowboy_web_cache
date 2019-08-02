-module(cache_server).
-export([start/0]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).
-behaviour (gen_server).

start() -> 
	gen_server:start_link({local, ?MODULE},?MODULE,[],[]),
	spawn(cleaner_timer,start,[]).

init([]) ->
  ets:new(table, [public, named_table,ordered_set]),
  {ok, none}.

handle_call({insert,{Key,Value,Time}}, _From,_State) -> 
	insert(Key,Value,Time),
	{reply,{ok,normal},_State};
handle_call({lookup,{Key}}, _From,_State) -> 
		Res = lookup(Key),
		{reply,{ok,Res},_State};
handle_call({cleaning}, _From,_State) -> 
		delete_obsolete(table),
		{reply,{ok,clear},_State}.



 handle_cast(_,_) -> {ok}.

 terminate(shutdown,_State) -> {ok}.




insert(Key,Value,Time) ->
  	ets:insert(table, {Key,Value,time_calculate(Time)}).


time_calculate(Time) -> 
	X = calendar:local_time(),
	calendar:datetime_to_gregorian_seconds(X) + Time.

lookup(Key) ->
	Item = ets:lookup(table,Key),
	Time = time_calculate(0),
	lookup(Time,Item).
lookup(_,[]) -> <<"Empty">>;
lookup(Time,Item) ->
	[Elem|_] = Item,
	{Key,ItemValue,ItemTime} = Elem,
	if
		ItemTime > Time -> ItemValue;
		ItemTime < Time -> 
			ets:delete(table,Key),
			<<"Was deleted">>;
		ItemTime == Time -> 
			ets:delete(table,Key),
			<<"Was deleted">>
	end.

delete_obsolete(TableName) -> 
	Time = time_calculate(0),
	delete_obsolete(TableName,ets:first(TableName),Time,[]).
delete_obsolete(TableName,'$end_of_table',_,Acc) -> delete_tokens(Acc,TableName);
delete_obsolete(TableName,Token,Time,Acc) ->
	Elem = ets:lookup(TableName,Token),
	[X|_] = Elem,
	{_,_,ItemTime} = X,
	if
		ItemTime > Time -> delete_obsolete(TableName,ets:next(TableName,Token),Time,Acc);
		ItemTime < Time -> delete_obsolete(TableName,ets:next(TableName,Token),Time,[Token|Acc]);
		ItemTime == Time -> delete_obsolete(TableName,ets:next(TableName,Token),Time,[Token|Acc])
	end.

delete_tokens([],_) -> <<"deleted old tokens in ETS">>;
delete_tokens([Head|Tail],TableName) ->
	ets:delete(TableName,Head),
	delete_tokens(Tail,TableName). 