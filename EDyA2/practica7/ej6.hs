nth :: [Int] -> Int -> Int
nth [] _ = error "ERROR NTH"
nth (x:xs) 0 = x
nth (x:xs) n = nth xs (n-1)


{- cantMultiplos :: [Int] -> Int
cantMultiplos []     = 0
cantMultiplos x:xs = let
                         xs = cantMultiplos_aux xs (length xs_index)
                        in reduce (+) 0 xs'

cantMultiplos_aux :: [Int] -> Int -> [Int]
cantMultiplos_aux _  0 = 0
cantMultiplos_aux xs n = map e  -}

es_multiplo :: Int -> Int -> Int 
es_multiplo a b = if (mod a b) == 0
                    then 1
                    else 0
                
multiplos :: [Int]->Int
multiplos [] = 0
multiplos (x:xs) = foldr (+) 0 (map (es_multiplo x) xs) + multiplos xs
