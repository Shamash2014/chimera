-- |
-- Module:      Data.BitStream.WheelMapping
-- Copyright:   (c) 2017 Andrew Lelechenko
-- Licence:     MIT
-- Maintainer:  Andrew Lelechenko <andrew.lelechenko@gmail.com>
--
-- Helpers for mapping to <http://mathworld.wolfram.com/RoughNumber.html rough numbers>
-- and back. Mostly useful in number theory.

{-# LANGUAGE BinaryLiterals #-}

module Data.BitStream.WheelMapping
  ( fromWheel2
  , toWheel2
  , fromWheel6
  , toWheel6
  , fromWheel30
  , toWheel30
  , fromWheel210
  , toWheel210
  ) where

import Data.Bits
import qualified Data.Vector.Unboxed as U
import Data.Word

word2int :: Word -> Int
word2int = fromIntegral

-- | Left inverse for 'fromWheel2'.
--
-- prop> toWheel2 . fromWheel2 == id
toWheel2 :: Word -> Word
toWheel2 i = i `shiftR` 1
{-# INLINE toWheel2 #-}

-- | 'fromWheel2' n is the (n+1)-th positive odd number.
-- Sequence <https://oeis.org/A005408 A005408>.
--
-- prop> map fromWheel2 [0..] == [ n | n <- [0..], n `gcd` 2 == 1 ]
--
-- > > map fromWheel2 [0..9]
-- > [1,3,5,7,9,11,13,15,17,19]
fromWheel2 :: Word -> Word
fromWheel2 i = i `shiftL` 1 + 1
{-# INLINE fromWheel2 #-}

-- | Left inverse for 'fromWheel6'.
--
-- prop> toWheel6 . fromWheel6 == id
toWheel6 :: Word -> Word
toWheel6 i = i `quot` 3
{-# INLINE toWheel6 #-}

-- | 'fromWheel6' n is the (n+1)-th positive number, not divisible by 2 or 3.
-- Sequence <https://oeis.org/A007310 A007310>.
--
-- prop> map fromWheel6 [0..] == [ n | n <- [0..], n `gcd` 6 == 1 ]
--
-- > > map fromWheel6 [0..9]
-- > [1,5,7,11,13,17,19,23,25,29]
fromWheel6 :: Word -> Word
fromWheel6 i = i `shiftL` 1 + i + (i .&. 1) + 1
{-# INLINE fromWheel6 #-}

-- | Left inverse for 'fromWheel30'.
--
-- prop> toWheel30 . fromWheel30 == id
toWheel30 :: Word -> Word
toWheel30 i = q `shiftL` 3 + (r + r `shiftR` 4) `shiftR` 2
  where
    (q, r) = i `quotRem` 30
{-# INLINE toWheel30 #-}

-- | 'fromWheel30' n is the (n+1)-th positive number, not divisible by 2, 3 or 5.
-- Sequence <https://oeis.org/A007775 A007775>.
--
-- prop> map fromWheel30 [0..] == [ n | n <- [0..], n `gcd` 30 == 1 ]
--
-- > > map fromWheel30 [0..9]
-- > [1,7,11,13,17,19,23,29,31,37]
fromWheel30 :: Word -> Word
fromWheel30 i = ((i `shiftL` 2 - i `shiftR` 2) .|. 1)
              + ((i `shiftL` 1 - i `shiftR` 1) .&. 2)
{-# INLINE fromWheel30 #-}

-- | Left inverse for 'fromWheel210'.
--
-- prop> toWheel210 . fromWheel210 == id
toWheel210 :: Word -> Word
toWheel210 i = q * 48 + fromIntegral (toWheel210Table `U.unsafeIndex` word2int r)
  where
    (q, r) = i `quotRem` 210
{-# INLINE toWheel210 #-}

toWheel210Table :: U.Vector Word8
toWheel210Table = U.fromList [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 2, 0, 0, 0, 3, 0, 4, 0, 0, 0, 5, 0, 0, 0, 0, 0, 6, 0, 7, 0, 0, 0, 0, 0, 8, 0, 0, 0, 9, 0, 10, 0, 0, 0, 11, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0, 0, 13, 0, 14, 0, 0, 0, 0, 0, 15, 0, 0, 0, 16, 0, 17, 0, 0, 0, 0, 0, 18, 0, 0, 0, 19, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 21, 0, 0, 0, 22, 0, 23, 0, 0, 0, 24, 0, 25, 0, 0, 0, 26, 0, 0, 0, 0, 0, 0, 0, 27, 0, 0, 0, 0, 0, 28, 0, 0, 0, 29, 0, 0, 0, 0, 0, 30, 0, 31, 0, 0, 0, 32, 0, 0, 0, 0, 0, 33, 0, 34, 0, 0, 0, 0, 0, 35, 0, 0, 0, 0, 0, 36, 0, 0, 0, 37, 0, 38, 0, 0, 0, 39, 0, 0, 0, 0, 0, 40, 0, 41, 0, 0, 0, 0, 0, 42, 0, 0, 0, 43, 0, 44, 0, 0, 0, 45, 0, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 47]

-- | 'fromWheel210' n is the (n+1)-th positive number, not divisible by 2, 3, 5 or 7.
-- Sequence <https://oeis.org/A008364 A008364>.
--
-- prop> map fromWheel210 [0..] == [ n | n <- [0..], n `gcd` 210 == 1 ]
--
-- > > map fromWheel210 [0..9]
-- > [1,11,13,17,19,23,29,31,37,41]
fromWheel210 :: Word -> Word
fromWheel210 i = q * 210 + fromIntegral (fromWheel210Table `U.unsafeIndex` word2int r)
  where
    (q, r) = i `quotRem` 48
{-# INLINE fromWheel210 #-}

fromWheel210Table :: U.Vector Word8
fromWheel210Table = U.fromList [1, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 121, 127, 131, 137, 139, 143, 149, 151, 157, 163, 167, 169, 173, 179, 181, 187, 191, 193, 197, 199, 209]
