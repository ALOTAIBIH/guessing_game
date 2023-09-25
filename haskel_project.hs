-- File     : Proj1.hs
-- Author   : Hissah Alotaibi (alotaibih@student.unimelb.edu.au)
-- ID       : 1042537
-- Date     : Tuesday, 4 May 2021
-- Purpose  : Guessing and feedback parts of a guessing game

-- This project implements the card guessing game.

-- |Card guessing game have two players face each other, 
--  each with a complete standard deck of western playing cards(without jokers) 
--  One player will be the answerer and the other are the guesser. 
--  The answerer begins by selecting some number of cards from his 
--  or her deck without showing the guesser.
--  These cards will form the answer for this game. 
--  The “guesser’ role in this game is to guess the answer, 
--  via repeated guess, informed by feedback. The object of this game 
--  for the guesser is to guess the answer with the fewest possible guesses.

-- |This project basically includes three main functions: -
--   feedback: comparing answer card with guess card and,
--   the provide five integer feedback tuples.
--   Game state: is list used internally in this project 
--   to get what I need to know/remember between guesses,
--   it will pare down when receiving answer/feedback for a guess.
--   Initial Guess: generate initial guess by given answer card number.
--   Next Guess: take previous guess, old game state and 
--   feedback for providing next guess. 

-- |The strategy used in this project is 
--  we used hardcode to initial first guess,
--  to keep a list of possible guesses, that is, 
--  the guesses that the feedback we got so far did not exclude. 
--  When we do guess, we choose one of the possible guesses that 
--  would leave us with the fewest remaining possible guesses 
--  when we receive the feedback for it. 
--  This can be done by calculating the weighted average length of the list 
--  of remaining possible guesses over the sizes of that list.

module Proj2 (feedback, initialGuess, nextGuess, GameState) where

import Card
import Data.List

type GameState = [[Card]]

------------------------------------------------------------------------
--                    Computing Feedback
------------------------------------------------------------------------

-- |Feedback function takes two cards which is a target as 
--   the first argument and a guess as the second argument,
--   and returns the five feedback numbers,  as a tuple.

type Feedback = (Int,Int,Int,Int,Int)

feedback :: [Card] -> [Card] -> Feedback
feedback target guess = 
  (correctCard target guess,
  lowerRanks target guess,
  correctRanks target guess,
  higherRanks target guess,
  correctSuits target guess)
  
-- |CorrectCard: take two lists of cards(answer and guess) and, 
--  returns an integer indicating the number of matching cards 
--  in the two input lists

correctCard::[Card] -> [Card] -> Int
correctCard [] [] = 0
correctCard (x:xs) guess
   | x `elem` guess  = (1+correctCard xs guess) 
   |otherwise = correctCard xs guess
correctCard _ _= 0

-- |Lower Ranks function: take two lists of cards (answer and guess) and, 
--   returns an integer refer to the number of cards in the Answer list 
--   that have rank lower than the lowest rank in the guess list

lowerRanks::[Card] -> [Card] -> Int
lowerRanks [] [] = 0
lowerRanks (x:xs) guess  
    | (rank x< lowestRnkInGuess) = 1+ (lowerRanks xs guess) 
    | otherwise = lowerRanks xs guess
            where lowestRnkInGuess = head $ sort (map rank guess)
lowerRanks _ _ = 0

-- Intersection Without Repeat here was used to count each card in the guess,
-- mached to card in target is only once

interWithoutRepeat xs ys = xs \\ (xs \\ ys)

-- |correctRanks: the number of the cards in the answer have the same rank 
--    as a card in the guess is only once

correctRanks :: [Card] -> [Card] -> Int
correctRanks target guess = 
 length $ interWithoutRepeat (map rank target) (map rank guess)

-- |HigherRanks function: take two lists of cards (answer and guess) and, 
--  returns an integer refer to the number of cards in the Answer list that 
--  have rank hiegher than the highest rank in the guess list
  
higherRanks::[Card] -> [Card] -> Int
higherRanks [] [] = 0
higherRanks (x:xs) guess
    |rank x > highestRnakInGuess = 1+ (higherRanks xs guess) 
    |otherwise = higherRanks xs guess
            where highestRnakInGuess = last $ sort (map rank guess)
higherRanks _ _ = 0

-- correctSuits : the number of of the cards in the answer have the same suit 
--                as a card in the guess is only once

correctSuits :: [Card] -> [Card] -> Int
correctSuits target guess = 
 length $ interWithoutRepeat (map suit target) (map suit guess)
----------------------------------------------------------------------------
--                           Initial Guess
-----------------------------------------------------------------------------
-- |initialGuess function: it takes as input the number of cards in the answer 
--   and returns a pair of an initial guess, which is a list of the specified
--   number of cards, and a game state. 

