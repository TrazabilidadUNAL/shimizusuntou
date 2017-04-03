# Agri-Food Traceability Project (Gretel) API

This is the Agri-Food Traceability Project API for Software Engineering II course.

## Developers instructions

Do as indicated to start with the project from scratch:

* Clone the repo via `git clone git@github.com:TrazabilidadUNAL/shimizusuntou.git`
* Go into the folder and initialize the git flow via `git flow init` keeping in mind that all the defaults should be allowed, except the version tag which is empty by default. For the version tag use a lowercase v: `v`
* The `config/database.yml` file is ignored by default. Instead, there is a file called `config/database.yml.base` which shouldn't be modified nor renamed, but copied and pasted as `config/database.yml` for each developer specifying their `development` pair of user and password. This will avoid having conflicts between developers' machine.
* Once the database definitions have been configured, proceed to create the database via `rake db:create` and `rake db:migrate` where necessary.
* To populate the database copy and paste this code in your console:
```Bash
./populate
```
* If you want to reset your databases you always can run `rake db:reset` to start with a clean database.

Remeber to be carefull with the work you do and in doubt, please report any question to your Scrum Master: [Angel Rendon](mailto:amrendonsa@unal.edu.co).

Both, `master` and `develop` branches have been set as protected to avoid writing in them. Every branch intended to be merged with `develop` has to have its respective [pull request](https://help.github.com/articles/about-pull-requests/).

![alt text](intro.gif "Intro")