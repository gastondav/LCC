import ListSeq ()
import Seq
import Par

-- a)

sccml :: (Seq s, Ord a, Num a) => s a -> Int
sccml s = let resul = (\(a,b,c,d,e,f) -> a) (sccml_aux s)
            in resul - 1

sccml_aux :: (Seq s, Ord a, Num a) => s a -> (Int, a, Int, a, Int, Int)
sccml_aux s = case showtS s of    
              EMPTY -> (0, 0, 0, 0, 0, 0) 
              ELT x -> (1, x, 1, x, 1, 1)
              NODE l r -> let (sl, sr) = sccml_aux l ||| sccml_aux r 
                          in comb sl sr

comb :: (Ord a, Num a) => (Int, a, Int, a, Int, Int) -> (Int, a, Int, a, Int, Int) -> (Int, a, Int, a, Int, Int)
comb (m, fv, fl, lv, ll, lt) (m', fv', fl', lv', ll', lt') = 
            if lv < fv' 
                then let 
                        new_max = max (ll + fl') (max m m')
                        newfl = if (fl == lt) -- por *3
                                then ll + fl' 
                                else fl
                        newll = if (fv' < lv') || (ll' == lt') -- condicion 1 por este caso (al final del archivo *1)
                                then ll + fl'                  -- condicion 2 por *2
                                else  ll'
                        
                        in (new_max, fv, newfl, lv', newll, lt + lt')
                else let
                        new_max = max m m'
                        in (new_max, fv, fl, lv', ll', lt + lt')

-- (m, fv, fl, lv, ll, lt)
-- m : longitud de la subsecuencia maxima
-- fv : primer valor de la subsecuencia creciente del inicio de la secuencia
-- fl : longitud de la subsecuencia al inicio
-- lv : ultimo valor de la subsecuencia creciente del final de la secuencia
-- ll : longitud de la subsecuencia del final           
-- lt : largo total

-- b)

type Intervalo a = ((a, Int), (a, Int))

combine:: Ord a => Intervalo a -> Intervalo a -> Intervalo a
combine ((e1,i1), (e2, i2)) ((e1', i1'), (e2', i2')) = if (e2 < e1') && (i2 == i1' - 1)
                                                       then ((e1, i1), (e2', i2')) 
                                                       else ((e1', i1'), (e2', i2')) 

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
-- s'''  = [((9,0),(9,0)),((5,0),(5,0)),((5,0),(6,1)),((2,2),(2,2)),((2,2),(3,3)),((2,2),(5,4)),((1,5),(1,5)),((1,5),(9,6))]
-- s'''' = [0,0,1,0,1,2,0,1]

-- Salida: 2

sccml2 :: (Seq s, Ord a, Num a) => s a -> Int
sccml2 s = let s' = mapS (\a -> (a, a)) (index s)      -- intervalos unitarios
               maxs     = reduceS max 0 s              -- maximo de la secuencia
               z        = ((maxs, 0), (maxs, 0))       -- base
               (s'', u) = scanS combine z s'           -- saco la lista de sufijos crecientes maximos
               s'''     = appendS s'' (singletonS u) 
               s''''    = mapS (\((_, i),(_, j)) -> j - i) s''' --largos de los intervalos
            in reduceS max 0 s''''

-- a) ejemplos

-- [5,6,2,3,5,1,9]
-- (1,5,1,5,1,1) (1,6,1,6,1,1) (1,2,1,2,1,1)                    [5,6,2]
-- (1,3,1,3,1,1) (1,5,1,5,1,1) (1,1,1,1,1,1) (1,9,1,9,1,1)      [3,5,1,9]
-- comb (1,6,1,6,1,1) (1,2,1,2,1,1) = (1,6,1,2,1,2)     -> 6,2
-- comb (1,5,1,5,1,1) (1,6,1,2,1,2) = (2,5,2,2,1,3)     -> 5,6,2
-- comb (1,3,1,3,1,1) (1,5,1,5,1,1) = (2,3,2,5,1,2)     -> 3,5
-- comb (1,1,1,1,1,1) (1,9,1,9,1,1) = (2,1,2,9,1,2)     -> 1,9
-- comb (2,3,2,5,1,2) (2,1,2,9,1,2) = (2,3,2,9,1,4)     -> 3,5,1,9
-- comb (2,5,2,2,1,3) (2,3,2,9,1,4) = (3,5,2,9,3,7)     -> 5,6,2,3,5,1,9

-- [9,3,5,1,3,4,5,6,8,1]
-- [9,3,5,1,3]      [4,5,6,8,1]
-- [9,3] [5,1,3]    [4,5] [6,8,1]
--      [5] [1,3]         [6] [8,1]
-- (1,5,1,5,1,1) (1,1,1,1,1,1) (1,3,1,3,1,1) 
-- comb (1,1,1,1,1,1) (1,3,1,3,1,1) = (2,1,2,3,1,2)     -> 1,3 * aca ERROR
-- comb (1,5,1,5,1,1) (2,1,2,3,1,2) = (2,5,1,3,1,3)     -> 5,1,3
-- (1,9,1,9,1,1) (1,3,1,3,1,1) 
-- comb (1,9,1,9,1,1) (1,3,1,3,1,1) = (1,9,1,3,1,2)     -> 9,3
-- comb (1,9,1,3,1,2) (2,5,1,3,1,3) = (2,9,1,3,1,5)     -> 9,3,5,1,3


-- (1,6,1,6,1,1) (1,8,1,8,1,1) (1,1,1,1,1,1)
-- comb (1,8,1,8,1,1) (1,1,1,1,1,1) = (1,8,1,1,1,2)     -> 8,1
-- comb (1,6,1,6,1,1) (1,8,1,1,1,2) = (2,6,2,1,1,3)     -> 6,8,1
-- (1,4,1,4,1,1) (1,5,1,5,1,1)
-- comb (1,4,1,4,1,1) (1,5,1,5,1,1) = (2,4,2,5,1,2)     -> 4,5
-- comb (2,4,2,5,1,2) (2,6,2,1,1,3) = (3,4,3,1,1,5)     -> 4,5,6,8,1

-- comb (2,9,1,3,1,5) (3,4,3,1,1,5) = (4,9,1,1,1,10)    -> 9,3,5,1,3,4,5,6,8,1

-- *1
-- si tengo este caso 1...3...5...7    9...12...8...15
-- en este caso tengo union porque 7 es menor que 9
-- entonces la tupla va a ser algo asi (max, 1, algo, 15, algo2)
-- veo que si 8 fuera mayor que 12 entonces algo2 tiene que aumentar

-- *2
-- si la secuencia del final es toda la secuencia entonces el largo de la secuencia del final tiene que aumentar

-- *3
-- si la secuencia del inicio es toda la secuencia entonces el largo de la secuencia del inicio tiene que aumentar
