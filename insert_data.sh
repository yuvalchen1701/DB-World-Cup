#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

#! /bin/bash

# Set the appropriate PSQL command based on the input argument
if [[ $1 == "test" ]]; then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

#! /bin/bash

# Set the appropriate PSQL command based on the input argument
if [[ $1 == "test" ]]; then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Insert data into teams table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip the header row
  if [[ "$YEAR" != "year" ]]; then
    # Insert the winner if not already in the teams table
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z "$TEAM_ID_WINNER" ]]; then
      $PSQL "INSERT INTO teams(name) VALUES ('$WINNER')"
    fi
    
    # Insert the opponent if not already in the teams table
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z "$TEAM_ID_OPPONENT" ]]; then
      $PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')"
    fi
  fi
done

# Insert data into games table
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip the header row
  if [[ "$YEAR" != "year" ]]; then
    # Get the team IDs for the winner and opponent
    TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # Insert the game record into the games table
    $PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id)
           VALUES ('$YEAR', '$ROUND', '$WINNER_GOALS', '$OPPONENT_GOALS', '$TEAM_ID_WINNER', '$TEAM_ID_OPPONENT')"
  fi
done
