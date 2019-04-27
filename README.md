## Who Wants To Be a Mollionaire?

### Description

This is Ruby implementation of the worldwide famous game

Language: russian

Full description and rules [English Wiki](https://en.wikipedia.org/wiki/Who_Wants_to_Be_a_Millionaire%3F)

The game is for one or more players.

 All are given a question by the programm and four answers which must be placed within a particular order. Player have to simply answer a multiple-choice question.  Each features four possible answers, in which the player must give the correct answer. Doing so wins them a certain amount of money. During the game, the player has a set of lifelines that they may use only once to help them with a question.
 
 **Lifelines**
     
* **Ask the Audience**: When selected, each audience member takes up a voting pad, and votes the answer that they believe is correct for the question. Once the vote is tallied, the contestant is shown what the result of it was, displayed in percentages for each answer.
* **50:50**: When selected, the game's computer selects two wrong answers for the current question and eliminates them, leaving behind the correct answer, and one remaining incorrect answer.
* **Phone a Friend**: When selected, a friend of the player is rung up, and tasked with providing assistance to them on the question.

If a player feels unsure about an answer, and does not wish to play on, they can walk away with the money they have won

Admin can load the new questions from files( see data folder )

**Ruby 2.5.3**

**Rails 5.2.2**

**DataBase development: SQLite3**

### Getting Started
1. Downloaad or clone **bbq** repository

2. Use bundle
```
$ bundle install
```
3. Create Database
```
$ bundle exec rails db:create
```
4. Run database migrations
```
$ bundle exec rails db:migrate
```
5. To populate database with seed data run
```
bundle exec raails db:seed
```
6. To make the user says with id 1 admin run
```
$ rails c
>> User.find(1).toggle!(:is_admin)
```



© будущий программист
