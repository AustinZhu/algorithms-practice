module Sat
  (
  )
where

import Control.Applicative ((<|>))
import Type

select :: Prop -> Maybe Int
select p = case p of
  Val _ -> Nothing
  Var i -> Just i
  Not (Var i) -> Just i
  And p1 p2 -> select p1 <|> select p2
  Or p1 p2 -> select p1 <|> select p2

assign :: Prop -> Int -> Bool -> Prop
assign p n b = case p of
  Var i -> if i == n then Val b else p
  Not (Var i) -> if i == n then Val (not b) else p
  And p1 p2 -> And (assign p1 n b) (assign p2 n b)
  Or p1 p2 -> Or (assign p1 n b) (assign p2 n b)
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

-- todo
pureLiteralAssign :: Prop -> Prop
pureLiteralAssign p = case select p of
  Just i -> tryAssign p i
  Nothing -> p
  where
    tryFind p' n s = case p' of
      Var i -> if i == n && s then Just i else Nothing
      Not (Var i) -> if i == n && not s then Just i else Nothing
      Or p1 p2 -> tryFind p1 n s <|> tryFind p2 n s
      And p1 p2 -> tryFind p1 n s <|> tryFind p2 n s
    tryAssign p' n = tryFind p' n True
--
--dpll :: Prop -> Bool
--dpll p = True
