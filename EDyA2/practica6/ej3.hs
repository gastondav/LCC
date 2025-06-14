data Tree a = E |Leaf a| Join (Tree a) (Tree a) deriving (Show, Eq)

sufijos:: Tree Int -> Tree(Tree Int)
sufijos E = E 
sufijos t = snd(sufijos' t E)

sufijos' :: Tree Int -> Tree Int -> (Tree Int,Tree(Tree Int))  
sufijos' (Leaf x) acum = (Leaf x, Leaf acum)
sufijos' (Join l r) acum = let 
                                (sec, acum2) = sufijos' r acum 
                                sec_2 = if (acum == E) then sec else (Join sec acum)
                            in (sec_2 , (Join (snd(sufijos' l sec_2)) acum2))    

--entrada: 
--Join (Join (Leaf 10) (Leaf 15)) (Leaf 20)
--salida:
--Join (Join (Leaf (Join (Leaf 15) (Leaf 20))) (Leaf (Leaf 20))) (Leaf E)

conSufijos:: Tree Int -> Tree(Int, Tree Int)
conSufijos E = E 
conSufijos t = thd(conSufijos' t E)

-- tsd = tree_con_sufijos_der
-- tsi = tree_con_sufijos_izq
-- ts = tree_con_sufijos
-- tdr = tree_tupla_der
-- tdi = tree_tupla_izq

thd :: (a, b, c) -> c
thd (a, b, c) = c

dos :: (a, b, c) -> (b, c)
dos (a, b, c) = (b, c)

conSufijos' :: Tree Int -> Tree Int -> (Tree Int, Tree (Tree Int), Tree(Int, Tree Int))
conSufijos' (Leaf x) acum   = (Leaf x, Leaf acum, Leaf (x, acum))
conSufijos' (Join l r) acum = let 
                                (sec, tsd, tdr) = conSufijos' r acum 
                                sec_2 = if (acum == E) then sec else (Join sec acum)
                                (tsi, tdi) = dos(conSufijos' l sec_2)
                                ts = (Join tsi tsd)
                            in (sec_2, ts, (Join tdi tdr))    

--entrada: 
--Join (Join (Leaf 10) (Leaf 15)) (Leaf 20)
--salida:
--Join (Join (Leaf 10, (Join (Leaf 15) (Leaf 20))) (Leaf (15,(Leaf 20)))) (Leaf (20, Leaf E))
--Join (Join (Leaf (10,Join (Leaf 15) (Leaf 20))) (Leaf (15,Leaf 20))) (Leaf (20,E))

mapReduce :: (a -> b) -> (b -> b -> b) -> b -> Tree a -> b
mapReduce _ _ e E            = e
mapReduce f _ _ (Leaf x)     = f x
mapReduce f comb e (Join l r) = comb (mapReduce f comb e l) (mapReduce f comb e r)

e2 = 0

reduceT :: (Int -> Int -> Int) -> Int -> Tree Int -> Int
reduceT _ e E            = e
reduceT f e (Leaf a)     = f e a
reduceT f e (Join l r)   = f (reduceT f e l) (reduceT f e r)  

maxT :: Tree Int -> Int
maxT = reduceT max e2

maxAll:: Tree(Tree Int) -> Int
maxAll = mapReduce maxT max e2

mejorGanancia :: Tree Int -> Int
mejorGanancia t = maxAll ( mapT (ganancias) (conSufijos t)) 
                    where ganancias (i,t2) = Leaf (mapReduce (-i+) max e2 t2) 


