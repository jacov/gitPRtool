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
function reportPR() {

ARG=$1

# convert csv to regex
export known_code_authors_regex=$(echo "$KNOWN_AUTHORS" | sed -e 's/,/|/g')


# curl https://api.github.com/repos/:owner/:repo/pulls

# Public or Private
if test "$GIT_AUTH_USERNAME" != ''
then
	# Private
	# export PULLS_JSON=$(curl -s -u ${GIT_AUTH_USERNAME}:${GIT_AUTH_PASSWORD} "https://api.github.com/repos/${GIT_REPO_OWNER}/${GIT_REPO}/pulls?state=open")
	curl -s -u ${GIT_AUTH_USERNAME}:${GIT_AUTH_PASSWORD} "https://api.github.com/repos/${GIT_REPO_OWNER}/${GIT_REPO}/pulls?state=open" -o tmp_pulls.json
	check_error
else
	# Public
	# export PULLS_JSON=$(curl -s "https://api.github.com/repos/${GIT_REPO_OWNER}/${GIT_REPO}/pulls?state=open")
	curl -s "https://api.github.com/repos/${GIT_REPO_OWNER}/${GIT_REPO}/pulls?state=open" -o tmp_pulls.json
	check_error
fi

# MAP DATA
# export PULL_ID=$(echo "$PULLS_JSON" | jq ".[].id" )
#export PULL_URL=$(echo "$PULLS_JSON" | jq ".[].url")
#export PULL_NUM=$(echo "$PULLS_JSON" | jq ".[].number")
#export PULL_LOGIN=$(echo "$PULLS_JSON" | jq ".[].user.login")

export pointer=0
# echo "$PULLS_JSON" | jq ".[].id" | while read pull_id 
# curl -s -u ${GIT_AUTH_USERNAME}:${GIT_AUTH_PASSWORD} "https://api.github.com/repos/${GIT_REPO_OWNER}/${GIT_REPO}/pulls?state=open" | jq ".[].id" | while read pull_id 
cat tmp_pulls.json | jq ".[].id" | while read pull_id
do

	single_pull_num=$(cat tmp_pulls.json | jq ".[$pointer].number")
	single_pull_login=$(cat tmp_pulls.json | jq ".[$pointer].user.login")
	single_pull_url=$(cat tmp_pulls.json | jq ".[$pointer].url")
	
	
	# filter on login
	if test "$USER_FILTER" != ''
	then
		export user_filter=$(echo "$USER_FILTER" | tr [:upper:] [:lower:])
		if test "$user_filter" = "all"
		then
			print_report "$single_pull_num" "$single_pull_login" "$single_pull_url"	
			check_error

		elif test "$user_filter" = "known"
		then
			echo "$single_pull_login" | grep -iE "$known_code_authors_regex"
			if test $? -eq 0
			then
				print_report "$single_pull_num" "$single_pull_login" "$single_pull_url"	
				check_error
			fi

		else
			echo "$single_pull_login" | grep -i "$user_filter"
			if test $? -eq 0
			then
				print_report "$single_pull_num" "$single_pull_login" "$single_pull_url"	
				check_error
			fi
		fi 
		
	fi


	pointer=$(echo $[$pointer+1])

check_error

done

}
##################################################
function print_report(){

single_pull_num=$1
single_pull_login=$2
single_pull_url=$3

# FINAL OUTPUT
echo "
Pull Request #$single_pull_num

Author: $single_pull_login

URL: $single_pull_url


########
"


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

echo "

checking all outstanding pull requests, this may take some time depending on number of PR's,
please wait...

"

source gitPRtool.conf
check_error
# export GIT_REPO_OWNER='someorg'
# export GIT_REPO='somerepo'
# export GIT_AUTH_USERNAME='jacov'
# export GIT_AUTH_PASSWORD='XXXXXX'

reportPR


##
## END
## 
check_error
echo "done"


