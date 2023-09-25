# guessing_game
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
