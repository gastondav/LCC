--usamos listas como secuencias

--- NO USADOS
mapreduce:: [a]->b->(a->b)->(b->b->b) ->b
mapreduce [] e f op = e
mapreduce (x:xs) e f op = (op (f x) (mapreduce xs e f op))

split:: [a]->Int-> ([a],[a])
split xs i = split_aux xs i ([],[]) 


split_aux:: [a]->Int->([a],[a]) -> ([a],[a])
split_aux [] i t = t
split_aux xs 0 (a,b) = (a,xs) 
split_aux (x:xs) i (a,b) = split_aux xs (i-1) (a++[x],b) 
----

index:: [a] -> [(a,Int)]
index [] = []
index xs = index_aux 0 xs
  where 
    index_aux i [] = []
    index_aux i (x:xs) = (x,i) : (index_aux (i+1) xs)


--a)promedios [1,2,3,4] -> [1.0,1.5,2.0,2.5]
promedios :: [Int]-> [Float]
promedios s = let sumas = scanl (+) 0 s
 in
  (map f (drop 1 (index sumas)))
  where
     f (a,b) = ((fromIntegral a)/ (fromIntegral ( b )))



--b)mayores


mapop:: [(Int,Int)]->[(Int,Int)]->Int
mapop [] xs = 0
mapop xs [] = 0
mapop (x:xs) (y:ys) = let 
  rec = (mapop xs ys) 
    in
    if (x==y)
    then 1+rec  
    else rec 

max2:: (Int,Int)->(Int,Int)->(Int,Int)
max2 (a,b) (a1,b1)  |(a>a1) = (a,b)
                    | (a1>a) = (a1,b1)
                    | otherwise = (a,(min b1 b))


mayores:: [Int] -> Int
mayores s = let
              s1 = (zip s [1..]) --zipeo secunecia con indices
              maximos = (scanl max2 (0,0) s1) --saco los maximos de las subsec con minimo indice
            in (mapop s1 (drop 1 maximos)) -1 --me fijo si coinciden en indice y valor con los (valor,indice)

mayores_profe:: [Int] -> Int
mayores s = let
   (maximos,total) = scanl max 0 s 
   in
    mayor s maximos
    where mayor xs ys = if (xs==[])||(ys==[]) then 0 else xs>

--4)
-- )a la i  (a la k esta mal

matchParent:: Seq paren -> Bool 
matchParent s = (matchP == (0,0))

comb:: (Int,Int)->(Int,Int)->(Int,Int)
comb (i,k) (i1,k1)| (k>=i1) = (i,k-i1+k1)
                  | otherwise = (i+i1-k,k1)

matchP:: Seq paren -> (Int,Int)
matchP s = case showt s of
  Empty = (0,0)
  Leaf x = if (x==y) then (0,1) else (1,0)
  Node l r = let (l1,r1) = (matchP l ||| matchP l) in
    comb l1 r1

