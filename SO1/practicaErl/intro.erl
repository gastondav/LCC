-module(intro).
-export([init/0,apellido/1,nombre/1,string_test/0,filtrar_por_apellido/2]).

match_test () ->
    {A,B} = {5,4},
    %{C,C} = {5,4},
    {B,A} = {4,5}, %va bien porque A= 5 y B=5
    {D,D} = {5,5}.

string_test () -> [
    helloworld == 'helloworld', %ambos son el mismo atomos
    "helloworld" < 'helloworld',%'helloworld', %los atomicos valen menos que las strings
    helloworld == "helloworld", %false atomico != string
    [$h,$e,$l,$l,$o,$w,$o,$r,$l,$d] == "helloworld", % $ es caracter
    [104,101,108,108,111,119,111,114,108,100] > {104,101,108,108,111,119,111,114,108,100}, %las tuplas tinene meno valor que las listas
    [104,101,108,108,111,119,111,114,108,100] > 1, % las listas tienen mayor valor que 
    [104,101,108,108,111,119,111,114,108,100] == "helloworld"]. %los int son el codigo ascci de helloworld

tuple_test (P1, P2) ->
    io:fwrite("El nombre de P1 es ~p y el apellido de P2 es ~p~n", [nombre(P1), apellido(P2)]).

apellido ({persona,{nombre,_},{apellido,Ape_tex}}) -> 
    Ape_tex.


nombre ({persona,{nombre,Nombre},{apellido,_}}) -> 
    Nombre.

filtrar_por_apellido([], _) -> [];
filtrar_por_apellido([Hd | Tl], Apellido) ->
    Ape = apellido(Hd), 
    if
        (Ape == Apellido) -> [Hd | filtrar_por_apellido(Tl, Apellido)];
        true -> filtrar_por_apellido(Tl,Apellido)
    end.

init () ->
    P1 = {persona, {nombre, "Juan"}, {apellido, "Gomez"}},
    P2 = {persona, {nombre, "Carlos"}, {apellido, "Garcia"}},
    P3 = {persona, {nombre, "Javier"}, {apellido, "Garcia"}},
    P4 = {persona, {nombre, "Rolando"}, {apellido, "Garcia"}},
    match_test(),    
    tuple_test(P1, P2),
    string_test(),
    Garcias = filtrar_por_apellido([P4, P3, P2, P1], "Garcia").