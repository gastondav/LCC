module ListSeq where
import Seq
import Par

instance Seq [] where
    emptyS :: [a]
    emptyS = []

    singletonS :: a -> [a]
    singletonS x = [x]

    lengthS :: [a] -> Int
    lengthS []     = 0
    lengthS (x:xs) = 1 + lengthS xs 
    
    nthS :: [a] -> Int -> a
    nthS []   n   = error "indice fuera de rango"
    nthS (x:xs) 0 = x
    nthS (x:xs) n = nthS xs (n-1) 
 
    tabulateS :: (Int -> a) -> Int -> [a]
    tabulateS f n = tabulateS_aux f 0 n
                    where
                        tabulateS_aux f i n | n == i    = []
                                            | otherwise = let (f', sec) = (f i) ||| (tabulateS_aux f (i+1) n) 
                                                            in f' : sec
    
    --O(n) S(n)
    mapS :: (a -> b) -> [a] -> [b]
    mapS f []     = []
    mapS f (x:xs) = let (f', sec) = f x ||| mapS f xs
                      in f' : sec

    filterS :: (a -> Bool) -> [a] -> [a]
    filterS f []     = []
    filterS f (x:xs) | (f x) == True = x : (filterS f xs)
                     | otherwise = (filterS f xs)
    
    appendS :: [a] -> [a] -> [a]
    appendS xs ys = xs ++ ys

    takeS :: [a] -> Int -> [a]
    takeS []     _ = []
    takeS xs     0 = []
    takeS (x:xs) n = x : (takeS xs (n - 1)) 

    dropS :: [a] -> Int -> [a]
    dropS []     _ = []
    dropS xs     0 = xs
    dropS (x:xs) n = dropS xs (n-1)

    showtS :: [a] -> TreeView a [a]
    showtS []     = EMPTY
    showtS [x]    = ELT x
    showtS xs     = let m = div (length xs) 2
                        (izq, der) = takeS xs m ||| dropS xs m
                        in NODE izq der

    showlS :: [a] -> ListView a [a]
    showlS []     = NIL
    showlS (x:xs) = CONS x xs

    joinS :: [[a]] -> [a]
    joinS [] = []
    joinS [x] = x
    joinS (x:xs) = x ++ joinS xs
    
    --O(n) S(n)
    reduceS :: (a -> a -> a) -> a -> [a] -> a
    reduceS comb e [] = e
    reduceS comb e xs = let
                        xs' = mapS (\x -> (x, 1)) xs
                        resul = agrupa comb xs'
                        resul' = ultimo_agrupa comb resul
                        in comb e resul'
                            where
                                agrupa_aux :: (a -> a -> a) -> [(a,Int)] -> [(a,Int)]
                                agrupa_aux comb [] = []
                                agrupa_aux comb [x] = [x]
                                agrupa_aux comb ((x1, x2) : (y1, y2) : xs) = if x2 == y2
                                                                            then (comb x1 y1, x2+y2) : agrupa_aux comb xs
                                                                            else (x1, x2) : (y1, y2) : agrupa_aux comb xs 
                                agrupa :: (a -> a -> a) -> [(a,Int)] -> [(a,Int)]
                                agrupa comb []  = []
                                agrupa comb [x] = [x]
                                agrupa comb s@((x1, x2) : (y1, y2) :xs) = if not(x2 == y2)
                                                                            then s
                                                                            else let xs' = agrupa_aux comb s
                                                                                in agrupa comb xs' 
                                ultimo_agrupa :: (a -> a -> a) -> [(a, Int)] -> a 
                                ultimo_agrupa comb [x] = (\(a,b) -> a) x
                                ultimo_agrupa comb (x:xs) = let r = (ultimo_agrupa comb xs)
                                                                x' = (\(a,b) -> a) x
                                                                in comb x' r

    --O(n) S(n)
    scanS :: (a -> a -> a) -> a -> [a] -> ([a], a)
    scanS comb e [] = ([], e)
    scanS comb e xs = let resul  = scanS_aux comb e xs
                          resul' = e : resul
                          (resto, ultimo) = dividir resul'
                      in (resto, ultimo)
        where 
            scanS_aux :: (a -> a -> a) -> a -> [a] -> [a]
            scanS_aux comb acum [x] = [comb acum x]
            scanS_aux comb acum (x:xs) = let acum' = (comb acum x) 
                                            in acum' : (scanS_aux comb acum' xs)
            dividir :: [a] -> ([a], a)
            dividir [x]      = ([], x)
            dividir (x : xs) = let (resto, ultimo) = dividir xs in (x : resto , ultimo)

    fromList :: [a] -> [a]
    fromList xs = xs

