#!/bin/bash
# Appointment Scheduling Management System

FILE="appointments.txt"

# Function: Generate next ID
generate_id() {
  if [ -s "$FILE" ]; then
    last_id=$(tail -n 1 "$FILE" | cut -d',' -f1)
    echo $((last_id + 1))
  else
    echo 1
  fi
}

# Function: Add appointment
add_appointment() {
  id=$(generate_id)
  read -p "Enter date (YYYY-MM-DD): " date
  read -p "Enter time (HH:MM): " time
  read -p "Enter description: " desc

  if grep -q "$date,$time" "$FILE"; then
    echo "⚠️ Conflict! Another appointment exists at this time."
  else
    echo "$id,$date,$time,$desc" >> "$FILE"
    echo " Appointment added."
  fi
}

# Function: View all appointments
view_all() {
  if [ -s "$FILE" ]; then
    column -t -s',' "$FILE"
  else
    echo "No appointments found."
  fi
}

# Function: View appointments by date
view_by_date() {
  read -p "Enter date (YYYY-MM-DD): " date
  grep ",$date," "$FILE" || echo "No appointments on $date"
}

# Function: Search by description
search_description() {
  read -p "Enter keyword: " keyword
  grep -i "$keyword" "$FILE" || echo "No matching appointments."
}

# Function: Delete appointment
delete_appointment() {
  read -p "Enter appointment ID to delete: " id
  if grep -q "^$id," "$FILE"; then
    grep -v "^$id," "$FILE" > temp && mv temp "$FILE"
    echo " Appointment deleted."
  else
    echo " Appointment not found."
  fi
}

# Function: Update appointment
update_appointment() {
  read -p "Enter appointment ID to update: " id
  if grep -q "^$id," "$FILE"; then
    grep -v "^$id," "$FILE" > temp && mv temp "$FILE"
    read -p "New date (YYYY-MM-DD): " date
    read -p "New time (HH:MM): " time
    read -p "New description: " desc
    echo "$id,$date,$time,$desc" >> "$FILE"
    echo " Appointment updated."
  else
    echo " Appointment ID not found."
  fi
}

# Function: View upcoming appointments
view_upcoming() {
  today=$(date +%F)
  awk -F',' -v today="$today" '$2 >= today' "$FILE" | column -t -s',' || echo "No upcoming appointments."
}

# Function: Check conflict
check_conflict() {
  read -p "Enter date (YYYY-MM-DD): " date
  read -p "Enter time (HH:MM): " time
  if grep -q "$date,$time" "$FILE"; then
    echo "onflict found!"
  else
    echo " No conflict."
  fi
}

# Function: Clear all appointments
clear_all() {
  > "$FILE"
  echo " All appointments cleared."
}

# Function: Menu
menu() {
while true; do
  echo -e "\n === Appointment Manager ==="
  echo "1. Add Appointment"
  echo "2. View All"
  echo "3. View by Date"
  echo "4. Search by Description"
  echo "5. Delete Appointment"
  echo "6. Update Appointment"
  echo "7. View Upcoming"
  echo "8. Check Conflict"
  echo "9. Clear All"
  echo "10. Exit"
  read -p "Choose an option [1-10]: " choice

  case $choice in
    1) add_appointment ;;
    2) view_all ;;
    3) view_by_date ;;
    4) search_description ;;
    5) delete_appointment ;;
    6) update_appointment ;;
    7) view_upcoming ;;
    8) check_conflict ;;
    9) clear_all ;;
    10) echo "Exiting."; break ;;
    *) echo " Invalid choice." ;;
  esac
done
}

menu
