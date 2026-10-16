
#!/bin/bash
# Look up elements by atomic number, symbol, or name.
PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit
fi

if [[ $1 =~ ^[0-9]+$ ]]; then
  ELEMENT=$($PSQL "SELECT e.atomic_number || '|' || e.symbol || '|' || e.name || '|' || p.atomic_mass || '|' || p.melting_point_celsius || '|' || p.boiling_point_celsius || '|' || t.type FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) WHERE e.atomic_number = $1")
else
  ELEMENT=$($PSQL "SELECT e.atomic_number || '|' || e.symbol || '|' || e.name || '|' || p.atomic_mass || '|' || p.melting_point_celsius || '|' || p.boiling_point_celsius || '|' || t.type FROM elements e JOIN properties p USING(atomic_number) JOIN types t USING(type_id) WHERE e.symbol = '$1' OR e.name = '$1'")
fi

if [[ -z $ELEMENT ]]; then
  echo "I could not find that element in the database."
  exit
fi

IFS='|' read -r NUMBER SYMBOL NAME MASS MELTING BOILING TYPE <<< "$ELEMENT"

echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
