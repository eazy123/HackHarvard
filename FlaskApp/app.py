# -*- coding: utf-8 -*-

import pyrebase
from flask import Flask, render_template, request, redirect, url_for, abort, session
import json
import urllib2, urllib
import requests

global userToken

config = {
	"apiKey": "AIzaSyBuvPj-HdPlCbXfUzrdpDka0-Q0gvmkD9U",
	"authDomain": "hackharvard-7eb91.firebaseapp.com",
	"databaseURL": "https://hackharvard-7eb91.firebaseio.com",
	"storageBucket": "hackharvard-7eb91.appspot.com"
}

firebase = pyrebase.initialize_app(config)

app = Flask(__name__)

@app.route('/showSignUp')
def showSignUp():
    return render_template('signup.html')

@app.route('/signUp', methods =['GET', 'POST'])
def signUp():
	print("hello")
	error = None
	if request.method == 'POST':
		email = request.form['inputEmail']
		password = request.form['inputPassword']
		confPass = request.form['confirmPassword']

		if email[-19:] != "college.harvard.edu":
			error = "You must have a Harvard College email."
		elif password != confPass:
			error = "Your passwords do not match."
		else:
			signedUp = True
			auth = firebase.auth()
			try:
				auth.create_user_with_email_and_password(email, "typewriter")
			except:
				signedUp = False
				pass
			if signedUp == False:
				error = 'An account associated with that email has already been created.'
			else:
				auth.send_password_reset_email(email)
				return redirect(url_for('login'))

	return render_template('signup.html', error=error)
	
@app.route('/getQuestions', methods=['GET', 'POST'])
def getQuestions():
	print "hello world"
	#if request.method == 'GET':
	auth = firebase.auth()
	user = auth.sign_in_with_email_and_password("test@gmail.com", "password")
	db = firebase.database()
	questions = db.child("Questions").order_by_key().get(user['idToken'])
	titles = []
	for question in questions.each():
		uid = question.key()
		titles.append(db.child("Questions/" + uid + "/title").get(user['idToken']).val())
	print titles
	json.dumps(titles)
	#r = requests.post('http://templates/forum.php', urllib.urlencode(questions))
	#print r
	return showQuestions()
	

@app.route('/logIn', methods=['GET','POST'])
def login():
	error = None
	if request.method == 'POST':
		auth = firebase.auth()
		loggedIn = True
		try:
			user = auth.sign_in_with_email_and_password(request.form['inputEmail'], request.form['inputPassword'])
		except:
			loggedIn = False
			pass
			
		#print(loggedIn)
		if loggedIn == False:
			error = 'Invalid credentials. Please try again.'
		else:
			userToken = auth.get_account_info(user['idToken'])
			return render_template('index.html') #home
			#return getQuestions()
	return render_template('login.html', error=error)


@app.route('/showLogIn')
def showSignIn():
	return render_template('login.html')

@app.route('/showHome')
def showHome():
	return render_template('forum.php')

@app.route('/showQuestions')
def showQuestions():
	return redirect(url_for('showHome'))

@app.route("/")
def main():
    return render_template('index.html')

if __name__ == "__main__":
    app.run()
