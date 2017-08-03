module Main where

-- #!/usr/bin/env stack
-- -- stack runghc --resolver lts-9.00

import System.Environment
import Data.List.Split(chunksOf)

type Args = [String]

main = do
  (path:_) <- getArgs
  let indentStr = "    "
  let lineLength = 38 - length indentStr
  -- Handle escape chars
  file <- lines <$> concatMap escapes <$> readFile path
  -- Add newlines
  -- Chunk lines into length
  -- let q = concatMap (chunksOf lineLength) $ map (++"\n") file
  let q = concatMap (chunksOf lineLength) file
  -- Convert empty lines into \n
  -- Add backslashes to
  let centerLines = map ((enclose indentStr) . removeEmptyLines) $ (tail . init) q

  -- Add prepending and terminating chars
  let firstLine = [indentStr ++ "\"" ++ (head q) ++ "\\\n"]
  let lastLine = [indentStr ++ "\\" ++ (last q) ++ "\"\n"]
  let t = (firstLine ++ centerLines ++ lastLine) :: [String]
  writeFile (path ++ ".HLiteral") $ concat t

escapes :: Char -> String
escapes c
  | c == '\\' = "\\\\"
  | c == '\"' = "\\\""
  | c == '\'' = "\\\'"
  | c == '\t' = "  "
  | otherwise = [c]

removeEmptyLines :: String -> String
removeEmptyLines "" = "\n"
removeEmptyLines a = a

enclose :: String -> String -> String
enclose indentStr str = indentStr ++ "\\" ++ str ++ "\\\n"
