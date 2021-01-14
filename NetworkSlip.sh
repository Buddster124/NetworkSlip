#Script Created By: Anthony Budd
#Last Edit Date: 01/13/2021



#Notes
#Menu Setting Example = NetworkSlip.sh User Create

##Var Setting
scriptDir="/home/$username/scripts/"
sambafile="/etc/samba/smb.conf"
deny="Must Be Root!"

#Arg Selection
if [ $1 == "user"]
then
	##Code Here
	if [ $2 == "create"]
	then
	##User Create Code Here
		echo "Enter New username: "
		read -p username
		homedir="/home/$username"
		echo "Enter Home DIR(Enter to Default): "
		read -p homedir
		echo "Adding User: $username"
		useradd -d $homedir -s /bin/false -N "$username"
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"

	elif [ $2 == "disable"]
	then
	##User Disable Code Here
		echo "Enter User To Disable: "
		read -p username
		smbpasswd -d $username
		[ $? -eq 0 ] && echo "User Disabled successfully" || echo "Failed to Disable user!"

	elif [ $2 == "enable"]
	then
	##User Enable Code Here
		echo "Enter User To enable: "
		read -p username
		smbpasswd -e $username
		[ $? -eq 0 ] && echo "User enabled successfully" || echo "Failed to enable user!"


	elif [ $2 == "delete"]
	then
	##User Delete Code Here
		echo "Enter User To Delete: "
		read -p username
		smbpasswd -x $username
		[ $? -eq 0 ] && echo "Users Network account removed successfully" || echo "Failed to remove user network account!"
			if [ $? -eq 0 ]; then
				deluser $username
					[ $? -eq 0 ] && echo "User Deleted" || echo "Failed to Delete user!"
				fi

	elif [ $2 == "password"]
	then
	##User Password Set Code Here
		echo "Enter Username: "
		read -p username
		smbpasswd -a $username
		[ $? -eq 0 ] && echo "$username password changed successfully!" || echo "Failed to change password!"

	elif [ $2 == "list"]
	then
	##User List Code Here
		pdbedit -L -v

	else
	echo "Please enter a argument..."
	fi


elif [ $1  == "share"]
then
	if [ $2 == "add"]
	then
	##Share add code
	read -p "Enter new share name: " share
	read -p "Enter comment: " comment
	read -p "Enter valid users (@users = all users, or type username, if multiple users then separate names with space): " username
	read -p "Make DIR writable? (yes / no): " option1
	mkdir -p /home/shares/$share
	[ $? -eq 0 ] && echo "DIR in place!" || echo "Nope!"
	if [ $? -eq 0 ]; then
		chown -R root:users /home/share/$share
		[ $? -eq 0 ] && echo "Ownership set!" || echo "Sorry!"
			if [ $? -eq 0 ]; then
				chmod -R ug+rwx,o+rx-w /home/share/$share
				[ $? -eq 0 ] && echo "Modifications Done!" || echo "Didnt happen!"
				if [ $? -eq 0 ]; then
					echo "[$share]" >> $sambafile
					echo "comment = $comment" >> $sambafile
					echo "path = /home/shares/$share" >> $sambafile
					echo "valid users = $username" >> $sambafile
					echo "force group = users" >> $sambafile
					echo "create mask = 0660" >> $sambafile
					echo "directory mask = 0771" >> $sambafile
					echo "writable = $option1" >> $sambafile
				[ $? -eq 0 ] && echo "Share added!" || echo "Shoot and miss on the share!"
					if [ $? -eq 0 ]; then
						systemctl restart smbd.service
					[ $? -eq 0 ] && echo "Share active!" || echo "So quiet!"
					fi
				fi
			fi
	fi


	elif [ $2 == "list"]
	then
	##Share List code
		smbstatus

	else
	echo "Please enter a argument..."
	fi


	elif [$1 == "edit"]
	then
	##Code Here
		if [$2 == "smb.conf"]
		then
			nano $sambafile

		else
		echo "Please enter a argument..."
		fi

	elif [ $1 == "restart"]
	then
	##Restart Code Here
		if [$2 == "network"]
			systemctl restart smbd.service

		else
		echo "Please enter a argument..."
		fi



elif [ $1 == "help"]
then
    echo "user create -- Create a user"
    echo "user disable -- Disable a user"
    echo "user enable -- Enable a user"
	echo "user delete -- Delete a user"
	echo "user password -- Set a users password"
	echo "user list -- List users"
	echo "share add -- Adds a share"
	echo "share list -- Lists shares"
	echo "edit smb.conf -- Edit Samba config file"
	echo "restart network -- Restarts Samba Service"
else
    echo "Please enter a argument, For help do ./NetworkSlip help"
fi