--   Because the bestGuess function is too slow to be used 
--   on the full list of all possible guesses, we hard code our initial guess. 

--   The GameState of the initial guess should be 
--   the sequence of the list of all the cards without repeat, 
--   For example, when the input number is 2, the GameState
--   should be [[2C,3C]],[2C,4C]...[QS,AS],[KS,AS]].

initialGuess :: Int -> ([Card],GameState)
initialGuess answer = (firstGuess answer,initialGameState answer)

-- |firstGuess can return the initial guess depending on the
--   input number. 

firstGuess :: Int -> [Card]
firstGuess i
    | i == 2 = [Card Club R6, Card Heart R10]
    | i == 3 = [Card Club R4, Card Heart R8, Card Spade Queen]
    | i == 4 = [Card Club R3, Card Diamond R6, Card Heart R9, Card Spade Queen]

--Using all_Different and allpossibleGuess to initial the whole GameState

initialGameState :: Int -> GameState
initialGameState answeNumber = 
                  filter all_Different (allpossibleGuess answeNumber deck)

-- Containt a list of all cards 
deck::[Card]
deck = [minBound..maxBound]

-- |All_Different function, returns True when cards different 
--   of each other in the list, 
--   returns False when the list has same cards more than once 

all_Different :: (Eq a) => [a] -> Bool
all_Different  [] = True
all_Different  (x:xs) =  not (x `elem` xs) && all_Different  xs


 -- |AllpossibleGuess takes a number(size of card in answer) and a list
 --   and will return a game state that contain a list of all possible guess
 --   as sublist of the given deck.
 --   For example, allpossibleGuess 2 [1,2,3] will return [[1,2],[1,3],[2,3]].

allpossibleGuess :: Int ->[Card]-> GameState
allpossibleGuess _ []  = [[]]
allpossibleGuess cardNum (x:xs)
   |cardNum==0 = [[]]
   |cardNum == len= map(x:) (allpossibleGuess (cardNum-1) xs) 
   |cardNum < len =  map (x:) (allpossibleGuess (cardNum-1)  xs) 
                               ++ allpossibleGuess cardNum xs
     where len = 1 + length xs
     
--------------------------------------------------------------------------
--                             Next Guess
---------------------------------------------------------------------------        
-- |next guess: takes as input a pair of the previous guess and game state,
--   and the feedback to this guess as a quintuple, and returns a
--   pair of the next guess and new game state. First
--   narrows down the list of possible guesses based on the feedback
--   from our previous guess, and then decides the best guess to make
--   based on the new list of possible guesses.

nextGuess :: ([Card],GameState) -> Feedback -> ([Card],GameState)
nextGuess (previousGuess, oldGamestate) feedb = (newGuess, newGameState)
  where posAnswer = [card| card <-delete previousGuess oldGamestate,
                                        feedback card previousGuess==feedb]

        newGuess = bestGuess posAnswer
        newGameState = delete newGuess posAnswer

------------------------------------------------------------------------------
--                        Choosing the best next guess
------------------------------------------------------------------------------

-- |Best Guess function:  take a list of lists of cards and, 
--   returns a list of card as the guess for the next guess.
--   we take a possible card that gives us the smallest remaining 
--   list of possible answers.

-- |We do this by computing:-
--
-- -For each remaining possible answer, the average number of possible answers.
-- -Compute the feedback for each possible answer. 
-- -Group all the answers by the feedback, to have many small groups
--   and therefore, it leave few possible answers for guess 
--   when we receive the feedback. 
-- -And then compute expected number of remaining possible answers 
--   for that guess using the average of the sizes of these groups, 
--   weighted by the sizes of the groups.

bestGuess :: [[Card]] -> [Card]
bestGuess xs = if len >= 1500 then  xs !! (len `div` 2) else newGuess

        where 
              scoreLst = [(expectedNum(group $ sort 
                            [feedback a b | a <- xs, a /= b]), b)|b <- xs]
              (_,newGuess) = minimum scoreLst
              len = (length xs)

-- |ExpectedNum function: take a list of lists of tuples,and returns the score 
--   for the list using the sum of the squares of the group sizes divided 
--   by the sum of the group sizes.

expectedNum :: [[(Int, Int, Int, Int, Int)]] -> Double
expectedNum [] = 0.0
expectedNum list = fromIntegral (sumSqure list) / fromIntegral (sumlist list)

-- |Sum list function: take  a list of lists of tuples,and
--  returns the length of sum of each tuple list

sumlist :: [[(Int, Int, Int, Int, Int)]] -> Int
sumlist [] = 0
sumlist (x:xs) = length x + sumlist xs 

-- Sum Squre function return the sum of square of each tuple list

sumSqure :: [[(Int, Int, Int, Int, Int)]] -> Int
sumSqure [] = 0
sumSqure (x:xs) = (length x)^2 + sumSqure xs 
