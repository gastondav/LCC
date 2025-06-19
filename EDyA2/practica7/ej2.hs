crearSec :: Int -> [(Int, Int, Int, Int)]
crearSec 1 = [(1, 1, 1, 0)]
crearSec n = (1, 1, 1, 0) : crearSec (n - 1) 

mulMat :: (Int, Int, Int, Int) -> (Int, Int, Int, Int) -> (Int, Int, Int, Int)
mulMat (a, b, c, d) (e, f, g, h) = (a*e + b*g , a*f + b*h,
                                    c*e + d*g , c*f + d*h)

tomarFib :: (Int, Int, Int, Int) -> Int
tomarFib (a, _, _, _) = a

fibSeq :: Int -> [Int]
fibSeq n = let s    = crearSec n  
               s'   = scanl mulMat (1, 0, 0, 1) s 
               s''  = map tomarFib s'
               s''' = [0] ++ s''
               in take n s'''
               