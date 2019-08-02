-module(parser).
-export([parser/1]).

stack_taker(Json) -> stack_taker(Json,[]).
stack_taker(<<Element:1/binary,Rest/binary>>,Stack) -> 
	if
		Element == <<" ">> -> stack_taker(Rest,Stack);
	 	Element == <<"[">> -> invest_accumulater(Rest,Rest,Stack,[]);
	 	Element == <<":">> -> stack_taker(Rest,[Element|Stack]);
	 	Element == <<"'">> -> accumulater(Rest,[],Stack);
	 	Element == <<"">> -> stack_taker(Rest,Stack);
	 	true -> stack_taker(Rest,Stack)
	 end;
stack_taker(<<>>,Stack) -> lists:reverse(Stack).

invest_accumulater(<<Element,_>>,MainRest,Stack,_) when Element == <<":">> -> 
	invest_accumulater_prop(MainRest,[],Stack);
invest_accumulater(<<"]",Rest/binary>>,_,Stack,Result) -> 
	X = list_to_binary(lists:reverse(Result)),
	stack_taker(Rest,[[X]|Stack]);
invest_accumulater(<<Element,Rest/binary>>,MainRest,Stack,Result) -> 
	invest_accumulater(Rest,MainRest,Stack,[Element|Result]).

invest_accumulater_prop(<<Element:1/binary,Rest/binary>>,Result,Stack) -> 
	if
		Element == <<"]">> -> 
		X = parser(list_to_binary(lists:reverse(Result))),
		stack_taker(Rest,[X|Stack]);
		true -> invest_accumulater_prop(Rest,[Element|Result],Stack)
	end.

accumulater(<<"'",Rest/binary>>,Buff,Stack) -> 
	X = list_to_binary(lists:reverse(Buff)),
	stack_taker(Rest,[binary_to_list(X)|Stack]);
accumulater(<<Element:1/binary,Rest/binary>>,Buff,Stack) -> accumulater(Rest,[Element|Buff],Stack).

parser(Json) -> parser(stack_taker(Json),[]).
parser([Key,<<":">>,Value|Rest],Result) -> 
	parser(Rest,[{Key,Value}|Result]);
parser([],Result) -> lists:reverse(Result).
