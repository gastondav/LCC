data T a = E | N (T a) a (T a) deriving Show

(|||):: a->b -> (a,b)
x|||y = (x,y)

inorder :: T a -> [a]
inorder E = []
inorder (N l x r) = let (l', r') = inorder l ||| inorder r in l' ++ [x] ++ r'

altura:: T a -> Int
altura E = 0
altura (N l x r) = 1 + ( max (altura l) (altura r) )

combinar :: T a -> T a -> T a 
combinar E t2 = t2
combinar t1 E = t1
combinar t1 t2 = let (t,min) = combinar_aux t1 in 
                    (N t min t2)

combinar_aux :: T a -> (T a, a)
combinar_aux (N E x r) = (r, x)
combinar_aux (N (N E y E) x r) = (N E x r, y)
combinar_aux (N (N E y r2) x r) = (N r2 x r, y) 
combinar_aux (N l x r) = let (l',min) = combinar_aux l in 
                            ((N l' x r),min)

--- (N (N (N E 1 (N E 8 E)) 3 (N E 2 (N E 9 E))) 4 (N (N E 4 (N E 7 E)) 2 (N E 5 (N E 6 E))))
filterT:: (a->Bool) -> T a -> T a
filterT pred E = E
filterT pred (N l x r) = let (l',r') = (filterT pred l ||| filterT pred r ) in
     if (pred x) then (N l' x r') else combinar l' r'
     
quicksortT :: T Int -> T Int
quicksortT E           = E 
quicksortT t@(N l p r) = let (l',r') = (filterT (p>) t) ||| (filterT (p<) t) 
                         in (N (quicksortT l') p (quicksortT r'))  
