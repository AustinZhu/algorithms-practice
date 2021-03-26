module Sat
  (
  )
where

import Control.Applicative ((<|>))
import Type

select :: Prop -> Maybe Int
select p = case p of
  Val b -> Nothing
  Var i -> Just i
  Not (Var i) -> Just i
  And p1 p2 -> search p1 <|> search p2
  Or p1 p2 -> search p1 <|> search p2

assign :: Prop -> Int -> Bool -> Prop
assign p n b = case p of
  Var i -> if i == n then Val b else p
  Not (Var i) -> if i == n then Val (not b) else p
  And p1 p2 -> And (assign p1 i b) (assign p2 i b)
  Or p1 p2 -> Or (assign p1 i b) (assign p2 i b)
  _ -> p

simplify :: Prop -> Prop
simplify p = case p of
  And (Val b) p2 -> if b then simplify p2 else Val False
  And p1 (Val b) -> if b then simplify p1 else Val False
  And p1 p2 -> And (simplify p1) (simplify p2)
  Or (Val b) p2 -> if b then Val True else simplify p2
  Or p1 (Val b) -> if b then Val True else simplify p1
  Or p1 p2 -> Or (simplify p1) (simplify p2)
  _ -> p

unitPropagate :: Prop -> Prop
unitPropagate p = case p of
  Var i -> assign p i True
  Not (Var i) -> assign p i False
  And p1 p2 -> case p1 of
    Var i -> simplify $ And (Val True) (assign (unitPropagate p2) i True)
    Not (Var i) -> simplify $ And (Val False) (assign (unitPropagate p2) i False)
    _ -> And p1 (unitPropagate p2)
  _ -> p

pureLiteralAssign :: Prop -> Prop
pureLiteralAssign p = case select p of
  Just i -> tryAssign p i
  Nothing -> p
  where
    tryAssign p i = case p of

dpll :: Prop -> Bool
