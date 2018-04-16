# gitPRtool

Simple command line tool that allows the user to see open pull requests for a set of github users that the tool user cares about: KNOWN_AUTHORS 

For example, a team lead might want to see open pull requests for some or all of the members of his or her team. 


## Simplest Install...
* Download and run gitPRtool.sh 
	```
	# cd <path_to_git_repo>
	wget https://raw.githubusercontent.com/jacov/gitPRtool/master/gitPRtool.sh && chmod +x gitPRtool.sh 
	wget https://raw.githubusercontent.com/jacov/gitPRtool/master/gitPRtool.conf && chmod +x gitPRtool.conf 
	# Modify gitPRtool.conf, ex: vim gitPRtool.conf
	./gitPRtool.sh		
	``` 

## More methods:
* you can clone the repo
* you can download into your executable $PATH ,ex /bin and then run from anywhere on any repo


## Customizations:
* To make the script aware of your code authors and repo please modify the variables in gitPRtool.conf:

```
# git config:
export GIT_REPO_OWNER='someorg'
export GIT_REPO='somerepo'
export GIT_AUTH_USERNAME='jacov'
export GIT_AUTH_PASSWORD='XXXXXXX'

# Code Authors that we care about
export KNOWN_AUTHORS="michael,gabriel,rafael,jacob"

```

## USAGE:
```

	USAGE:
		./gitPRtool.sh ALL
		./gitPRtool.sh KNOWN
		./gitPRtool.sh <code_author>
	EX:

		./gitPRtool.sh bob
```



#### By: Jacob Baloul
#### Created: April 10, 2018
 
