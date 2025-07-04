import ListSeq ()
import Seq
import Par

-- a)

greater :: (a -> a -> Ordering) -> a -> a -> Bool
greater f x y = (f x y == GT)

merge :: Seq s => (a -> a -> Ordering) -> s a -> s a -> s a
merge f xs ys = case showlS xs of 
                NIL -> ys
                CONS x xs' -> case showlS ys of  
                             NIL -> xs
                             CONS y ys' -> if greater f x y
                                          then appendS (singletonS y) (merge f xs ys')
                                          else appendS (singletonS x) (merge f xs' ys)

-- b) 

sort :: Seq s => (a -> a -> Ordering) -> s a -> s a
sort f s = case showtS s of 
            EMPTY -> emptyS
            ELT x -> singletonS x
            NODE l r -> let (l', r') = sort f l ||| sort f r
                in merge f l' r'

-- c)

maxE :: Seq s => (a -> a -> Ordering) -> s a -> a
maxE f s = reduceS mayor (nthS s 0) (dropS s 1)
            where 
                mayor a b = if (greater f a b) == True
                            then a
                            else b

-- d)

maxS :: Seq s => (a -> a -> Ordering) -> s a -> Int
maxS f s = (\(a, b) -> b) (reduceS mayor (nthS s' 0) (dropS s' 1))
            where 
                mayor (a, b) (c, d) = if (greater f a c) == True
                                        then (a, b)
                                        else (c, d)
                s' = index s

index :: Seq s => s a -> s (a, Int)
index s = tabulateS f (lengthS s)
          where 
            f i = (nthS s i, i)

-- e)

group :: Seq s => (a -> a -> Ordering) -> s a -> s a
group f s = reduceS (combGroup f) emptyS (mapS singletonS s)

combGroup :: Seq s => (a -> a -> Ordering) -> s a -> s a -> s a
combGroup f xs ys = case showlS xs of
                    NIL -> ys
                    CONS x xs' -> case showlS ys of
                                    NIL -> xs
                                    CONS y ys' -> if (iguales f last_xs y) == True
                                                    then appendS xs ys'
                                                    else appendS xs ys 
                                                        where 
                                                            last_xs = nthS xs ((lengthS xs) - 1)

iguales :: (a -> a -> Ordering) -> a -> a -> Bool
iguales f a b = (f a b) == EQ

-- f)

collect_aux :: (Seq s, Eq a, Ord a) => s (a, b) -> s (a, s b)
collect_aux s = case showlS s of 
                NIL -> emptyS
                CONS (a, b) xs -> let bs = filterS f xs -- filtro por clave "a"
                                      bs' = mapS (\(c,d) -> d) bs  -- me quedo con los valores de una clave 
                                      xs' = filterS not_f xs     -- me quedo con la secuencia sin es clave
                                      bs'' = appendS (singletonS b) bs' 
                                      new = (a, bs'')
                                      new' = singletonS new
                                    in appendS new' (collect_aux xs')
                                        where
                                            f (c, d) = if a == c 
                                                        then True
                                                        else False   
                                            not_f (c, d) = not (f (c, d))
                                
collect :: (Seq s, Eq a, Ord a) => s (a, b) -> s (a, s b)
collect s = sort f (collect_aux s)
            where
                f (a, b) (c, d) = if a > c 
                                    then GT
                                    else LT

-- EJERCICIO 8

datosIngreso :: Seq s => s (String, s Int) -> s (Int, Int)
datosIngreso s = let pairs = mapS apv s
                     groups = collect pairs
                     in mapS red groups 

apv :: Seq s => (String, s Int) -> (Int, (Int, Int))
apv (name, s) = let largo = lengthS s
                    suma = reduceS (+) 0 s
                    prom = div suma largo
                    in (categoria prom, (1, prom))
                        where
                            categoria n | n >= 70 = 0
                                        | n > 50 = 1
                                        | otherwise = 2 

red :: Seq s => (Int, s (Int, Int)) -> (Int, Int)
red (k, s) = let (cant, maximo) = reduceS comb_red (0,0) s
             in (cant, maximo)
                where 
                    comb_red (n, prom) (n', prom') = (n + n', max prom prom')

--ENTRADA:
--[("Ana", [90, 80]), ("Beto", [60, 70]), ("Clara", [40, 50]), ("David", [85, 95]), ("Eva", [55, 50])]
--SALIDA: 
--[(2,90),(2,65),(1,45)]


--EJERCICIO 9

countCaract :: Seq s => s (s Char) -> s (Char, Int)
countCaract s = let pairs = joinS (mapS apv' s)
                    groups = collect pairs
                in mapS red' groups

apv' :: Seq s => s Char -> s (Char, Int) 
apv' texto = mapS (\c -> (c, 1)) texto

red' :: Seq s => (Char, s Int) -> (Char, Int)
red' (letra, s) = (letra, reduceS (+) 0 s)

