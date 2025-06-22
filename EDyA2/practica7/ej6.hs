import ListSeq ()
import Seq
import Par

es_multiplo :: Integral a => a -> a -> Int 
es_multiplo a b = if (mod a b) == 0
                    then 1
                    else 0
                
multiplos :: (Seq s, Integral a) => s a -> Int
multiplos s = case showlS s of 
                NIL -> 0
                CONS x xs -> reduceS (+) 0 (mapS (es_multiplo x) xs) + multiplos xs
                