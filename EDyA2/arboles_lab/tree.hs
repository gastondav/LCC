module Lab02 where
{-
   Laboratorio 2
   EDyAII 2022
-}

import Data.List

-- 1) Dada la siguiente definición para representar árboles binarios:

data BTree a = E | Leaf a | Node (BTree a) (BTree a)

-- Definir las siguientes funciones:

-- a) altura, devuelve la altura de un árbol binario.

altura :: BTree a -> Int
altura E = 0
altura (Leaf a) = 0
altura (Node t1 t2) = 1 + max (altura t1) (altura t2)

-- b) perfecto, determina si un árbol binario es perfecto (un árbol binario es perfecto si cada nodo tiene 0 o 2 hijos
-- y todas las hojas están a la misma distancia desde la raı́z).

es_hoja :: BTree a -> Bool
es_hoja E = False
es_hoja (Leaf a) = True
es_hoja (Node t1 t2) = False

perfecto :: BTree a -> Bool
perfecto E = True
perfecto (Leaf a) = True
perfecto (Node t1 t2) | (altura t1) == (altura t2) = 
                        if (es_hoja t1 == False && es_hoja t2 == False) 
                        then True && perfecto t1 && perfecto t2 
                        else
                            if (es_hoja t1 == True && es_hoja t2 == True) 
                            then True
                            else False  
                      | otherwise = False

perfecto2 :: BTree a -> Bool
perfecto2 E = True
perfecto2 (Leaf a) = True
perfecto2 (Node l r) = perfecto2 l && perfecto2 r && (altura l == altura r)

-- c) inorder, dado un árbol binario, construye una lista con el recorrido inorder del mismo.

inorder :: BTree a -> [a]
inorder E = []
inorder (Leaf a) = [a]
inorder (Node t1 t2) = inorder t1 ++ inorder t2

-- 2) Dada las siguientes representaciones de árboles generales y de árboles binarios (con información en los nodos):

data GTree a = EG | NodeG a [GTree a]

data BinTree a = EB | NodeB (BinTree a) a (BinTree a) deriving Show

{- Definir una función g2bt que dado un árbol nos devuelva un árbol binario de la siguiente manera:
   la función g2bt reemplaza cada nodo n del árbol general (NodeG) por un nodo n' del árbol binario (NodeB ), donde
   el hijo izquierdo de n' representa el hijo más izquierdo de n, y el hijo derecho de n' representa al hermano derecho
   de n, si existiese (observar que de esta forma, el hijo derecho de la raı́z es siempre vacı́o).
   
   NodeG 1 (NodeG 2 EG)
   

   Por ejemplo, sea t: 
       
                    A 
                 / | | \
                B  C D  E
               /|\     / \
              F G H   I   J
             /\       |
            K  L      M    
   
   g2bt t =
         
                  A
                 / 
                B 
               / \
              F   C 
             / \   \
            K   G   D
             \   \   \
              L   H   E
                     /
                    I
                   / \
                  M   J  
-}

g2bt :: GTree a -> BinTree a
g2bt EG               = EB
g2bt (NodeG a [])     = (NodeB EB a EB)
g2bt (NodeG a (x:xs)) = g2bt_aux (NodeG a (x:xs)) []
    
--(NodeB (g2bt_aux x xs) a EB)

g2bt_aux :: GTree a -> [GTree a] -> BinTree a
g2bt_aux EG _                    = EB
g2bt_aux (NodeG a []) []         = (NodeB EB a EB)
g2bt_aux (NodeG a []) (y:ys)     = (NodeB EB a (g2bt_aux y ys))
g2bt_aux (NodeG a (x:xs)) []     = (NodeB (g2bt_aux x xs) a EB)
g2bt_aux (NodeG a (x:xs)) (y:ys) = (NodeB ((g2bt_aux x xs)) a (g2bt_aux y ys)) 

inorder2 :: BinTree a -> [a]
inorder2 EB = []
inorder2 (NodeB t1 a t2) = (inorder2 t1) ++ [a] ++ (inorder2 t2)

--SOLUCION DE LA PROFE
g2btprofe :: GTree a -> BinTree a
g2btprofe t = g2btprofe_aux t []

g2btprofe_aux :: GTree a -> [GTree a] -> BinTree a   
g2btprofe_aux EG _ = EB
g2btprofe_aux (NodeG x [])     [] = (NodeB EB x EB)     -- SIN HIJOS NI HERMANOS
g2btprofe_aux (NodeG x (y:ys)) [] = (NodeB (g2btprofe_aux y ys) x EB)   --CON HIJOS, SIN HERMANOS
g2btprofe_aux (NodeG x (y:ys)) (t:ts) = (NodeB (g2btprofe_aux y ys) x (g2btprofe_aux t ts)) --CON HIJOS Y HERMANOS

--OTRA SOLUCION 
aux :: [GTree a] -> BinTree a 
aux (EG:ts) = aux ts
aux ( (NodeG x xs):ts) = (NodeB (aux xs) x (aux ts) )

g2btprofe2 :: GTree a -> BinTree a
g2btprofe2 EG = EB
g2btprofe2 (NodeG x ts) = NodeB (aux ts) x EB

-- 3) Utilizando el tipo de árboles binarios definido en el ejercicio anterior, definir las siguientes funciones: 
{-
   a) dcn, que dado un árbol devuelva la lista de los elementos que se encuentran en el nivel más profundo 
      que contenga la máxima cantidad de elementos posibles. Por ejemplo, sea t:
            1
          /   \
         2     3
          \   / \
           4 5   6
                             
      dcn t = [2, 3], ya que en el primer nivel hay un elemento, en el segundo 2 siendo este número la máxima
      cantidad de elementos posibles para este nivel y en el nivel tercer hay 3 elementos siendo la cantidad máxima 4.
   -}

--data BinTree a = EB | NodeB (BinTree a) a (BinTree a) deriving Show

--Devuelve TRUE si no es hoja
not_es_hoja :: BinTree a -> Bool
not_es_hoja EB = False
not_es_hoja _  = True 

dcn :: BinTree a -> [a]
dcn t = dcn_aux t (ultimo_nivel t)

dcn_aux :: BinTree a -> Int -> [a]
dcn_aux EB _ = []
dcn_aux (NodeB t1 a t2) 0 = [a]
dcn_aux (NodeB t1 a t2) n = (dcn_aux t1 (n-1)) ++ (dcn_aux t2 (n-1))


{- b) maxn, que dado un árbol devuelva la profundidad del nivel completo
      más profundo. Por ejemplo, maxn t = 2   -}

--Devuelve el ultimo nivel completo donde un arbol vacio y con un nodo son ambos de nivel 0
maxn :: BinTree a -> Int
maxn EB = 0
maxn (NodeB EB a EB) = 0
maxn (NodeB t1 a t2) = if (not_es_hoja t1 == True) && (not_es_hoja t2 == True) 
                                 then 1 + (div (maxn t1 + maxn t2) 2)
                                 else 0

{- c) podar, que elimine todas las ramas necesarias para transformar
      el árbol en un árbol completo con la máxima altura posible. 
      Por ejemplo,
         podar t = NodeB (NodeB EB 2 EB) 1 (NodeB EB 3 EB)
-}

podar :: BinTree a -> BinTree a
podar t = podar_aux t (ultimo_nivel t)

podar_aux :: BinTree a -> Int-> BinTree a
podar_aux EB _ = EB
podar_aux (NodeB t1 a t2) 0 = (NodeB EB a EB)
podar_aux (NodeB t1 a t2) n = (NodeB (podar_aux t1 (n-1)) a (podar_aux t2 (n-1)) )
