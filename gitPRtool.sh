#!/bin/bash
#
#
# Simple command line tool that allows the user to see open pull requests for a set of github users that the tool user cares about: KNOWN_AUTHORS 
# 	For example, a team lead might want to see open pull requests for some or all of the members of his or her team. 
#
#
# By: Jacob Baloul
# Created: April 10, 2018
# 
#


#--# KNOWN_AUTHORS :: PLEASE CHANGE ME
#--# 	Known Code Author Filter Overrides
#--# 	you can hard code a list of comman seperated users to filter on
export KNOWN_AUTHORS="michael,gabriel,rafael,jacob"
#--# export KNOWN_AUTHORS="scott,erik,jacob"





##################################################
##################################################
##################################################
##
## FUNCTIONS
##
##################################################
function reportPR(){
export pr=$1
export code_author=$2
# FINAL OUTPUT
echo "
Pull Request #$pr 

"
# echo "$code_author"

git show --pretty=short --name-only FETCH_HEAD
check_error
  echo ;
  echo "########"
}
##################################################
function check_error(){
 if test $? -gt 0
  then
	echo "oops, something went wrong :-("
	exit 1
  fi
}
##################################################
##
## MAIN
##

#--# Code Author Filter
export USER_FILTER=$1

if test $# -lt 1
then
	echo "

	USAGE: 
		./$(basename $0) ALL
		./$(basename $0) KNOWN
		./$(basename $0) <code_author>
	EX:
		
		./$(basename $0) bob
"
exit 1
fi

# convert csv to regex
export known_code_authors_regex=$(echo "$KNOWN_AUTHORS" | sed -e 's/,/|/g')

echo "

checking all outstanding pull requests, this may take some time depending on number of PR's,
please wait...

"


git ls-remote origin 'pull/*/head' | awk '{print $2}' | while read ref
do
  pr=$(echo $ref | cut -d/ -f3)
  git fetch origin $ref >/dev/null 2>&1
  check_error

	if test "$USER_FILTER" != ''
	then
		export user_filter=$(echo "$USER_FILTER" | tr [:upper:] [:lower:])
		if test "$user_filter" = "all"
		then
			export code_author=$(git show --pretty=format:'%an' --name-only FETCH_HEAD )
			reportPR "$pr" "$code_author"
			check_error

		elif test "$user_filter" = "known"
		then
			export code_author=$(git show --pretty=format:'%an' --name-only FETCH_HEAD | grep -iE "$known_code_authors_regex")
			if test "$code_author" != ''
			then
				reportPR "$pr" "$code_author"
				check_error
			fi

		else
			export code_author=$(git show --pretty=format:'%an' --name-only FETCH_HEAD | grep -i "$user_filter")
			if test "$code_author" != ''
			then
				reportPR "$pr" "$code_author"
				check_error
			fi
		fi 
		
	fi



done
##
## END
## 
check_error
echo "done"


