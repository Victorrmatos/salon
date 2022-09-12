#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e '\n~~~~~ Hair Salon ~~~~~\n'

MENU(){
#get available services
AVAILABLE_SERVICES=$($PSQL "select * from services order by service_id")

  echo -e "\nHere are the services we have available:"
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
  echo "$SERVICE_ID) $SERVICE_NAME"
  done
  #ask for choice
  echo -e "\nWhich one would you like to book?"
  read SERVICE_ID_SELECTED
  #if input is not a number
 if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
  # send to main menu
  MENU "That is not a valid service number."
  else
  
   # get customer info
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  # if customer doesn't exist
if [[ -z $CUSTOMER_NAME ]]
then
  # get new customer name
echo -e "\nWhat's your name?"
read CUSTOMER_NAME

  # insert new customer
INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers (phone,name) values ('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
fi

echo "What time?"
  read SERVICE_TIME
# get customer_id
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")
# insert booking
INSERT_APPOINTMENT=$($PSQL "insert into appointments(service_id, customer_id, time) values ('$SERVICE_ID_SELECTED','$CUSTOMER_ID','$SERVICE_TIME')")
# get service info
SERVICE_NAME=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")

echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $( echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."
fi
}
MENU
