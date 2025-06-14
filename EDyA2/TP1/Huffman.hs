module Huffman where

import Data.Map as DM (Map, fromList, insertWith, toList, union, lookup)
import Heap

{-
Integrantes grupo:
- Piro Mateo
- Gastón Dávalos
- 

-}

-- Bits y códigos

data Bit = Zero | One deriving (Eq, Show)

type Code = [Bit]

-- Árbol de codificación

data HTree = Leaf Char Int
           | Node HTree HTree Int
           deriving Show

weight :: HTree -> Int
weight (Leaf _ w)   = w
weight (Node _ _ w) = w

-- Diccionarios de frecuencias y códigos

type FreqMap = Map Char Int

type CodeMap = Map Char Code


-- Ejercicio 1
instance Eq HTree where
    (Leaf c1 i1) == (Leaf c2 i2) = (i1 == i2)
    (Node h1 h2 i1) == (Leaf c2 i2) = (i1 == i2)
    (Leaf c1 i1) == (Node h3 h4 i2) = (i1 == i2)
    (Node h1 h2 i1) == (Node h3 h4 i2) = (i1 == i2)

instance Ord HTree where
    (Leaf c1 i1) <= (Leaf c2 i2) = (i1 <= i2)
    (Node h1 h2 i1) <= (Leaf c2 i2) = (i1 <= i2)
    (Leaf c1 i1) <= (Node h3 h4 i2) = (i1 <= i2)
    (Node h1 h2 i1) <= (Node h3 h4 i2) = (i1 <= i2)



-- Ejercicio 2

buildFreqMap :: String -> FreqMap
buildFreqMap []     = fromList [] 
buildFreqMap (x:xs) = insertWith (+) x 1 (buildFreqMap xs)



-- Ejercicio 3

buildHTree :: FreqMap -> HTree
buildHTree freq = buildHTree_aux (map consHtree (ordenar_dic (toList freq) [])) 
                where consHtree (c,i)  = Leaf c i 

--Ordeno la lista de los pares clave-valor en orden creciente por la clave
ordenar_dic :: [(Char, Int)] -> [(Char,Int)] -> [(Char, Int)]
ordenar_dic [] []           = []
ordenar_dic [] ys           = ys
ordenar_dic (x:xs) []       = ordenar_dic xs [x] 
ordenar_dic ((c1,v1):xs) ys = ordenar_dic xs (insertar_ordenado ys (c1,v1)) 

--Inserta un par (Char, Int) en una lista de [(Char, Int)] segun el valor de Int en orden creciente 
insertar_ordenado :: [(Char, Int)] -> (Char, Int) -> [(Char, Int)]
insertar_ordenado [] x                 = [x]
insertar_ordenado ((c1,v1):xs) (c2,v2) = if v1 > v2 then (c2,v2):(c1,v1):xs
                                                    else (c1,v1):(insertar_ordenado xs (c2,v2))

--Crea un HTree a partir de una lista de HTree de forma que siempre toma los dos primeros de menos peso
--ya que la lista esta ordenada
buildHTree_aux:: [HTree] -> HTree
buildHTree_aux []       = error "BuildHtree: no se ingresaron datos" 
buildHTree_aux [x]      = x
buildHTree_aux (x:y:xs) = let w1 = weight x
                              w2 = weight y in buildHTree_aux (ins_aux (Node x y (w1+w2)) xs )

-- Inserta un HTree a una lista de HTree de forma ordenada, en orden creciente
ins_aux:: HTree -> [HTree] -> [HTree]
ins_aux ht []     = [ht]
ins_aux ht (x:xs) = if (weight ht > weight x) then x:(ins_aux ht xs) else (ht:x:xs)



-- Ejercicio 4

buildCodeMap :: HTree -> CodeMap
buildCodeMap ht = buildCodeMap_aux [] ht where

buildCodeMap_aux xs (Node h1 h2 i)    = union (buildCodeMap_aux (xs++[Zero]) h1) (buildCodeMap_aux (xs++[One]) h2)
buildCodeMap_aux codigo (Leaf char i) =  fromList [(char,codigo)]

-- Ejercicio 5
isNothing :: Maybe a ->Bool
isNothing Nothing = True
isNothing _ = False

