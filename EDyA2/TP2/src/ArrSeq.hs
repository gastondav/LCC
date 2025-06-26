module ArrSeq where

import qualified Arr as A
import Arr ((!))  -- para poder usar (!)
import Par

emptyS :: A.Arr a
emptyS = A.empty


singletonS :: a -> A.Arr a
singletonS x = A.tabulate (\_ -> x) 1


lengthS :: A.Arr a -> Int
lengthS arr = A.length arr


nthS :: A.Arr a -> Int -> a
nthS arr i = arr ! i


tabulateS :: (Int -> a) -> Int -> A.Arr a
tabulateS f n = A.tabulate f n


mapS :: (a -> b) -> A.Arr a -> A.Arr b
mapS f arr = A.tabulate (\i -> f (nthS arr i)) (lengthS arr)


filterS :: (a -> Bool) -> A.Arr a -> A.Arr a 
filterS f arr = let 
                lista = [nthS arr i| i <- [0 .. ((lengthS arr) - 1)]  ]
                filter_list = filter f lista
                in A.fromList filter_list
                    where 
                        filter f []     = []
                        filter f (x:arr) = if f x 
                                            then x : filter f arr
                                            else filter f arr


appendS :: A.Arr a -> A.Arr a -> A.Arr a
appendS arr1 arr2 = A.tabulate f (n + m)
                    where 
                        n = lengthS arr1
                        m = lengthS arr2
                        f i = if i > n - 1
                                then nthS arr2 (i - n)
                                else nthS arr1 i


takeS :: A.Arr a -> Int -> A.Arr a
takeS arr i = A.subArray 0 i arr


dropS :: A.Arr a -> Int -> A.Arr  a
dropS arr i = A.subArray i ((lengthS arr) - i) arr


showtS :: A.Arr a -> A.TreeView a (A.Arr a)
showtS arr | lengthS arr == 0 = A.EMPTY
           | lengthS arr == 1 = A.ELT (nthS arr 0)
           | otherwise = let (m,(l,r)) = m ||| (takeS arr m ||| dropS arr m)
                        in A.NODE l r


showlS :: A.Arr a -> A.ListView a (A.Arr a)
showlS arr | lengthS arr == 0 = A.NIL
           | otherwise = A.CONS (nthS arr 0) (dropS arr 1) 


joinS :: A.Arr (A.Arr a) -> A.Arr a
joinS arr = A.flatten arr


fromListS :: [a] -> A.Arr a 
fromListS arr = A.fromList arr


reduceS :: (a -> a -> a) -> a -> A.Arr a -> a
reduceS comb e arr = case lengthS arr of
                        0 -> e
                        n -> let
                                arr' = mapS (\x -> (x, 1)) arr
                                resul = agrupa comb arr'
                                resul' = ultimo_agrupa comb resul
                            in comb e resul'
                    where
                        agrupa_aux :: (a -> a -> a) -> A.Arr (a, Int) -> A.Arr (a, Int)
                        agrupa_aux comb xs = case lengthS xs of 
                                                0 -> emptyS
                                                1 -> singletonS (nthS xs 0)
                                                n -> let 
                                                        ((x1, x2), (y1, y2)) = nthS xs 0 ||| nthS xs 1
                                                        resul = if x2 == y2
                                                                then 
                                                                    let (primero,  resto) = singletonS (comb x1 y1, x2 + y2) |||
                                                                                            (agrupa_aux comb (dropS xs 2))
                                                                    in appendS primero resto  
                                                                else 
                                                                    let (primero , segundo) = singletonS (x1, x2) ||| singletonS (y1, y2)
                                                                        (dos, resto) = appendS primero segundo ||| agrupa_aux comb (dropS xs 2)
                                                                    in appendS dos resto
                                                    in resul
                        agrupa :: (a -> a -> a) -> A.Arr (a, Int) -> A.Arr (a, Int)
                        agrupa comb xs = case lengthS xs of
                                            0 -> emptyS
                                            1 -> singletonS (nthS xs 0)
                                            n -> let 
                                                    ((x1, x2), (y1, y2)) = nthS xs 0 ||| nthS xs 1
                                                in if not (x2 == y2)
                                                    then xs
                                                    else let xs' = agrupa_aux comb xs
                                                         in agrupa comb xs'
                        ultimo_agrupa :: (a -> a -> a) -> A.Arr (a, Int) -> a 
                        ultimo_agrupa comb xs = if lengthS xs == 1
                                                then (\(a, b) -> a) (nthS xs 0)
                                                else 
                                                    let 
                                                        (primero, resto) = nthS xs 0 ||| dropS xs 1      
                                                        (primero', resto') = (\(a, b) -> a) primero ||| ultimo_agrupa comb resto
                                                    in comb primero' resto'


--scanS :: (a -> a -> a) -> a -> s a -> (s a, a)