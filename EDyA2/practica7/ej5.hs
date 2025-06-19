sccml :: Seq Int -> Int 
sccml s = case (showT s) of 
    Node l r -> let (sl, sr) = sccml l || sccml r
    E ->
    L x ->  

auxiliar :: Seq Int -> (Int, Int, Int,) 

-- con scan
type Intervalo a = ((a,Int),(a,Int))

combine:: Ord a => Intervalo a -> Intervalo a -> Intervalo a
combine ((e1,i1),(e2,i2)) ((e3,i3),(e4,i4)) = if (e2<e3) && (i2 == i3-1)
                                                 then ((e1,i1),(e4,i4)) else ((e3,i3),(e4,i4)) 

-- <1,2,3,1,4,5,2,6>
-- scan toma
-- <1>
-- <1,2>
-- <1,2,3> -> 3
-- <1,2,3,1> -> 1
-- <1,2,3,1,4,5> -> 3 debería tomar este con la secuencia 1,4,5
-- <1,2,3,1,4,5,2,6> -> 2

index = tabulateS (\i->((nthS i s),i))

sccml2:: (Seq s,Ord a) => S a -> Int
sccml2 s = let s1= maps (\a->(a,a)) (index s), --intervalos unitarios
                    maxs = reduceS max 0,
                    z = ((maxs s,0),(maxs s,0)),
                    (s2,u) = scan combine z s1, -- saco la lista de sufijos crecientes maximos
                    s3 = append s2 (singleton u),
                    s4 = mapS (\((_,i),(_,j)) -> j -i) s3 --largos de los intervalos
                    in reduceS max 0 s4 

