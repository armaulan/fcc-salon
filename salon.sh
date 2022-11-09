#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\nWelcome..";

# Create main menu function
LIST_SERVICES() {
  if [[ $1 ]]
  then echo -e "\n$1"
  fi
  
  echo -e "These are our services, what do you want?";
  AVAILABLE_SERVICES=$($PSQL "select service_id, name from services")
  
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
    do
      echo "$SERVICE_ID) $SERVICE_NAME "
      done

  ORDER_PROCESSING 
      
}

ORDER_PROCESSING() {

# Get input of service that customer want
read SERVICE_ID_SELECTED

# Check service from database
SERVICE_ID=$($PSQL "select service_id from services where service_id= $SERVICE_ID_SELECTED")

# If service not found on db 
if [[ -z $SERVICE_ID ]]

  # Get back to main menu
  then LIST_SERVICES "Sorry service not in the list."

  # If service is found on db
  else
    echo -e "\nPhone number please..?"

    # Get input for customer phone number
    read CUSTOMER_PHONE

    # Check if phone given is in DB
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

    # If phone given is not found
    if [[ -z $CUSTOMER_ID ]]
      then
        # Force them to register first
        echo -e "\n You haven't registered yet, please write your name"

        # Ask them to put their name
        read CUSTOMER_NAME

        # Insert Phone and Name into DB
        CREATE_CUSTOMER_RESULT=$($PSQL "insert into customers(name, phone) values('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")

        # Get New Customer ID8888
        CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    fi

    echo -e "\nWhat time do yo want?"
    read SERVICE_TIME

    # Insert into appointment
    INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")

    # Get Service Name
    SERVICE_NAME==$($PSQL "select name from services where service_id =$SERVICE_ID ")
  
    # Get Customer Name
    CUSTOMER_NAME==$($PSQL "select name from customers where customer_id=$CUSTOMER_ID ")

    # echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    # $(echo $SERVICE_NAME | sed -r 's/= //g')
    # $(echo $CUSTOMER_NAME | sed -r 's/= //g')
    echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/= //g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/= //g')."



  fi

}

# Run main menu function
LIST_SERVICES