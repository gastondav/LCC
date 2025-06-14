--EJERCICIO 2

data Linea = T [Char] Int deriving Show

vacia :: Linea
vacia = T [] 0

moverIzq :: Linea -> Linea
moverIzq (T xs 0) = T xs 0
moverIzq (T xs k) = T xs (k-1) 

largo :: Linea -> Int
largo (T [] n) = 0 
largo (T (x:xs) n) = 1 + largo (T xs n) 

moverDer :: Linea -> Linea
moverDer (T xs n) | n == largo (T xs n) = (T xs n)
                  | otherwise = moverDer (T xs (n+1))

moverIni :: Linea -> Linea
moverIni (T xs n) | n == 0 = (T xs 0)
                  | otherwise = moverIni (T xs (n-1)) 

moverFin :: Linea -> Linea
moverFin (T xs n) | n == largo (T xs n) = (T xs n)
                  | otherwise = moverFin (T xs (n+1))

borrar :: Linea -> Linea
borrar (T xs 0) = (T xs 0)
borrar (T xs n) = (T (borrar_aux xs n) (n-1))

borrar_aux :: [Char] -> Int -> [Char] 
borrar_aux [] n = []
borrar_aux (x:xs) n | n-1 == 0 = xs
                    | otherwise = x : (borrar_aux xs (n-1)) 

insertar :: Char -> Linea -> Linea
insertar c (T xs 0) = (T (c : xs) 1)
insertar c (T xs n) = (T (insertar_aux c xs n) (n+1))

insertar_aux :: Char -> [Char] -> Int -> [Char]
insertar_aux c [] n = []
insertar_aux c (x:xs) n | n == 0 = c : x : xs
                        | otherwise = x : (insertar_aux c xs (n-1)) 