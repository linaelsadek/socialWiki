# socialWiki

gems used

1) bootstrap-sass --> open-source web design framework from Twitter
2) bcrypt --> encryption of password
3) faker --> generates fake information such as users, and statuses
4) will_paginate --> limit number of data per page
5) bootstrap-will_paginate
6) carrierwave --> image uploader
7) railroady --> generates the class diagrams for the models and controllers

add-on to heroku:
sendgrid --> sends account_activation + password_reset emails



features implemented:

1) signup/resetpassword --> both of which send an email to your email to verify the option

2) login/logout --> login can already be done for an activated user. Meaning, once you sign up, you have to wait for the email and press activate. Only after that will you be able to access your profile.

3) profile --> a user have a display picture using "Gravatar". You need to sign up to Gravatar before changing it on our website. It will also give you a status of how many you're following and how many you follow. Those are links, so if you click on any of them, you will be redirected to a page that shows all the people following/followed.

4) Settings in the drop down menu --> allows you to change your name, email password, or display picture.

5) Users tab --> allows you to see all users that have signed up for this website. It can only be seen if a user is logged in. A regular user cannot delete any user, only an admin can.

6)Homepage --> A user that is not logged in will get a homepage that has a signup and the logo of our website. If the user is logged in, then they will get a feed digest showing their status updates, and the status of other people a user is following. It will also show a display picture, and the stats of following/followed.

7)Forum --> A user that is not logged in can view the topics and the comments. However, they cannot contribute. Only if the user is logged will they be able to contribute. A user cannot delete a topic/comment that is not written by them, unless they are an admin.

8) Voting --> any user, if logged in can vote/unvote for any comment.

9) Pages: we have, contact us, about, help

=======================================================================
Implementation specifics:

stats:
	- Controllers: 10 controllers
	- Models: 6 models
	- Views: 11 views (many files inside each folder)
	
Specs:
	- Controllers:
		- Account activation: method --> edit: find user by email, checks if the user is activated. If not, activates account, and redirects the user to their profile. If yes, it will display and "invalid activation link" and redirect the user to the home page (the one you see before logging in).
		
		- Application: method --> logged_in_user: checks if user is logged in. If not, it displays a message informing the user to "Please log in", and then redirects to home page.

		- Comments: has a before_action --> logged_in_user ... meaning, the user has to be logged in to do anything with a comment.
			methods:
				create: finds a topic by id, creates a comment, saves the comment in the topic db, and associates the topic_id with comment in comment db. If it gets successfully saved, the user will be able to see the topic with the comment.

				destroy: finds topic id, and deletes the comment from the topic and comment db
				
				upvote/downvote: gets topic id, finds comment by id, creates/destroys a vote

		- Micropost: has a before action logged_in_user and correct_user (i.e. you have to be the right person to post on your profile).
			methods:
				create: finds a current_user (found because we're creating sessions and cookies) and creates a micropost. If it gets saved correctly, a "micropost created" message will be displayed.

				destroy: just destroys any micropost you decide on. This is determined from the view. Every micropost is associated with a delete button. If pressed, it will go poof!

				
 		- PasswordReset: has a before_action of get_user, valid_user, check_expiration (of email/link in email sent)

			methods:
				create: find the user by email, create a new password, and associate it with the user, send the email and show "email sent with password reset instructions". If email is not found, give "email address not found"
				
				update: when the user is updating their password, check if the password is empty and give an error. Else, just accept it.

		- Relationships: before_action logged_in_user
			methods:
				create: associated a user with another user throught the "follow_id" in the db.

				destroy: delete the followed relationship. That is, you cant stop a person from following you, you can stop following a person.

		-Sessions:
			methods:
	
				create: find the user by email, check if they are authenticated (i.e. saved session and password match), check if user is activated. If all is true, "remember user"/ save session, else give an error "account not activated, check your email for the activation link". If something is false give an error message "invalid email/password combination"

 				destroy: if user logs out, just delete saved sessoin, and display home page.


		- StaticPages:
			method:
				home: check if logged in, load microposts, feed_items, topics, and comments

				help, about, and contact are empty

		- Topics: before_action logged_in_user and correct_user
			methods:
				new: just create a topic

				create: check if the user is correct_user (i.e. logged in), build the topic and save it, then display a "Discussion topics created" message.

				edit: find the topic id, redirect to edit form

				destroy: find topic id, destroy

				show: open up topic id, and show relevant information (i.e., comments associated and the votes)

				index: show all topics

		- Users: before_action logged_in_user, correct_user, and admin_user
			methods:
				index: display all users

				show: find the user id, display profile

				new: show create new user form

				create: create the user given params, and save it to db, send the activation email as well

				edit: display edit user form

				update: update user information given params (from the form)

	


	- Models:
		- comment: 
			relations: belongs_to topic, user... has_many votes ... validations such as there needs to be conter, user and topic, also, order it from new to old

		- micropost:
			relations: belongs_to user, 
			validates: user and content must exist
			some implementation to add a picture status

		- Relationship:
			relations: belongs_to follower, followed
			validates: followe_id, followed_id

		- Topic:
			relations: has_many comments, belongs_to user
			validates: title, usre, and content must exist
			order from new to old

		- User:
			attributes: remember_token, activation_token, reset_token
			relations: has_many microposts, topics, comments, active_relations (follower), passive_relations (followed), following, follower
			validates: email, password

			there are methods to send the activation emails, remember the user, forget the user ...etc

		- Vote:
			relation: belongs_to comment
				
	

As there are too many views, we won't go into the details but we'll just mention that there are forms for the signup/ password reset/user update/topic create and update/ comment create and update.


Databases: we have 13 tables in the database. There is one for every model and additional ones for the resets/signups and whatnot.

