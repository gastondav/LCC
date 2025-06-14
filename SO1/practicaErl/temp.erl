-module(temp).
-export([wait/1,cronometro/3,init/0]).

wait(Tiempo) -> timer:sleep(Tiempo).

cronometro(Fun, Hasta, Periodo) ->
    if
        (Hasta =< 0) -> Fun;
        true -> Fun(),
                wait(Periodo),
                cronometro(Fun, Hasta - Periodo, Periodo) 
    end.

init() ->
    cronometro(fun () -> io:fwrite("Tick~n") end, 60000, 5000).