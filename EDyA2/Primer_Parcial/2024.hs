data Color = R | B deriving Show
data AATree a = N Color a (AATree a) (AATree a) | E deriving Show

--a)

maxBST :: AATree a -> a
maxBST (N _ a _ E) = a
maxBST (N _ a _ r) = maxBST r

minBST :: AATree a -> a
minBST  (N _ a E _) = a
minBST  (N _ a l _) = minBST l

isBST :: Ord a => AATree a -> Bool
isBST E         = True
isBST (N _ a E E) = True
isBST (N _ a l E) = a >= (maxBST l) && isBST l
isBST (N _ a E r) = a <= (minBST r) && isBST r
isBST (N _ a l r) = a <= (minBST r) && a >= (maxBST l) && (isBST r) && (isBST l)

--b)

isAATree :: Ord a => AATree a -> Bool
isAATree t = (isBST t) && (padreNegro t) && (rojoDer t) && (alturaNegra t (get_altura t))

colorNegro :: AATree a -> Bool
colorNegro E           = True
colorNegro (N B _ _ _) = True
colorNegro t = False

padreNegro :: AATree a -> Bool
padreNegro E = True
padreNegro (N R _ l r) = (colorNegro r) && (colorNegro l) && (padreNegro l) && (padreNegro r)

rojoDer :: AATree a -> Bool
rojoDer E                       = True
rojoDer (N _ _ E E)             = True
rojoDer (N _ _ E r)             = rojoDer r  
rojoDer (N _ _ l@(N B _ _ _) r) = (rojoDer r) && (rojoDer l)

alturaNegra :: Ord a => AATree a -> Int -> Bool
alturaNegra E n            = if n == 0 
                            then True
                            else False
alturaNegra (N B a l r)  n = alturaNegra l (n -1) && alturaNegra r (n-1) 
alturaNegra (N R a l r)  n = alturaNegra l n && alturaNegra r n

get_altura :: Ord a => AATree a -> Int
get_altura E = 0
get_altura (N R _ l _) = get_altura l
get_altura (N B _ l _) = 1 + get_altura l 

--c)

member :: Ord a => a -> AATree a -> Bool
member n E           = False
member n (N _ a l r) | a > n = member n r
                     | a < n = member n l
                     | otherwise = True

--d)

insert :: Ord a => a -> AATree a -> AATree a
insert n t = makeBlack (ins n t)
        where ins n E           = (N R n E E)
              ins n (N c a l r) | n > a = balanceDer c a l (ins n r)
                                | n < a = balanceIzq c a (ins n l) r
                                | otherwise = (N c a l r) 
              makeBlack E           = E
              makeBlack (N _ a l r) = (N B a l r) 

balanceDer :: Ord a => Color -> a -> AATree a -> AATree a -> AATree a
balanceDer B x a (N R y b (N R z c d)) = (N R y (N B x a b) (N B z c d))
balanceDer B x a (N R z (N R y b c) d) = (N R y (N B x a b) (N B z c d))
balanceDer c a l r                     = (N c a l r)

balanceIzq :: Ord a => Color -> a -> AATree a -> AATree a -> AATree a
balanceIzq color y (N R x a b) c = balanceDer R x a (N R y b c)
balanceIzq color x l r = balanceIzq_aux color x l r

balanceIzq_aux :: Ord a => Color -> a -> AATree a -> AATree a -> AATree a
balanceIzq_aux B z (N R y (N R x a b) c) d = (N R y (N B x a b) (N B z c d))
balanceIzq_aux B z (N R x a (N R y b c)) d = (N R y (N B x a b) (N B z c d))
balanceIzq_aux c a l r                     = (N c a l r)