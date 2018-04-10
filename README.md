# gitPRtool

Simple command line tool that allows the user to see open pull requests for a set of github users that the tool user cares about: KNOWN_AUTHORS 

For example, a team lead might want to see open pull requests for some or all of the members of his or her team. 


## Simplest Install...one liner
* Download and run gitPRtool.sh in your git code repo
	```
	# cd <path_to_git_repo>
	wget https://raw.githubusercontent.com/jacov/gitPRtool/master/gitPRtool.sh && chmod +x gitPRtool.sh && ./gitPRtool.sh		
	``` 

## More methods:
* you can clone the repo
* you can download into your executable $PATH ,ex /bin and then run from anywhere on any repo


## Customizations:
* To make the script aware of your code authors, modify the KNOWN_AUTHORS variable, ex:

```
#--# KNOWN_AUTHORS :: PLEASE CHANGE ME
#--# 	Known Code Author Filter Overrides
#--# 	you can hard code a list of comman seperated users to filter on
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
 
