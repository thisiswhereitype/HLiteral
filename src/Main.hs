module Main where

import System.Environment
import Data.List.Split(chunksOf)

main = do
  (path:_) <- getArgs

  -- Ideally parse these from args
  let indentStr = "    "
  let lineLength = 38 - length indentStr

  -- Split into lines preserving newlines
  file <- lines' <$> readFile path
  -- Chunk lines into length
  let a = (chunksOf lineLength) $ concat file
  -- Handle escape chars
  let b = map (concatMap escapes) file

  -- Convert empty lines into \n
  -- Add backslashes to enclose lines
  let centerLines = map (enclose indentStr . removeEmptyLines) $ (tail . init) b

  -- Add prepending and terminating chars
  let firstLine = [indentStr ++ "\"" ++ head b ++ "\\\n"]
  let lastLine = [indentStr ++ "\\" ++ last b ++ "\"\n"]
  let t = (firstLine ++ centerLines ++ lastLine) :: [String]
  writeFile (path ++ ".HLiteral") $ concat t

isEscape :: Char -> Bool
isEscape c
  | c == '\a' = True
  | c == '\b' = True
  | c == '\f' = True
  | c == '\n' = True
  | c == '\r' = True
  | c == '\t' = True
  | c == '\v' = True
  | c == '\\' = True
  | c == '\"' = True
  | c == '\'' = True
  | otherwise = False

escapes :: Char -> String
escapes c
  | c == '\a' = "\\a"
  | c == '\b' = "\\b"
  | c == '\f' = "\\f"
  | c == '\n' = "\\n"
  | c == '\r' = "\\r"
  | c == '\t' = "\\t"
  | c == '\v' = "\\v"
  | c == '\\' = "\\\\"
  | c == '\"' = "\\\""
  | c == '\'' = "\\\'"
  | otherwise = [c]

removeEmptyLines :: String -> String
removeEmptyLines "" = "\\n"
removeEmptyLines a = a

enclose :: String -> String -> String
enclose indentStr str = indentStr ++ "\\" ++ str ++ "\\\n"

lines' :: String -> [String]
lines' str = (map (++"\n") $ init (lines str)) ++ [last (lines str)]
