#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#Code below written for freecodecamp solution:

CSV_FILE="games.csv"
CSV_FILE="games.csv"

# Skip the header and extract the winner and opponent columns (columns 3 and 4)
tail -n +2 "$CSV_FILE" | while IFS=, read -r year round winner opponent winner_goals opponent_goals
do
  # Insert the winner into the teams table if it doesn't already exist
  $PSQL "INSERT INTO teams (name) SELECT '$winner' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$winner');"
  
  # Insert the opponent into the teams table if it doesn't already exist
  $PSQL "INSERT INTO teams (name) SELECT '$opponent' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$opponent');"

  #Insert whole row into games table
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner';")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent';")
  $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);"
done

echo "Teams inserted successfully."