fromJust:: Maybe a -> a
fromJust (Just a) = a
fromJust _ = error "fromJust: no se a ingresado un dato tipo Just a"

encode :: CodeMap -> String -> Code
encode codM [] = []
encode codM (x:xs) = let look = (DM.lookup x codM) in
                        if (isNothing look) then (error ("encode: No se encontró el caracter " ++ [x]))
                                            else (fromJust look) ++ (encode codM xs)

-- Ejercicio 6

decode :: HTree -> Code -> String
decode ht cod = decode_aux ht ht cod where

decode_aux ht (Leaf c i) []            = [c]
decode_aux ht (Leaf c i) s             = c : (decode_aux ht ht s)
decode_aux ht (Node h1 h2 i) (Zero:xs) = decode_aux ht h1 xs
decode_aux ht (Node h1 h2 i) (One:xs)  = decode_aux ht h2 xs
decode_aux ht (Node h1 h2 i) []        = error "decode: codigo no en el hTree"



-- Ejercicio 7

engFM :: FreqMap
engFM = fromList [
    ('a', 691),
    ('b', 126),
    ('c', 235),
    ('d', 360),
    ('e', 1074),
    ('f', 188),
    ('g', 170),
    ('h', 515),
    ('i', 589),
    ('j', 13),
    ('k', 65),
    ('l', 340),
    ('m', 203),
    ('n', 571),
    ('o', 635),
    ('p', 163),
    ('q', 8),
    ('r', 506),
    ('s', 535),
    ('t', 766),
    ('u', 233),
    ('v', 83),
    ('w', 200),
    ('x', 13),
    ('y', 167),
    ('z', 6),
    (' ', 1370),
    (',', 84),
    ('.', 89)
    ]


cincobits:: CodeMap
cincobits = let bin = [Zero,One] in
             fromList (zip "abcdefghijklmnopqrstuvwxyz ,." [[x,y,z,w,v]|x<-bin,y<-bin,z<-bin,w<-bin,v<-bin])


texts :: [String]
texts = 
  [ "it was the best of times it was the worst of times it was the age of wisdom it was the age of foolishness" -- Dickens
  , "to be or not to be that is the question whether tis nobler in the mind to suffer"                           -- Shakespeare
  , "in the beginning god created the heaven and the earth"                                                     -- Bible (Genesis)
  , "the only thing we have to fear is fear itself"                                                             -- FDR
  , "i have a dream that one day this nation will rise up and live out the true meaning of its creed"           -- MLK Jr.
  , "the earth is a very small stage in a vast cosmic arena. think of the rivers of blood spilled by all those generals and emperors so that in glory and triumph they could become the momentary masters of a fraction of a dot. think of the endless cruelties visited by the inhabitants of one corner of this pixel on the scarcely distinguishable inhabitants of some other corner. how frequent their misunderstandings, how eager they are to kill one another, how fervent their hatreds." -- Carl Sagan
  , "the quick brown fox jumps over the lazy dog"                                                               -- Pangram
  , "all animals are equal but some animals are more equal than others"                                         -- Orwell
  , "that which does not kill us makes us stronger"                                                             -- Nietzsche
  , "there is nothing either good or bad but thinking makes it so"                                              -- Shakespeare
  ]

diff :: [Int]
diff = let codehuff = (buildCodeMap (buildHTree engFM)) in 
        [(lbits - lht) | x <- texts, let lbits = length (encode cincobits x), let lht = length (encode codehuff x)]

diff_porcentaje :: [Float]
diff_porcentaje = let codehuff = (buildCodeMap (buildHTree engFM)) in 
        [  (fromIntegral  ((lbits -lht)*100) / fromIntegral  lbits)  | x <- texts, let lbits = length (encode cincobits x), let lht = length (encode codehuff x)]

{-
    El resultado de la comparacion son los siguientes 

    diff = [102,80,56,43,91,402,2,49,34,52]

    Conclusion: Vemos que los codificaciones usando 5 bits fijos por caracter siempre es mayor
    que las codificaciones usando el algoritmo de Huffman, pero esta diferencia se asentua en el caso
    del parrafo de Carl Sagan. Con lo cual, si bien usar una codificacion de 5 bits es mucho mas simple,
    la codificacion de Huffman es mucho mas eficiente y lo es cada vez mas a medida que incrementa 
    el largo del texto a codificar.

-}