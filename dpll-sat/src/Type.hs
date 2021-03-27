module Type
  ( Prop (..),
    Dimacs (..),
  )
where

data Dimacs = Dimacs
  { varCount :: Int,
    clauseCount :: Int,
    cnf :: [[Int]]
  }

data Prop = Var Int | And Prop Prop | Or Prop Prop | Not Prop | Val Bool deriving (Eq, Show)
