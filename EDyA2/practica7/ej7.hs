import ListSeq ()
import Seq
import Par

{- data Treeview a = Empty | Leaf a | Node [a] [a] deriving Show
 -}
{- showt::[a]-> Treeview a
showt [] = Empty
showt [x] = Leaf x
showt xs =let miti = (div (length xs) 2) in Node (take miti xs) (drop miti xs)   
 -}
greater :: (a -> a -> Ordering) -> a -> a -> Bool
greater f x y = (f x y == GT)
{- 
merge ::(a->a->Ordering) -> [a]-> [a] -> [a]
merge f  xs ys = case showt xs of
                Empty -> ys
                Leaf x -> let (g,l) = ((filter (greater f x) ys) ||| (filter (\a -> not (greater f x a)) ys)) 
                            in ((l ++ [x]) ++ g)
                Node l r -> let lft = merge f l ys 
                            in merge f r lft 
 -}

merge :: Seq s => (a -> a -> Ordering) -> s a -> s a -> s a
merge f xs ys = case showlS xs of 
                NIL -> ys
                CONS x xs' -> case showlS ys of  
                             NIL -> appendS (singletonS x) xs
                             CONS y ys' -> if greater f x y
                                          then appendS (singletonS y) (merge f xs ys')
                                          else appendS (singletonS x) (merge f xs' ys)

{- comb :: (a -> a -> Ordering) -> a -> Seq a
comb f a xs = case showtS xs of 
             EMPTY -> a
             ELT x -> if (f x a == True) 
                      then appendS (singletonS a) (singletonS xs)
                      else appendS (singletonS xs) (singletonS a)
             NODE l r ->  -}