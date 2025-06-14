--ej5)

data Color = R | B deriving Show

data RBT a = Emp | T Color a (RBT a) (RBT a) deriving Show

data T123 a = E
            | N1 a (T123 a) (T123 a)
            | N2 a a (T123 a) (T123 a) (T123 a)
            | N3 a a a (T123 a) (T123 a) (T123 a) (T123 a)

trans :: RBT a -> T123 a
trans Emp = E
trans (T B x (T R y h1 h2) (T R z h3 h4)) = N3 y x z (trans h1) (trans h2) (trans h3) (trans h4)
trans (T B x (T R y h1 h2) h3)            = N2 y x (trans h1) (trans h2) (trans h3)
trans (T B x h1 (T R y h2 h3))            = N2 x y (trans h1) (trans h2) (trans h3)
trans (T B x h1 h2)                     = N1 x (trans h1) (trans h2)