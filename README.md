# guessing_game
-- File     : Proj1.hs
-- Author   : Hissah Alotaibi (hissahalotaibi5@gmail.com)
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
--   Next Guess: take previous guess, old game state and feedback for providing next guess. 

-- |The strategy used in this project is 
--  we used hardcode to initial first guess,
--  to keep a list of possible guesses, that is, 
--  the guesses that the feedback we got so far did not exclude. 
--  When we do guess, we choose one of the possible guesses that 
--  would leave us with the fewest remaining possible guesses 
--  when we receive the feedback for it. 
--  This can be done by calculating the weighted average length of the list 
--  of remaining possible guesses over the sizes of that list.
