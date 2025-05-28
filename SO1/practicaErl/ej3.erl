-module(ej3).
-export([bal/1,init_serv/0,clientes/2,main/0]).

bal(Servs) ->   
    receive
        {req, Arg, Pid} ->
            Proc = lists:nth( rand:uniform(length(Servs)), Servs),
            Proc ! {req, Arg, self(),Pid},
            bal(Servs);    
        {reply, Reply, Pid} -> 
            Pid ! Reply
    end,
    bal(Servs).

init_serv() ->  
    io:fwrite("servidor activo ~n"),
    receive
        {req, Arg, Padre, Pid} -> 
            io:fwrite("servidor ~p recibió ~p ~n", [self(), Arg]),
            Padre ! {reply, Arg, Pid},
            init_serv()
    end.    

clientes(Pid,Arg) -> 
    if 
        Arg > 0 -> 
            io:fwrite("cliente ~p envio ~p ~n",[self(),Arg]),
            Pid ! {req,Arg,self()},
            receive
                Resp -> io:fwrite("cliente ~p recibio ~p ~n",[self(),Arg])
            end,
            clientes(Pid,Arg-1);
        true -> ok
    end.

main() ->
    Serv1 = spawn(fun init_serv/0),
    Serv2 = spawn(fun init_serv/0),
    Bal = spawn(fun() -> bal([Serv1, Serv2]) end),
    spawn(fun() -> clientes(Bal, 5) end),
    spawn(fun() -> clientes(Bal, 5) end).

% el problema con la implementacion anterior eran 2

% 1) el programa espera recibir Reply que es el resultado de un proceso hijo, pero puede pasar que lo que
%    reciba es el pedido de un cliente

% 2) otro problema es que en el segundo receive se queda bloqueado con lo cual no puedo atender 2 
%    pedidos a la vez

