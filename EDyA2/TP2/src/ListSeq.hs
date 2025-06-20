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

    --mapS       = ...
    --filterS    = ...
    
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
                        izq = takeS m xs
                        der = drop 

    --showlS     = ...
    
    --joinS      = ...
    --reduceS    = ...
    --scanS      = ...
    --fromList   = ...
