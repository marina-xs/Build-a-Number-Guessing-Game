#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess --tuples-only --no-align -c"
# -t --no-align 
echo "Enter your username:"
read NAME
echo "Guess the secret number between 1 and 1000:"
#echo "you are $NAME"

#SEARCH_NAME_RESULT=$($PSQL "SELECT games_played, best_game FROM games WHERE username = '$NAME'")
#echo "$SEARCH_NAME_RESULT"
#echo "$SEARCH_NAME_RESULT" | read GAME_PLAYED BAR BEST_GAME
#no idea why the reading through piping was not working, so change to get the values one by one
GAME_PLAYED=$($PSQL "SELECT games_played FROM games WHERE username = '$NAME'")
#echo "$GAME_PLAYED"
if [[ ! -z $GAME_PLAYED ]]
then
  BEST_GAME=$($PSQL "SELECT best_game FROM games WHERE username = '$NAME'")
  #echo "$BEST_GAME"
fi

if [[ -z $GAME_PLAYED ]]
then
  echo "Welcome, $NAME! It looks like this is your first time here.$GAME_PLAYED"
else 
  echo "Welcome back, $NAME! You have played $GAME_PLAYED games, and your best game took $BEST_GAME guesses."
fi

#note that you cannnot put spaces around the = when assigning value to a new variable
#and also note the double (( we use here to add onto an existing variable itself
BINGO=$((RANDOM % 1000 + 1))
#echo "The random number is $BINGO"
#echo "Guess the secret number between 1 and 1000:"

NUM=0
while [[ $NUMBER != $BINGO ]]
do
  read NUMBER
  #not the double (()) and the $inside!!!
  NUM=$(($NUM+1))
  if [[ ! $NUMBER =~ [0-9] ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $NUMBER < $BINGO ]]
    then
      #echo "we compared $NUMBER with $BINGO. This is your $NUM times guess."
      echo "It's higher than that, guess again:"
    fi
    if [[ $NUMBER > $BINGO ]]
    then
      #echo "we compared $NUMBER with $BINGO.This is your $NUM times guess."
      echo "It's lower than that, guess again:"
    fi
    if [[ $NUMBER = $BINGO ]]
    then
      #echo "we compared $NUMBER with $BINGO."
      echo "You guessed it in $NUM tries. The secret number was $BINGO. Nice job!"
    fi
  fi
done

if [[ -z $GAME_PLAYED ]]
then
  INSERT_NEW_USER=$($PSQL "INSERT INTO games(username, games_played, best_game) VALUES('$NAME', 1, $NUM)")
else
  UPDATE_ONLY_GAME_PLAYED=$($PSQL "UPDATE games SET games_played = $(($GAME_PLAYED+1)) WHERE username = '$NAME'")
  #check if it is a new best_game
  if [[ $NUM < $BEST_GAME ]]
  then
    UPDATE_ONLY_GAME_PLAYED=$($PSQL "UPDATE games SET best_game = $NUM WHERE username = '$NAME'")
  fi
fi
#echo "$($PSQL "SELECT username, games_played, best_game FROM games WHERE username = '$NAME'")"


