data Tree a = EB | Node (Tree a) a (Tree a) deriving Show

--1)

--a)

completo :: a -> Int ->  Tree a
completo a 0 = EB
completo a n = (Node t1 a t1) where t1 = completo a (n-1)

--b)

balanceado:: a -> Int -> Tree a
balanceado a 0 = EB
balanceado a n |  (n - 1) `mod` 2 == 0 = Node t1 a t1
               |  otherwise            = Node t1 a t2
                where 
                    q = (n - 1) `div` 2
                    t1 = balanceado a q
                    t2 = balanceado a (q + 1)

--2)

--1
data BST a = E | N (BST a) a (BST a) deriving Show

maximumBST:: Ord a => BST a -> a
maximumBST E = error "arbol vacio"
maximumBST (N _ a E) = a
maximumBST (N _ a t2) = maximumBST t2

checkBST :: Ord a => BST a -> Bool
checkBST E = True
checkBST (N E a E) = True
checkBST (N (N t1 b t2) a E) = (b <= a) && checkBST (N t1 b t2)
checkBST (N E a (N t1 c t2)) = (a < c) && checkBST (N t1 c t2) 
checkBST (N (N t1 b t2) a (N t3 c t4)) = (b <= a) && (a < c) && 
                                         checkBST (N t1 b t2) && checkBST (N t3 c t4)

splitBST :: Ord a => BST a -> a -> (BST a, BST a)
splitBST E _ = (E, E)
splitBST (N l y r) x | x == y = (N l y E, r)
                     | x < y = let (l', r') = splitBST l x
                        in (l', N r' y r)
                     | x > y = let (l', r') = splitBST r x
                        in (N l y l', r')

join :: Ord a => BST a -> BST a -> BST a
join E E = E
join t E = t 
join E t = t
join (N l x r) t1 = let (l', r') = splitBST t1 x 
                    in N (join l l') x (join r r')

--3)

member :: Ord a => a -> BST a -> Bool
member _ E = False
member a (N t1 b t2) = member_aux a b t1 || member_aux a b t2

member_aux :: Ord a => a -> a -> BST a -> Bool
member_aux a b E = a == b
member_aux a b (N t1 x t2) | a <= x = member_aux a x t1 
                           | otherwise = member_aux a b t2
