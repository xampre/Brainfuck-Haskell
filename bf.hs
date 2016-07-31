import System.Environment (getArgs, getProgName)
import Brainfuck

main :: IO ()
main =
  do args <- getArgs
     pName <- getProgName
     if null args
       then putStrLn $ "Usage: " ++ pName ++ " filename"
       else readFile (head args) >>= evalExpr >> return ()
