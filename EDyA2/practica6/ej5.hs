data BTree a = Empty | Node Int (BTree a) a (BTree a) deriving Show

(|||):: a->b -> (a,b)
x|||y = (x,y)

size :: BTree a -> Int 
size Empty        = 0
size (Node n _ _ _) = n

--a)

--Supongo que el indice empieza a contar en 1
splitAt' :: BTree a -> Int -> (BTree a, BTree a)
splitAt' Empty _              = (Empty, Empty)
splitAt' t 0                  = (Empty, t)
splitAt' (Node n l x r) i | i == nod_izq = (l, (Node (n - nod_izq) Empty x r))
                          | i < nod_izq  = let (t1, t2) = splitAt' l i
                                              in (t1, (Node (n - size t1) t2 x r))                
                          | otherwise = let (t1, t2) = splitAt' r (i - nod_izq - 1)
                                              in (Node (n - size t2) l x t1 ,t2)
                         where nod_izq = size l
--entrada: Node 7 (Node 3 (Node 1 Empty 1 Empty) 2 (Node 1 Empty 3 Empty)) 4 (Node 3 (Node 1 Empty 5 Empty) 6 (Node 1 Empty 7 Empty))

--entrada: Node 8 (Node 4 (Node 1 Empty 1 Empty) 2 (Node 2 (Node 1 Empty 9 Empty) 3 Empty)) 4 (Node 3 (Node 1 Empty 5 Empty) 6 (Node 1 Empty 7 Empty))

--Transforma el arbol en lista en el sentido inorder 
--Para verificar si se cumplen las condiciones del ejercicio
toList :: BTree a -> [a]
toList Empty = []
toList (Node n l x r) = let (l', r') = toList l ||| toList r
                        in l' ++ [x] ++ r' 

--b)


-- Paso 1: Obtener la lista inorder del árbol
toList' :: BTree a -> [a]
toList' Empty = []
toList' (Node _ l x r) = toList' l ++ [x] ++ toList' r


buildBalanced :: [a] -> BTree a
buildBalanced xs = fst (build (length xs) xs)
  where
    build :: Int -> [a] -> (BTree a, [a])
    build 0 xs = (Empty, xs)
    build n xs =
      let (nL, nR) = (n `div` 2, n - n `div` 2 - 1)
          (lt, xs1) = build nL xs
          x : xs2   = xs1
          (rt, xs3) = build nR xs2
          tam = size lt + size rt + 1
      in (Node tam lt x rt, xs3)


rebalance :: BTree a -> BTree a
rebalance = buildBalanced . toList'
