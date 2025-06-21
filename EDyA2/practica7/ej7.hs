(|||) :: a -> b -> (a, b)
(|||) a b = (a, b)

data Treeview a = Empty | Leaf a | Node [a] [a] deriving Show

showt::[a]-> Treeview a
showt [] = Empty
showt [x] = Leaf x
showt xs =let miti = (div (length xs) 2) in Node (take miti xs) (drop miti xs)   

greater::(a->a->Ordering) -> a-> a -> Bool
greater f x y = (f x y == GT)

merge ::(a->a->Ordering) -> [a]-> [a] -> [a]
merge f  xs ys = case showt xs of
                Empty -> ys
                Leaf x -> let (g,l) = ((filter (greater f x) ys) ||| (filter (\a -> not (greater f x a)) ys)) 
                            in ((l ++ [x]) ++ g)
                Node l r -> let lft = merge f l ys 
                                in merge f r lft 
                    
