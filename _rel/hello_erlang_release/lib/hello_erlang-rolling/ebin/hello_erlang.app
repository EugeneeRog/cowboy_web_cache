{application, 'hello_erlang', [
	{description, ""},
	{vsn, "rolling"},
	{modules, ['add_handler','cache_server','clean_handler','cleaner_timer','hello_erlang_app','hello_erlang_sup','hello_handler','lookup_handler','parser','parser_handler']},
	{registered, [hello_erlang_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {hello_erlang_app, []}},
	{env, []}
]}.