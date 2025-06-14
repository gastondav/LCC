data Tree a = E | Leaf a | Join (Tree a) (Tree a) deriving Show

(|||):: a->b -> (a,b)
x|||y = (x,y)

printCad :: Tree a -> [a]
printCad E          = []
printCad (Leaf a)   = [a] 
printCad (Join l r) = printCad l ++ printCad r

fst2 :: (a, b, c, d) -> a
fst2 (a, _, _, _) = a

mcss :: (Num a, Ord a) => Tree a -> a
mcss t = fst2 (mcss' t)

mcss' :: (Num a, Ord a) => Tree a -> (a, a, a, a)
mcss' E            = (0, 0, 0, 0)
mcss' (Leaf a)     = (max 0 a, max 0 a, max 0 a, max 0 a)
mcss' (Join l r)   = let ((s1, suf1, pref1, l1), (s2, suf2, pref2, l2)) = mcss' l ||| mcss' r 
                    in (max (max s1 s2) (suf1 + pref2),
                        max suf2 (l2 + suf1),
                        max pref1 (l1 + pref2),
                        l1 + l2)

--En termino de MapReduce
mapReduce :: (a -> b) -> (b -> b -> b) -> b -> Tree a -> b
mapReduce _ _ e E            = e
mapReduce f _ _ (Leaf x)     = f x
mapReduce f comb e (Join l r) = comb (mapReduce f comb e l) (mapReduce f comb e r)

mcss2 :: (Num a, Ord a) => Tree a -> a
mcss2 = (\(x,_,_,_) -> x) . mcss2'

f :: (Num a, Ord a) => a -> (a, a, a, a)
f x = (max x 0, max x 0, max x 0, max x 0)

e :: (Num a) => (a, a, a, a)
e = (0, 0, 0, 0)

combine :: (Num a, Ord a) => (a, a, a, a) -> (a, a, a, a) -> (a, a, a, a)
combine (s1, suf1, pref1, l1) (s2, suf2, pref2, l2) = (max s1 (max s2 (suf1 + pref2)),
                                                       max suf2 (l2 + suf1),
                                                       max pref1 (l1 + pref2),
                                                       l1 + l2)

mcss2'  :: (Num a, Ord a) => Tree a -> (a,a,a,a)
mcss2' = mapReduce f combine e

