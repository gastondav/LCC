--ej6)

type Rank = Int 
data Heap a = E | N Rank a (Heap a) (Heap a) deriving Show

rank :: Heap a -> Rank
rank E = 0
rank (N r _ _ _) = r

makeH x a b = if rank a >= rank b then N (rank b + 1) x a b
                                  else N (rank a + 1) x b a

merge :: Ord a => Heap a-> Heap a -> Heap a
merge h1 E = h1
merge E h2 = h2
merge h1@(N _ x a1 b1) h2@(N _ y a2 b2) = if (x <= y) then makeH x a1 (merge b1 h2)
                                                      else makeH y a2 (merge h1 b2)

fromList::Ord a => [a] -> Heap a
fromList xs = foldl merge_aux E xs
                    where merge_aux heap x = merge heap (N 1 x E E)


--ej7)

data PHeaps a = Empty | Root a [PHeaps a ] deriving Show

isPHeap :: Ord a => PHeaps a -> Bool
isPHeap Empty       = True
isPHeap (Root a hs) = isRootLegChild a hs && areChildrenPH hs where
    isRootLegChild a []              = True
    isRootLegChild a (Empty:hs)      = isRootLegChild a hs
    isRootLegChild a (Root x chs:hs) = a <= x && isRootLegChild a hs

    areChildrenPH []              = True
    areChildrenPH (Empty:hs)      = areChildrenPH hs
    areChildrenPH (Root x chs:hs) = isPHeap (Root x chs) && areChildrenPH hs


mergeph :: Ord a => PHeaps a -> PHeaps a -> PHeaps a
mergeph h1 Empty = h1
mergeph Empty h2 = h2
mergeph h1@(Root r1 s1) h2@(Root r2 s2)| (r1 <= r2)= (Root r1 (h2:s1))
                                    |otherwise = (Root r2 (h1:s2))


insert :: Ord a => PHeaps a -> a -> PHeaps a
insert ph a = mergeph ph (Root a [])


concatHeaps :: Ord a => [PHeaps a ] -> PHeaps a
concatHeaps [] = Empty
concatHeaps (x:xs) = foldl mergeph x xs


delMin :: Ord a => PHeaps a -> Maybe (a, PHeaps a)
delMin Empty = Nothing
delMin (Root a xs) = Just (a,concatHeaps xs)

