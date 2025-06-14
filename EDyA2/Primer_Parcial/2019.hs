data Treap p k = E | N (Treap p k) p k (Treap p k) deriving Show

--a)

key :: Treap p k -> k
key E = error "Treap es vacio"
key (N l p k r) = k

--b)

priority :: Treap p k -> p
priority E = error "Treap es vacio"
priority (N l p k r) = p

--c)

isTreap :: (Ord k, Ord p) => Treap p k -> Bool
isTreap E = True
isTreap (N l p k r) = checkPrioridad (N l p k r) && checkBusqueda (N l p k r)

checkPrioridad :: (Ord k, Ord p) => Treap p k -> Bool
checkPrioridad E = True
checkPrioridad (N E p k E)                             = True
checkPrioridad (N (N l1 p1 k1 r1) p k E)               = p >= p1 && checkPrioridad (N l1 p1 k1 r1)
checkPrioridad (N E p k (N l1 p1 k1 r1))               = p >= p1 && checkPrioridad (N l1 p1 k1 r1)
checkPrioridad (N (N l1 p1 k1 r1) p k (N l2 p2 k2 r2)) = p >= p1 && p >= p2 
                                                        && checkPrioridad (N l1 p1 k1 r1)
                                                        && checkPrioridad (N l2 p2 k2 r2)

maxKey :: (Ord k, Ord p) => Treap p k -> k
maxKey (N _ p k E) = k
maxKey (N _ p k r) = maxKey r

minKey :: (Ord k, Ord p) => Treap p k -> k
minKey (N E p k _) = k
minKey (N l p k _) = minKey l

checkBusqueda :: (Ord k, Ord p) => Treap p k -> Bool
checkBusqueda E = True
checkBusqueda (N E p k E) = True
checkBusqueda (N E p k r) = (minKey r) >= k && checkBusqueda r   
checkBusqueda (N l p k E) = (maxKey l) <= k && checkBusqueda l
checkBusqueda (N l p k r) = (maxKey l) <= k && (minKey r) >= k && checkBusqueda l && checkBusqueda r

--d)

insert :: (Ord k, Ord p) => k -> p -> Treap p k -> Treap p k 
insert k p E           = (N E p k E)
insert k p (N l p1 k1 r) | k > k1 = if (checkPrioridad (N l p1 k1 (insert k p r)))
                                    then (N l p1 k1 (insert k p r)) 
                                    else rotateL (N l p1 k1 (insert k p r)) 
                         | k < k1 = if(checkPrioridad (N l p1 k1 (insert k p l)))
                                    then (N (insert k p l) p1 k1 r)
                                    else rotateR (N (insert k p l) p1 k1 r)   
                         | otherwise = (N l p1 k r)
                         where rotateL (N l' p' k' (N l p k r)) = (N (N l' p' k' l) p k r)
                               rotateR (N (N l p k r) p' k' r') = (N l p k (N r p' k' r'))
        
--e)

split :: (Ord k, Ord p) => k -> Treap p k -> (Treap p k, Treap p k)
split k' E = (E, E)  
split k' t@(N l p k r) = (l1,r1) where (N l1 p1 k1 r1) = split_aux k' t

split_aux :: (Ord k, Ord p) => k -> Treap p k -> Treap p k
split_aux k' t@(N l p k r)  | k' < k  = izq (insert k' (priority t) t) 
                            | k' >= k = der (insert k' (priority t) t)
                            where izq (N (N l2 p2 k2 r2) p1 k1 r1) = (N l2 p2 k2 (N r2 p1 k1 r1)) 
                                  der (N l1 p1 k1 (N l2 p2 k2 r2)) = (N (N l1 p1 k1 l2) p2 k2 r2)