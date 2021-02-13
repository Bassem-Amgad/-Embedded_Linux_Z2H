#! /bin/bash

if [ $2 ]
then
	echo "Error too many paramters"
else
	echo "			WELCOME TO PHONEBOOK" 
	case $1 in
	"-i")
		echo "Inserting new contact in phone book"
		read -p "Enter contact name: " contact_name
		read -p "Enter contact number: " contact_number
		if [ ! "$contact_name" ]
		then
			echo "Invalid contact name ( it mustn't be empty )"		
		elif [[ $contact_number =~ ^[0-9]+$ ]] 
		then
			if grep -qe "^Name: $contact_name" $0
			then
				echo "Contact already exsists"
				read -p "Do you want to add another phone number to this contact ? y/n " ans
				if [ $ans = "y" ] || [ $ans = "Y" ]
				then
					sed -i "s/^Name: $contact_name -->/& Number: $contact_number --/" $0
					echo " Added another phone number for this contact"	
				else
					echo " Operation cancelled"
				fi

			else
				echo "Name: $contact_name --> Number: $contact_number" >> $0
			fi
		else
			echo "Invalid phone number ( it must contain numbers only)"
		fi;;
	"-v")
		if grep -qe "^Name: " $0
		then
			grep -e "^Name: " $0
		else
			echo "Phoneboook is empty"
		fi;;

	"-s")
		read -p "Enter contact name to find: " search_name
		grep -w  "Name: $search_name -->" $0 || echo "Entered name not found in database";;

	"-e")
		read -p "Are you sure you want to delete all contacts ? y/n " ans
		if [ $ans = "y" ] || [ $ans = "Y" ]
		then		
			sed -i "/^Name/d" $0
			echo "Deleted all records in phonebook"
		else
			echo "Operation cancelled"	
		fi;;
	"-d")
		read -p "Enter contact to delete: " delete_name
		if grep -qe "^Name: $delete_name -->" $0
		then
			sed -i "/^Name: $delete_name -->/d" $0 && echo "Contact deleted"
		else
			echo "Entered name not found in database"
		fi;;

	*)
	echo "The available options are:
	-i Insert new contact name and number
	-v View all saved contacts details
	-s Search by contact name
	-e Delete all records
	-d Delete only one contact name";;
	esac
fi
exit 0
