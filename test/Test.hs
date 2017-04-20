module Main where

import Test.QuickCheck.Function
import Test.Tasty
import Test.Tasty.QuickCheck as QC

import Data.Word

import Data.BitStream

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "All"
  [QC.testProperty "index . tabulate = id" $
    \(Fun _ f) ix -> let f' = f . (fromIntegral :: Word -> Word64) in
                         let jx = ix `mod` 65536 in
                             f' jx == index (tabulate f') jx
  ]
