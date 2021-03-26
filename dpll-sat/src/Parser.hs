module Parser
  ( dimacsToProp,
  )
where

import Control.Monad (ap)
import Text.Parsec.Prim
import Text.Parsec.String
import Text.Parsec.Token
import Text.ParserCombinators.Parsec.Combinator
import Type

dimacsDef :: LanguageDef st
dimacsDef =
  LanguageDef
    { commentStart = "",
      commentEnd = "",
      commentLine = "c",
      nestedComments = False,
      identStart = unexpected "No identifier",
      identLetter = unexpected "No identifier",
      opStart = unexpected "No operator",
      opLetter = unexpected "No operator",
      reservedNames = ["p", "cnf"],
      reservedOpNames = [],
      caseSensitive = True
    }

dimacsTokenParser :: TokenParser st
dimacsTokenParser = makeTokenParser dimacsDef

int :: Parser Int
int = fmap fromInteger (integer dimacsTokenParser)

nat :: Parser Int
nat = fmap fromInteger (natural dimacsTokenParser)

lexer :: Parser a -> Parser a
lexer = lexeme dimacsTokenParser

sym :: String -> Parser String
sym = symbol dimacsTokenParser

parseHeader :: Parser (Int, Int)
parseHeader = do
  _ <- sym "p"
  _ <- sym "cnf"
  fmap (,) nat `ap` nat

parseClause :: Parser [Int]
parseClause = lexer int `manyTill` try (sym "0")

parseCnf :: Parser [[Int]]
parseCnf = lexer (many parseClause)

parseDimacs :: Parser Dimacs
parseDimacs = do
  whiteSpace dimacsTokenParser
  fmap (uncurry Dimacs) parseHeader `ap` parseCnf

dimacsToProp :: String -> Prop
dimacsToProp s = foldl1 And clauses
  where
    toVar n = if n > 0 then Var n else Not (Var n)
    parsed = case parse parseDimacs "" s of
      Left e -> error (show e)
      Right a -> map (map toVar) $ cnf a
    clauses = map (foldl1 Or) parsed
