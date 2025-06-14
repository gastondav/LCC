--PRACTICA 2

--EJERCICIO 11

--a)

modulus = sqrt . sum . map (**2)

--b)

vmod []     = []
vmod (v:vs) = modulus v : vmod vs

--EJERCICIO 12

type NumBin = [Bool]

--a)

suma_binaria :: NumBin -> NumBin -> NumBin
suma_binaria as bs = suma_binaria_aux as bs False 

suma_binaria_aux :: NumBin -> NumBin -> Bool -> NumBin
suma_binaria_aux []      [] False = []
suma_binaria_aux []      [] True  = [True]
suma_binaria_aux (a:as)  [] False = a : as 
suma_binaria_aux (a:as)  [] True  | (a == True) = False : suma_binaria_aux as [] True
suma_binaria_aux (a:as)  [] True  | (a == False) = True : suma_binaria_aux as [] False      
suma_binaria_aux []  (b:bs) False = b : bs 
suma_binaria_aux []  (b:bs) True  | (b == True) = False : suma_binaria_aux bs [] True
suma_binaria_aux []  (b:bs) True  | (b == False) = True : suma_binaria_aux bs [] False 
suma_binaria_aux (a:as) (b:bs) False | a == False && b == False = False : suma_binaria_aux as bs False  
                                     | a == True && b == True = False : suma_binaria_aux as bs True
                                     | otherwise = True : suma_binaria_aux as bs False
suma_binaria_aux (a:as) (b:bs) True  | a == False && b == False = True : suma_binaria_aux as bs False  
                                     | a == True && b == True = True : suma_binaria_aux as bs True
                                     | otherwise = False : suma_binaria_aux as bs True                                     
           

--b)

--operaciones de multiplicacion entre dos bits
mult_dos :: Bool -> Bool -> Bool
mult_dos True True = True
mult_dos _    _    = False

--multiplicacion entre un numero y un digito binario
-- 10101010 x 1 
producto_binario_aux :: NumBin -> Bool -> NumBin
producto_binario_aux []     _ = []
producto_binario_aux (a:as) True = mult_dos a True : producto_binario_aux as True
producto_binario_aux (a:as) False = mult_dos a False : producto_binario_aux as False

producto_binario :: NumBin -> NumBin -> NumBin
producto_binario []     []     = []
producto_binario (a:as) []     = []
producto_binario (a:as) (b:bs) = suma_binaria (producto_binario_aux (a:as) b) (False : producto_binario (a:as) bs)

--c)

div_dos :: NumBin -> NumBin
div_dos [] = []
div_dos (a:as) = as

div_dos_resto :: NumBin -> Bool
div_dos_resto [] = False
div_dos_resto (a:as) = a


--EJERCICIO 13

--a)

divisors :: Int -> [Int]
divisors n | n < 0 = []
divisors n = [ x | x <- [1..n] , mod n x == 0]

--b)
matches :: Int -> [Int] -> [Int]
matches n xs = [ x | x <- xs, not (n == x)]

--c)
cuadrupla::Int -> [(Int, Int, Int, Int)]
cuadrupla n = [ (a,b,c,d) | a <- [0..n], b <- [0..n], c <- [0..n], d <- [0..n]
              , a * a + b * b == c * c + d * d ] 

--d)

unique :: [Int] -> [Int]
unique xs = [x | (x, i) <- zip xs [0..], no_esta x (primeros_i i xs)]

no_esta :: Int -> [Int] -> Bool
no_esta n [] = True
no_esta n (x:xs) | n == x = False
                 | otherwise = no_esta n xs

primeros_i :: Int -> [Int] -> [Int]
primeros_i n xs = [x | (x,i) <- zip xs [0..(n-1)]] 

--EJERCICIO 14
scalarProduct :: [Int] -> [Int] -> Int
scalarProduct xs ys = sum [ x*y | (x,y) <- zip xs ys]