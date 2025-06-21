reduce2 :: (a -> a -> a) -> a -> [a] -> a
reduce2 f e []     = e
reduce2 f e [x]    = x 
reduce2 f e (x:xs) = f x (reduce2 f e xs)

aguaHist :: [Int] -> Int
aguaHist hs = let maxL = scanl max 0 hs
                  maxR = reverse (scanl max 0 (reverse hs))
                  agua = zipWith3 (\l r h -> max 0 (min l r - h)) maxL maxR hs
                  in reduce2 (+) 0 agua

--Entrada: hs = [2, 3, 4, 7, 5, 2, 3, 2, 6, 4, 3, 5, 2, 1]

-- [0,2,3,4,7,7,7,7,7,7,7,7,7,7,7] = scanl max 0 hs

-- [7,7,7,7,6,6,6,6,6,5,5,5,2,1,0] = reverse (scanl max 0 (reverse hs))

--Salida: 15 