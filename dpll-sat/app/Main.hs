module Main where

import Parser
import System.Environment

--import Sat

main :: IO ()
main = do
  args <- getArgs
  contents <- readFile (head args)
  let expr = dimacsToProp contents in print expr
  --  print $ dpll expr;
