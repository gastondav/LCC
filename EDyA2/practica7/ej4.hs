import ListSeq ()
import Seq
import Par

data Paren = Open | Close deriving (Eq, Show)

-- a)

matchParen:: Seq s => s Paren -> Bool 
matchParen s = (matchP s == (0, 0))

comb:: (Int, Int) -> (Int, Int) -> (Int, Int)
comb (i,k) (i',k')| (k >= i') = (i, k- i' + k')
                  | otherwise = (i + i'- k, k')

matchP:: Seq s => s Paren -> (Int, Int)
matchP s = case showtS s of
  EMPTY -> (0,0)
  ELT x -> if (x == Open) then (0, 1) 
                          else (1, 0)
  NODE l r -> let (l', r') = matchP l ||| matchP r
              in comb l' r'

-- b) 

