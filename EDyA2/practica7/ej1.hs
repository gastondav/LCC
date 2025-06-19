--Uso listas como secuencias

--- FUNCIONES AUXILIARES

mapReduce :: [a] -> b -> (a->b) -> (b -> b -> b) -> b
mapReduce [] e f comb = e
mapReduce (x : xs) e f comb = comb (f x) (mapReduce xs e f comb)


split :: [a]-> Int-> ([a], [a])
split xs i = split_aux xs i ([], []) 

split_aux:: [a]->Int->([a],[a]) -> ([a],[a])
split_aux [] i t = t
split_aux xs 0 (a, b) = (a, xs) 
split_aux (x : xs) i (a, b) = split_aux xs (i - 1) (a ++ [x], b) 


index:: [a] -> [(a,Int)]
index [] = []
index xs = index_aux 0 xs where 
                            index_aux i [] = []
                            index_aux i (x:xs) = (x,i) : (index_aux (i + 1) xs)


--a) promedios [1,2,3,4] -> [1.0,1.5,2.0,2.5]

promedios :: [Int]-> [Float]
promedios s = let sumas = scanl (+) 0 s in (map f (drop 1 (index sumas)))
                                         where
                                          f (a,b) = ((fromIntegral a)/ (fromIntegral ( b )))

--b) mayores

-- entrada : [1,2,5,3,5,2,7,9]
-- salida : 4
mapop :: [(Int, Int)] -> [(Int, Int)] -> Int
mapop [] xs = 0
mapop xs [] = 0
mapop (x : xs) (y : ys) = let res = (mapop xs ys) in
                                                    if x == y -- tiene que coincidir indice y valor
                                                      then 1 + res  
                                                      else res

max2:: (Int, Int) -> (Int, Int) -> (Int, Int) 
max2 (a, b) (a1, b1)  | (a > a1) = (a, b)
                      | (a1 > a) = (a1, b1)
                      | otherwise = (a, (min b1 b))


mayores:: [Int] -> Int
mayores s = let
              s' = (zip s [1..])               --zipeo secuencia con indices
              maximos = (scanl max2 (0,0) s')  --saco los maximos de las subsecuencias con minimo indice
            in (mapop s' (drop 1 maximos)) - 1 --me fijo si coinciden en indice y valor con los (valor,indice)


-- VERSION DE LA PROFE

-- entrada : [1,2,5,3,5,2,7,9]
-- salida : 4
mayores_profe :: [Int] -> Int
mayores_profe []       = 0
mayores_profe (x : xs) = let resul = scanl max x xs in mayores_aux resul (drop 1 xs)

-- entrada de mayores_aux
-- [1,2,5,3,5,2,7,9] = scanl max x xs
-- [2,5,3,5,2,7,9] = drop 1 xs

mayores_aux :: [Int] -> [Int] -> Int
mayores_aux _        []       = 0
mayores_aux (y : ys) (x : xs) = if x > y 
                                then 1 + mayores_aux ys xs
                                else 0 + mayores_aux ys xs      
