reduce :: (a -> a -> a) -> a -> [a] -> [a]
reduce f e [] = 
reduce 

aguaHist :: [Int] -> Int
aguaHist hs = let maxL = scanl max 0 hs
                  maxR = reverse (scanl max 0 (reverse hs))
                  agua = zipWith3 (\l r h -> max 0 (min l r - h)) maxL maxR hs
                  in reduce (+) 0 agua
