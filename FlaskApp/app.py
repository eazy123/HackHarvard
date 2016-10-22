# -*- coding: utf-8 -*-

import pyrebase
from flask import Flask, render_template, request, redirect, url_for, abort, session

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

@app.route('/signUp', methods=['POST'])
def signUp():
	email = request.form['inputEmail']
	password = request.form['inputPassword']
	print(email + password)
	auth = firebase.auth()
	auth.create_user_with_email_and_password(email, password)
	return ('index.html')
	

@app.route('/showLogIn')
def showSignIn():
	return render_template('login.html')

@app.route('/showHome')
def showHome():
	return render_template('home.php')

@app.route("/")
def main():
    return render_template('index.html')

#@app.route('/signUp')
#def signUp():


if __name__ == "__main__":
    app.run()
