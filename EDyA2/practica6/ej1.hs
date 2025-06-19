(|||) :: a -> b -> (a, b)
(|||) a b = (a, b)

data BTree a = Empty | Node Int (BTree a) a (BTree a) deriving Show

size :: BTree a -> Int
size Empty = 0
size (Node n _ _ _ ) = n

inorder :: BTree a -> [a]
inorder Empty = []
inorder (Node n l x r) = let (l', r') = inorder l ||| inorder r in l' ++ [x] ++ r'

nth :: BTree a -> Int -> a
nth Empty _          = error "index out of range"
nth (Node n l x r) i | i == sl = x
                     | i < sl = nth l i 
                     | otherwise = nth r (i - sl - 1) 
                     where sl = size l

cons :: a -> BTree a -> BTree a
cons a Empty          = (Node 1 Empty a Empty)
cons a (Node n l x r) = (Node (n+1) (cons a l) x r)

-- tabulate sin paralelizar
tabulate_s :: (Int -> a) -> Int -> BTree a
tabulate_s f 0 = Empty
tabulate_s f n = (Node n (tabulate_s f n')(f n') Empty) where n' = n-1

-- tabulate paralelizado
tabulate :: (Int -> a) -> Int -> BTree a
tabulate f 0 = Empty
tabulate f n = tab_aux f 0 n 

tab_aux :: (Int -> a) -> Int -> Int -> BTree a
tab_aux f i j | i > j = Empty
              | otherwise = let (l', r') = tab_aux f i (m-1) ||| tab_aux f (m + 1) j 
              in Node cant l' (f m) r'
              where 
                m = (i + j) `div` 2
                cant = j - i + 1

mapT :: (a -> b) -> BTree a -> BTree b
mapT f Empty = Empty
mapT f (Node n l x r) = let (l', r') = mapT f l ||| mapT f r in (Node n l' (f x) r')


takeT :: Int -> BTree a-> BTree a 
takeT x Empty = Empty
takeT x (Node n l v r ) = if (x >= n) then (Node n l v r ) else (takeT_aux x (Node n l v r ))

takeT_aux x Empty = Empty
takeT_aux x (Node n l v r ) | (x > ind) = (Node x l v (takeT_aux (x-ind) r) ) 
                            | (x < ind) = (takeT_aux x l)
                            | (x == ind) = (Node ind l v Empty) 
                            where ind = size(l)+1

dropT :: Int -> BTree a-> BTree a
dropT x Empty = Empty
dropT x (Node n l v r ) = if (x >= n) then Empty else (dropT_aux x (Node n l v r ))

dropT_aux x Empty = Empty
dropT_aux x (Node n l v r ) | (x > ind) =  (dropT_aux (x-ind) r)
                            | (x < ind) = (Node x (dropT_aux x l) v r )
                            | (x == ind) = r
                            where ind = size(l) + 1

 