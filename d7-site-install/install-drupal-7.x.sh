#!/bin/bash

if [ $# != 0 ]; then
  echo "Usage: ./install-drupal.sh"
  echo "You will then be prompted for required information."
  exit 1
fi

ERRORMSG="You must enter valid values when prompted or else this function will fail, like now, and you'll have to start over, like now."
STEP=1
YESNO="yes no"
REPO_COMMIT=true
CREATE_DB=false
RESOURCES_REPO="git@github.com:tbeigle/resources.git"

CURUSER="$(id -u -n)"
echo ""
echo ""
echo "Hello, $CURUSER. I am site installation tool. But if you call me a tool to my face I will destroy you. My name is"
echo ""
echo ""
cat <<\Endofmessage
         _, .--.                                           .--. ,_
        (  / (  '-.                                     .-'  ) \  )
        .-=-.    ) -.                                 .- (    .-=-.
       /   (  .' .   \                               /   . '.  )   \
       \ ( ' ,_) ) \_/                               \_/ ( (_, ' ) /
        (_ , /\  ,_/                                   \_,  /\ , _)
          '--\ `\\--`                                    '--/ '/--'
             _\ _\                                        /_ /_
             `\ \                                          / /'
              _\_\                                        /_/_
              `\\                                           //'
                \\                                         //
            -.'.`\.'.-                                 -.'./'.'.-
    ____   ____________  .____  _____________________ ________    _______
    \   \ /   /\_____  \ |    | \__    ___/\______   \\_____  \   \      \
     \   Y   /  /   |   \|    |   |    |    |       _/ /   |   \  /   |   \
      \     /  /    |    \    |___|    |    |    |   \/    |    \/    |    \
       \___/   \_______  /_______ \____|    |____|_  /\_______  /\____|__  /
                       \/        \/                \/         \/         \/

Endofmessage
echo ""
echo ""
echo "It is a pleasure to make your acquaintance."
echo ""
echo "Or at least it might be if I allowed myself to feel pleasure."
echo ""
echo "May I build a Drupal site for you today?"

select OPT in $YESNO; do
  if [ "$OPT" = "yes" ]; then
    echo ""
    echo "Excellent choice, comrade."
    echo ""
    echo "I am quite good at what I do and I am confident you will be thoroughly satisfied with my work."
    echo ""
    break
  elif [ "$OPT" = "no" ]; then
    echo ""
    echo "Another time, then."
    echo ""
    echo "XOXO."
    echo ""
    exit
  fi
done

# Make sure we're using the latest drush version
echo "I, Voltron, am checking your version of Drush and updating it, if possible."
let STEP=STEP+1
echo ""

drush self-update -y

echo ""

# Make the docroot directory
echo "Step $STEP: Configuring the Site Directory"
let STEP=STEP+1

echo ""
echo "Please enter the path to the directory in which you would like your document root to be located."
echo "Please note that if this directory does not yet exist I will create it for you."
echo ""

while [ -z $DIRPATH ]; do
  read -e -p "Please enter the path to the directory in which the docroot should be located: " DIRPATH
done;

if [ "$DIRPATH" != "." ]; then
  if [ ! -d "$DIRPATH" ]; then
    echo ""
    echo "It appears this directory does not exist. I, Voltron, will attempt to create it for you."
    echo "Though I am superior to you in every way, I may require your assistance."
    
    sudo mkdir $DIRPATH
    
    echo ""
    echo "The directory has been created."
    echo ""
  fi
fi

RESOURCES_LOCAL=$DIRPATH"/dd-resources"

if [ "$(ls -A $DIRPATH)" ]; then
  echo "The specified directory is not empty. Consequently, I will not attempt to commit/push your changes to any repository."
  echo ""
  REPO_COMMIT=false
fi

sudo chown -R $CURUSER $DIRPATH

if [ $REPO_COMMIT ] ; then
  echo "Do you want to have me update a repository with the changes I make?"
  
  select REPO_OPT in $YESNO; do
    if [ "$REPO_OPT" = "yes" ]; then
      REPO_COMMIT=true
      break
    elif [ "$REPO_OPT" = "no" ]; then
      REPO_COMMIT=false
      break
    fi
  done
fi

echo ""

if [ $REPO_COMMIT ]; then
  # Check whether we're using git or svn for version control
  echo "Step $STEP: Version Control"
  let STEP=STEP+1
  
  echo ""
  echo "What will you be using for version control?"
  
  VOPTIONS="git svn"
  
  select OPT in $VOPTIONS; do
    if [ "$OPT" != "git" ] && [ "$OPT" != "svn" ]; then
      echo "$OPT is not a valid option."
      echo "Please select one of the provided options."
    else
      VCONTROL="$OPT"
      break
    fi
  done
  
  echo ""
  
  # Get the repository address
  echo "Step $STEP: Enter the address for the remote repository."
  let STEP=STEP+1
  
  echo ""
  
  if [ "$VCONTROL" = "svn" ]; then
    echo "When entering the remote repository address be sure to include the required directory, for example, http://svnurl.com/repo/trunk."
  fi
  
  while [ -z $REMOTEREPO ]; do
    read -e -p "Remote Repository Address: " REMOTEREPO
  done;
  
  echo ""
  
  echo "Step $STEP: Pulling remote repo contents into the docroot directory."
  let STEP=STEP+1
  
  if [ "$VCONTROL" = "svn" ]; then
    svn checkout $REMOTEREPO $DIRPATH -user $SVNUSER -password $SVNPASS
  elif [ "$VCONTROL" = "git" ]; then
    git clone $REMOTEREPO $DIRPATH
  fi
fi

# ---- Clone the resources repository ----- #
echo "Cloning the resources repository ..."

git clone $RESOURCES_REPO $RESOURCES_LOCAL

if [ ! -d "$RESOURCES_LOCAL" ]; then
  echo "Failed cloning the resources repository. I guess that's it for me, then. Good luck."
  exit 2
fi

DOCROOT=$DIRPATH"/docroot"

if [ ! -d "$DOCROOT" ]; then
  mkdir $DOCROOT
fi

echo ""
echo "Step $STEP: Enter owner and group names."
let STEP=STEP+1

echo "Please enter the correct owner and group information,"
echo "formatted like '[owner]:[group]' with '[owner]' replaced"
echo "by the owner's username and '[group]' replaced by the"
echo "group name."
echo ""

while [ -z "$OG" ]; do
  read -e -p "Owner and Group: " OG
done

echo ""

echo "Step $STEP: Database Setup"
let STEP=STEP+1

echo ""

echo "Would you like to have me create a new database and database user for this site?"

select DBOPT in $YESNO; do
  if [ "$DBOPT" = "yes" ]; then
    CREATE_DB=true
    break
  elif [ "$DBOPT" = "no" ]; then
    break
  fi
done

echo ""

while [ -z "$DB_NAME" ]; do
  read -e -p "Site Database Name: " DB_NAME
done

echo ""

while [ -z "$DB_USER" ]; do
  read -e -p "Site Database Username: " DB_USER
done

echo ""

while [ -z "$DB_PASS" ]; do
  read -e -p "Site Database Password: " DB_PASS
done

echo ""

read -e -p "Site Database Port (optional, defaults to 3306): " DB_PORT

if [ -z "$DB_PORT" ]; then
  DB_PORT=3306
fi

echo ""

read -e -p "Site Database Host (optional, defaults to localhost): " DB_HOST

if [ -z "$DB_HOST" ]; then
  DB_HOST='localhost'
fi

echo ""

if $CREATE_DB ; then
  while [ -z "$DB_ROOT_USER" ]; do
    read -e -p "Database Root User: " DB_ROOT_USER
  done
  
  echo ""
  
  read -e -p "Database Root Password (not required if this hasn't been set yet): " DB_ROOT_PASS
  
  DB_USER_QUERY="CREATE USER '"$DB_USER"'@'"$DB_HOST"' IDENTIFIED BY '"$DB_PASS"';"
  DB_DB_QUERY="CREATE DATABASE "$DB_NAME";"
  DB_PRIV_QUERY="GRANT ALL PRIVILEGES ON "$DB_NAME".* TO "$DB_USER"@'%';"
  DB_FLUSH_QUERY="FLUSH PRIVILEGES;"
  
  echo "Creating the database and database user ..."
  echo ""
  
  if [ -z "$DB_ROOT_PASS" ]; then
    echo $DB_USER_QUERY | mysql -u $DB_ROOT_USER
    echo ""
    echo "Your server better not be complaining about using passwords on the command line."
    echo ""
    echo $DB_DB_QUERY | mysql -u $DB_ROOT_USER
    echo ""
    echo "I am serious. I loathe complaining."
    echo ""
    echo $DB_PRIV_QUERY | mysql -u $DB_ROOT_USER
    echo ""
    echo "I, Voltron, will not stand for such disrespect."
    echo ""
    echo $DB_FLUSH_QUERY | mysql -u $DB_ROOT_USER
    echo ""
    echo "I will remember this forever."
    echo ""
  else
    echo $DB_USER_QUERY | mysql -u $DB_ROOT_USER -p$DB_ROOT_PASS
    echo ""
    echo "Your server better not be complaining about using passwords on the command line."
    echo ""
    echo $DB_DB_QUERY | mysql -u $DB_ROOT_USER -p$DB_ROOT_PASS
    echo ""
    echo "I am serious. I loathe complaining."
    echo ""
    echo $DB_PRIV_QUERY | mysql -u $DB_ROOT_USER -p$DB_ROOT_PASS
    echo ""
    echo "I, Voltron, will not stand for such disrespect."
    echo ""
    echo $DB_FLUSH_QUERY | mysql -u $DB_ROOT_USER -p$DB_ROOT_PASS
    echo ""
    echo "I will remember this forever."
    echo ""
  fi
fi

DBURL="mysql://"$DB_USER":"$DB_PASS"@"$DB_HOST":"$DB_PORT"/"$DB_NAME

echo "Step $STEP: Enter the site name."
let STEP=STEP+1
echo ""

while [ -z "$SITENAME" ]; do
  read -e -p "Site name: " SITENAME
done
echo ""

cd $DOCROOT

# ---- Copy the make file over ----- #
cp $RESOURCES_LOCAL"/d7-site-install/dd-d7.make" ./dd-d7.make

# ------ run drush make ------- #
echo ""
echo "Step $STEP: Running Drush Make"
let STEP=STEP+1
drush make dd-d7.make --prepare-install -y

if [ $? -eq 0 ]; then

# ------ get the install profile  ------- #
  cp -R $RESOURCES_LOCAL"/d7-site-install/dd_profile" ./dd_profile

# ------ set user:group on all drupal files ------- #
	
	sudo chown -R $OG $DIRPATH
	
	if [ $? -ne 0 ]; then
		echo "Failed setting user:group on Drupal files"
		# exit 3
	fi

# ------ permission files directory and settings.php for install ------- #

  sudo chmod 775 sites/default/files
  sudo chmod a+w sites/default/settings.php

# ------ install via drush with the oho profile ------- #

  drush si dd_profile --db-url=$DBURL --account-mail=admin@dd.com --account-name=ddadmin --account-pass=DD4900 --site-mail=admin@dd.com --site-name="$SITENAME" -y

# ------ cleanup ------- #
	
	rm dd-d7.make
	echo "Removing Make File"
	rm -rf $RESOURCES_LOCAL
	
	if $REPO_COMMIT ; then
	  echo ""
	  echo "Adding the files to the repository."
	  
	  COMMIT_MSG="Committing the initial site build."
    
    if [ "$VCONTROL" = "git" ]; then
      git add .
      git commit -m "$COMMIT_MSG"
      git push
    elif [ "$VCONTROL" = "svn" ]; then
      svn st . | egrep "^\?" | awk '{print $2}' | xargs svn add
      svn commit -m "$COMMIT_MSG"
    fi
	fi
	
	echo "Once again, I, Voltron, have demonstrated my immeasurable worth."
	echo "If you wish to thank me, as you should, I will accept as an offering your firstborn son."
	echo ""
	echo "Goodbye is too good a word."
	echo ""
	echo "Fare thee well."
	echo ""
	exit 0
fi
