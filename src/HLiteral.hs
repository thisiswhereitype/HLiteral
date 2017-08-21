module HLiteral (
        toHLiteral, Literal,
        Args, makeArgs, makeArgs', unsafeMakeArgs
) where

import Data.List.Split(chunksOf)

type Literal = String

data Args = Args
  {  lineLength' :: Int
  ,  indentStr' :: String
  }

makeArgs :: [(String, String)] -> Maybe Args
makeArgs [] = error "Invalid argument(s)"
makeArgs a =
  case (lookup "-l" a, lookup "-s" a) of
    (Just len, Just str) -> Just $ makeArgs' (read len) str
    _ -> Nothing

unsafeMakeArgs :: [(String, String)] -> Args
unsafeMakeArgs [] = error "Invalid argument(s)"
unsafeMakeArgs a =
  case makeArgs a of
    Just b  -> b
    Nothing -> error "Invalid argument(s)"

makeArgs' :: Int -> String -> Args
makeArgs' = Args

toHLiteral :: String -> Args -> Literal
toHLiteral file' arg = ret
  where
    -- Ideally parse these from args
    indentStr = indentStr' arg
    lineLength = (lineLength' arg) - length indentStr

    -- Split into lines and keep \n on the end of each
    file = lines' file'

    -- Chunk lines into length
    a :: [String]
    a = chunksOf lineLength $ concat file

    -- Handle escape chars
    -- Important to do this after chunking in order to avoid escapes wrapping
    -- onto newline and causing parse issues.
    b :: [String]
    b = map (concatMap escapes) a

    -- Convert empty lines into \n
    -- Add backslashes to enclose lines
    centerLines :: [String]
    centerLines = map (enclose indentStr . removeEmptyLines) $ (tail . init) b

    -- Add prepending and terminating chars
    firstLine :: [String]
    firstLine = [indentStr ++ "\"" ++ head b ++ "\\\n"]
    lastLine :: [String]
    lastLine = [indentStr ++ "\\" ++ last b ++ "\"\n"]
    -- Concat them all together
    ret = concat ((firstLine ++ centerLines ++ lastLine) :: [String])


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
lines' str = map (++"\n")  (init (lines str)) ++ [last (lines str)]

unlines' :: [String] -> String
unlines' [] = []
unlines' [a] = a
unlines' as = head as ++ unlines' (tail as)
