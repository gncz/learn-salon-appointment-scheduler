#!/bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~~\n"

echo "Welcome to My Salon, how can I help you?"
echo "1) Cleaning"
echo "2) Golf Tutoring"
echo "3) Sky Gazing"
read SERVICE_ID_SELECTED

#mapfile -t VALID_SERVICE_IDS < <(psql --username=freecodecamp --dbname=salon -t -A -q -c "select service_id from services")

VALID_SERVICE_ID=$(psql --username=freecodecamp --dbname=salon -t -c "select service_id from services where service_id =$SERVICE_ID_SELECTED")
#for i in "${VALID_SERVICE_IDS[@]}"
#do
if [[ -z $VALID_SERVICE_ID ]]
    then
    echo "Welcome to My Salon, how can I help you?"
    echo "1) Cleaning"
    echo "2) Golf Tutoring"
    echo "3) Sky Gazing"
    read SERVICE_ID_SELECTED
    else 
    
    echo "What's your phone number?"  
    read CUSTOMER_PHONE
    
    VALID_CUSTOMER_PHONE=$(psql --username=freecodecamp --dbname=salon -t -c "select customer_id from customers where phone like '%$CUSTOMER_PHONE%';")
    if [[ -z $VALID_CUSTOMER_PHONE ]]
      then
      psql --username=freecodecamp --dbname=salon -t -c "INSERT INTO customers(phone) VALUES('$CUSTOMER_PHONE');" 
      echo "I don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      psql --username=freecodecamp --dbname=salon -t -c "UPDATE customers SET name='$CUSTOMER_NAME' where phone='$CUSTOMER_PHONE';"

      SERVICE_NAME=$(psql --username=freecodecamp --dbname=salon -t -c "select name from services where service_id=$SERVICE_ID_SELECTED ;")
      
      echo "What time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
      read SERVICE_TIME

      CUSTOMER_ID=$(psql --username=freecodecamp --dbname=salon -t -c "select customer_id from customers where phone='$CUSTOMER_PHONE' and name='$CUSTOMER_NAME';")
      psql --username=freecodecamp --dbname=salon -t -c "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');"
      echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.;"


    fi
fi


#echo "Valid service IDs: ${VALID_SERVICE_IDS[1]}"
