import Data.List
import Data.Char (ord)

--ej2
--a)
five :: a -> Int
five _ = 5


--b)
apply :: (a -> b) -> a -> b
apply f x = f x

--c)
ident :: a -> a
ident a = a

--d)
first :: (a,b) -> a
first (a,b) = a

--e)

--f)
sign :: (Num a, Eq a, Ord a) => a -> a
sign a 
    |a > 0 = 1
    |a == 0 = 0
    |otherwise = -1

--g)
vabs :: (Num a, Eq a, Ord a) => a -> a
vabs a
    |a >= 0 = a
    |otherwise = -a

--h) 
pot ::(Num a, Eq a, Ord a)=> a -> a -> a
pot a 0 = 1
pot a b = a * pot a (b-1) 

--i)
xor :: Bool -> Bool -> Bool
xor True False = True
xor False True = True
xor _ _ = False

--j) 
max3 :: (Num a, Eq a, Ord a) => a -> a -> a -> a
max3 a b c 
    |(a > b) && (a > c) = a
    |(b > c) = b
    |(c > b) = c
    |otherwise = a 

--k)
swap :: (a,b) -> (b,a)
swap (a,b) = (b,a)

--ej3

esBisiesto :: Int -> Bool
esBisiesto n = (mod n 4 == 0) && (mod n 100 /= 0 || mod n 400 == 0)

--ej4

(*$) :: Num a => [a] -> a -> [a] 
(*$) [] b = []
(*$) (x:xs) b = (x * b) : (*$) xs b 

--ej5

--a)

divisors:: Int -> [Int]
divisors n = [x | x <- [1..n], mod n x == 0]

--b)

matches::Int -> [Int] -> [Int]
matches a xs = [x | x <- xs, x == a]

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

--6)

scalarProduct:: [Int] -> [Int] -> Int
scalarProduct xs ys = sum [ a * b | (a, b) <- zip xs ys]

--ej7

--a)

suma :: Num a => [a] -> a
suma [] = 0
suma (x: xs) = x + suma xs

--b)

alguno :: [Bool] -> Bool
alguno [] = False
alguno (x:xs) | x == True = True 
              | otherwise = alguno xs

--c)

todos :: [Bool] -> Bool
todos [] = True
todos (x:xs) | x == True = True && todos xs 
             | otherwise = False

--d)

codes :: [Char] -> [Int]
codes [] = []
codes (x:xs) = ord x : codes xs

--e)

restos :: [Int] -> Int -> [Int]
restos xs n = [ mod x n | x <- xs]

--f)

cuadrados :: [Int] -> [Int]
cuadrados xs = [ x*x | x <- xs]

--g)

longitudes :: [[t]] -> [Int]
longitudes xss = [ largo xs | xs <- xss]

largo :: [t] -> Int
largo [] = 0
largo (x:xs) = 1 + largo xs 

--h)

orden :: [(Int, Int)] -> [(Int, Int)] 
orden xs = [(a,b)| (a,b) <- xs, a < b * 3]

--i)

pares :: [Int] -> [Int]
pares xs = [a | a <- xs,  mod a 2 == 0]

--j)

letras :: [Char] -> [Char]
letras xs = [ a | a <- xs, (a <= 'z' && a >= 'a') || ( a <= 'Z' && a >= 'A')]

--k)

masDe :: [[a]] -> Int -> [[a]]
masDe xss n = [ xs | xs <- xss, (largo xs) > n]

