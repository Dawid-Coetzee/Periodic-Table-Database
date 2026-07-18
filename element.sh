#! /bin/bash
# Element information program
# VARIABLES
PSQL="psql --username=freecodecamp --dbname=periodic_table -t -A -F',' -c"

# NO ARGUMENTS
if [[ $# < 1 ]]
then
  echo "Please provide an element as an argument."
  exit;
fi

# CHECKING IF ARGUMENT IS A STRING
if [[ $1 =~ ^[a-zA-Z]+$ ]]
then
  # CHECKING IF ARGUMENT IS A NAME
  if [[ ${#1} -gt 2 ]]
  then
    INPUTTED_NAME=$1
    NAME=$($PSQL "SELECT name FROM elements WHERE name='$INPUTTED_NAME'")
    if [[ -z $NAME ]]
    then
      echo "I could not find that element in the database."
      exit;
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME'")
    fi
  # IF ARGUMENT IS A SYMBOL
  else
    INPUTTED_SYMBOL=$1
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$INPUTTED_SYMBOL'")
    if [[ -z $SYMBOL ]]
    then
      echo "I could not find that element in the database."
      exit;
    else
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL'")
    fi
  fi
# IF ARGUMENT IS AN ATOMIC NUMBER
else
  INPUTTED_ATOMIC_NUMBER=$1
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$INPUTTED_ATOMIC_NUMBER'")
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
      exit;
    else
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
    fi
fi

TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."