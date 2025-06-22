import ListSeq ()
import Seq
import Par

greater :: (a -> a -> Ordering) -> a -> a -> Bool
greater f x y = (f x y == GT)

merge :: Seq s => (a -> a -> Ordering) -> s a -> s a -> s a
merge f xs ys = case showlS xs of 
                NIL -> ys
                CONS x xs' -> case showlS ys of  
                             NIL -> xs
                             CONS y ys' -> if greater f x y
                                          then appendS (singletonS y) (merge f xs ys')
                                          else appendS (singletonS x) (merge f xs' ys)

sort :: Seq s => (a -> a -> Ordering) -> s a -> s a
sort f s = case showtS s of 
            EMPTY -> emptyS
            ELT x -> singletonS x
            NODE l r -> let (l', r') = sort f l ||| sort f r
                in merge f l' r'

maxE :: Seq s => (a -> a -> Ordering) -> s a -> a
maxE f s = reduceS mayor (nthS s 0) (dropS s 1)
            where 
                mayor a b = if (greater f a b) == True
                            then a
                            else b

maxS :: Seq s => (a -> a -> Ordering) -> s a -> Int
maxS f s = (\(a, b) -> b) (reduceS mayor (nthS s' 0) (dropS s' 1))
            where 
                mayor (a, b) (c, d) = if (greater f a c) == True
                                        then (a, b)
                                        else (c, d)
                s' = index s

index :: Seq s => s a -> s (a, Int)
index s = tabulateS f (lengthS s)
          where 
            f i = (nthS s i, i)

