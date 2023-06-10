module Main where

import Foo (fooFunc)

main :: IO ()
main = do
  putStrLn "Hello, Haskell!"
  fooFunc
