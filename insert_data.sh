#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do 
  # countries table
  # add unique countries from winners column
  if [[ $WINNER != 'winner' ]]
  then
      NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      if [[ -z $NAME ]]
        then COUNTRY=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $COUNTRY = 'INSERT 0 1' ]]
        then echo $WINNER added
        fi
      fi
  fi
  # add unique countries from opponents column
  if [[ $OPPONENT != 'opponent' ]]
  then
      NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      if [[ -z $NAME ]]
        then COUNTRY=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $COUNTRY = 'INSERT 0 1' ]]
        then echo $OPPONENT added
        fi
      fi
  fi
  # games table
  if [[ $YEAR != year || $ROUND != round ]]
  then
    WINNERID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENTID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR','$ROUND','$WINNERID','$OPPONENTID','$WINNERGOALS','$OPPONENTGOALS')")
    if [[ $GAME = 'INSERT 0 1' ]]
    then echo GAME ADDED
    fi
  fi
done
