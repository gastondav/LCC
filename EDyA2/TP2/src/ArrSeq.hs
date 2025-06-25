module ArrSeq where

import qualified Arr as A
import Arr ((!))  -- para poder usar (!)

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
mapS f s = A.tabulate (\i -> f (nthS s i)) (lengthS s)

-- ?
filterS :: (a -> Bool) -> A.Arr a -> A.Arr a 
filterS f s = let 
                lista =[nthS s i| i <- [0 .. ((lengthS s) - 1)]  ]
                filter_list = filter f lista
                in A.fromList filter_list
                    where 
                        filter f []     = []
                        filter f (x:xs) = if f x 
                                            then x : filter f xs
                                            else filter f xs


appendS :: A.Arr a -> A.Arr a -> A.Arr a
appendS s1 s2 = A.tabulate f (n + m)
                    where 
                        n = lengthS s1
                        m = lengthS s2
                        f i = if i > n - 1
                                then nthS s2 (i - n)
                                else nthS s1 i


takeS :: A.Arr a -> Int -> A.Arr a
takeS s i = A.subArray 0 i s


dropS :: A.Arr a -> Int -> A.Arr  a
dropS s i = A.subArray i ((lengthS s) - i) s


showtS :: A.Arr a -> A.TreeView a (A.Arr a)
showtS s | lengthS s == 0 = A.EMPTY
         | lengthS s == 1 = A.ELT (nthS s 0)
         | otherwise = let 
                        m = div (lengthS s) 2
                        l = takeS s m
                        r = dropS s m
                        in A.NODE l r


showlS :: A.Arr a -> A.ListView a (A.Arr a)
showlS s | lengthS s == 0 = A.NIL
         | otherwise = A.CONS (nthS s 0) (dropS s 1) 


joinS :: A.Arr (A.Arr a) -> A.Arr a
joinS s = A.flatten s


fromListS :: [a] -> A.Arr a 
fromListS s = A.fromList s

{- 
   reduceS    :: (a -> a -> a) -> a -> s a -> a
   scanS      :: (a -> a -> a) -> a -> s a -> (s a, a)
-}