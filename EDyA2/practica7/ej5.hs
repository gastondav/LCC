import ListSeq ()
import Seq
import Par

{- sccml :: Seq Int -> Int 
sccml s = case (showT s) of 
    Node l r -> let (sl, sr) = sccml l || sccml r
    E ->
    L x ->  

auxiliar :: Seq Int -> (Int, Int, Int,) 
 -}

-- b)

type Intervalo a = ((a, Int), (a, Int))

combine:: Ord a => Intervalo a -> Intervalo a -> Intervalo a
combine ((e1,i1), (e2, i2)) ((e1', i1'), (e2', i2')) = if (e2 < e1') && (i2 == i1' - 1)
                                                       then ((e1, i1), (e2', i2')) 
                                                       else ((e1', i1'), (e2', i2')) 

-- <1,2,3,1,4,5,2,6>
-- scan toma
-- <1>
-- <1,2>
-- <1,2,3> -> 3
-- <1,2,3,1> -> 1
-- <1,2,3,1,4,5> -> 3 debería tomar este con la secuencia 1,4,5
-- <1,2,3,1,4,5,2,6> -> 2

index :: Seq s => s a -> s (a, Int)
index s = tabulateS f (lengthS s)
          where 
            f i = (nthS s i, i)

-- Entrada: [5,6,2,3,5,1,9]
-- index = [(5,0),(6,1),(2,2),(3,3),(5,4),(1,5),(9,6)]
-- s' = [((5,0),(5,0)),((6,1),(6,1)),((2,2),(2,2)),((3,3),(3,3)),((5,4),(5,4)),((1,5),(1,5)),((9,6),(9,6))]
-- z = ((9, 0), (9, 0))
-- s'' = ([((9,0),(9,0)),((5,0),(5,0)),((5,0),(6,1)),((2,2),(2,2)),((2,2),(3,3)),((2,2),(5,4)),((1,5),(1,5))], 
--        ((1,5),(9,6)))

sccml2 :: (Seq s, Ord a, Num a) => s a -> Int
sccml2 s = let s' = mapS (\a->(a, a)) (index s)      -- intervalos unitarios
               maxs     = reduceS max 0 s            -- maximo de la secuencia
               z        = ((maxs, 0), (maxs, 0))     -- base
               (s'', u) = scanS combine z s'         -- saco la lista de sufijos crecientes maximos
               s'''     = appendS s'' (singletonS u) 
               s''''    = mapS (\((_, i),(_, j)) -> j - i) s''' --largos de los intervalos
            in reduceS max 0 s''''
