module Main where

import HLiteral
import System.Environment

main :: IO ()
main = do
  args <- toOptAndArgs <$> getArgs
  let inputPath = case lookup "-i" args of
                    Just a -> a
                    Nothing -> error "No input option provided e.g. (-i foo.txt)"
  file <- readFile inputPath

  let t = toHLiteral file (unsafeMakeArgs args)
  let outputPath = case lookup "-o" args of
                    Just a -> a
                    Nothing -> inputPath ++ ".HLiteral"

  writeFile outputPath t

toOptAndArgs :: [String] -> [(String, String)]
toOptAndArgs [] = []
toOptAndArgs [_] = error "Invalid argument(s)."
toOptAndArgs (a:b:as)
  | head a == '-' = (a ::String, b :: String) : toOptAndArgs (as :: [String])
  | otherwise = error "Invalid argument(s)."
