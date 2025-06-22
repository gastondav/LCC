{-# LANGUAGE InstanceSigs #-}
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
                                            | otherwise = f i : (tabulateS_aux f (i+1) n) 

    mapS :: (a -> b) -> [a] -> [b]
    mapS f []     = []
    mapS f (x:xs) = (f x) : (mapS f xs)
    {- Que conviene mas (por el append que es ineficiente)
        mapS f xs = case showtS xs of 
        EMPTY    -> []
        ELT x    -> [f x]
        NODE l r -> let (l', r') = mapS f l ||| mapS f r in appendS l' r' -}

    filterS :: (a -> Bool) -> [a] -> [a]
    filterS f []     = []
    filterS f (x:xs) | (f x) == True = x : (filterS f xs)
                     | otherwise = (filterS f xs)
    
    appendS :: [a] -> [a] -> [a]
    appendS xs ys = xs ++ ys

    takeS :: [a] -> Int -> [a]
    takeS []     n = error "lista vacia"
    takeS xs     0 = []
    takeS (x:xs) n = x : (takeS xs (n - 1)) 

    dropS :: [a] -> Int -> [a]
    dropS []     n = error "lista vacia"
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
    joinS xs = foldr (++) [] xs
    
    reduceS :: (a -> a -> a) -> a -> [a] -> a
    reduceS comb e xs = reduceT comb e (toTree xs)
        where
            toTree :: [a] -> TreeView a [a] 
            toTree xs = case length xs of 
                        1 -> ELT (head xs)
                        n -> let k = 2 ^ (floor (logBase 2 (fromIntegral (n-1)))) 
                            in NODE (takeS xs k) (dropS xs k)
            reduceT :: (a -> a -> a) -> a -> TreeView a [a] -> a
            reduceT comb e EMPTY      = e
            reduceT comb e (ELT x)    = x
            reduceT comb e (NODE l r) = let (l', r') = (reduceT comb e (toTree l)) ||| 
                                                       (reduceT comb e (toTree r)) 
                                    in comb l' r'
           
    scanS :: (a -> a -> a) -> a -> [a] -> ([a], a)
    scanS comb e [] = ([e], e)
    scanS comb e xs = let resul  = scanS_aux comb e xs
                          resul' = e : resul
                          (resto, ultimo) = dividir resul'
                      in (resto, ultimo)
        where 
            scanS_aux :: (a -> a -> a) -> a -> [a] -> [a]
            scanS_aux comb acum [x] = [comb acum x]
            scanS_aux comb acum (x:xs) = let acum' = (comb acum x) in acum' : (scanS_aux comb acum' xs)
            dividir :: [a] -> ([a], a)
            dividir [x]      = ([], x)
            dividir (x : xs) = let (resto, ultimo) = dividir xs in (x : resto , ultimo)

    fromList :: [a] -> [a]
    fromList xs = xs


