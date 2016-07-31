module Brainfuck where

import Data.Char (chr, ord)

data Tape = Tape [Int] Int [Int]

newState :: Tape
newState = Tape [] 0 []

eval :: Tape -> Char -> IO Tape
eval (Tape rs p [])     '>' = return $ Tape (p:rs) 0 []
eval (Tape rs p (l:ls)) '>' = return $ Tape (p:rs) l ls
eval (Tape [] p ls)     '<' = return $ Tape [] 0 (p:ls)
eval (Tape (r:rs) p ls) '<' = return $ Tape rs r (p:ls)
eval (Tape rs p ls)     '+' = return $ Tape rs (p + 1) ls
eval (Tape rs p ls)     '-' = return $ Tape rs (p - 1) ls
eval tape@(Tape _ p _)  '.' = putChar (chr p) >> return tape
eval (Tape rs _ ls)     ',' = getChar >>= write
  where write c = return $ Tape rs (ord c) ls
eval tape                 _ = return tape -- ignore all other character

evalString :: Tape -> String -> IO Tape
evalString tape "" = return tape
evalString tape@(Tape _ 0 _) ('[':ss) = evalString tape (jumpToAfterPair ss)
evalString tape sss@('[':ss) = evalString tape ss >>= flip evalString sss
evalString tape (']':_) = return tape
evalString tape (s:ss) = eval tape s >>= flip evalString ss

jumpToAfterPair :: String -> String
jumpToAfterPair ss = nextString ss 1

nextString :: String -> Int -> String
nextString "" _ = ""
nextString ss 0 = ss
nextString ('[':ss) n = nextString ss (n + 1)
nextString (']':ss) n = nextString ss (n - 1)
nextString (_:ss) n = nextString ss n

evalExpr :: String -> IO Tape
evalExpr = evalString newState
