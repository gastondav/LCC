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
                        n = len

{- 
   takeS      :: s a -> Int -> s a
   dropS      :: s a -> Int -> s a
   showtS     :: s a -> TreeView a (s a)
   showlS     :: s a -> ListView a (s a)
   joinS      :: s (s a) -> s a
   reduceS    :: (a -> a -> a) -> a -> s a -> a
   scanS      :: (a -> a -> a) -> a -> s a -> (s a, a)
   fromList   :: [a] -> s a -}