//
//  SignUpViewController.swift
//  hackHarvard
//
//  Created by Mack FitzPatrick on 10/21/16.
//  Copyright © 2016 Mack FitzPatrick. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var comfirmPasswordField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self
        self.comfirmPasswordField.delegate = self
        
        self.alertLabel.text = ""
        
        // Set up for right gesture swipe recognition
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SignUpViewController.showSignInViewController))
        
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Takes you back to the sign in page with back button
    @IBAction func backToSignIn() {
        performSegue(withIdentifier: "toSignIn", sender: nil)
    }
    
    // Takes you back to the sign in page with right swipe
    func showSignInViewController() {
        
        performSegue(withIdentifier: "toSignIn", sender: self)
        
    }
    
    // hide keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    // hide keyboard when user presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        comfirmPasswordField.resignFirstResponder()
        return (true)
    }
    
    @IBAction func signUp() {
        // Make sure the user has entered the same password twice for redundincy sake. That way we KNOW they intended that to be their password. And we also make sure the email they entered is a harvard email address
        if (passwordField.text == comfirmPasswordField.text && emailField.text!.hasSuffix("@college.harvard.edu")){
            
            // create the user in firebase here
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: "kcirtapztif", completion: {
                user, error in
                
                if error != nil {
                    self.alertLabel.text = "An error has ocurred while signing up..."
                }
                else {
                    self.alertLabel.text = "Account created!"
                    // clear the text fields on succsess
                    FIRAuth.auth()?.sendPasswordReset(withEmail: self.emailField.text!){ error in
                        if error != nil {
                            // An error happened.
                            self.alertLabel.text = "An error has ocurred while sending verification email..."
                        } else {
                            // Email sent.
                            self.alertLabel.text = "Verification Email Sent! Please check your email."
                            self.emailField.text = ""
                            self.passwordField.text = ""
                            self.comfirmPasswordField.text = ""
                        }
                    }
                }
            })
        }
        else {
            if !emailField.text!.hasSuffix("@college.harvard.edu"){
                self.alertLabel.text = "You must sign up with a @college.harvard.edu email address!"
            }
            else {
                self.alertLabel.text = "Passwords do not match!!!"
            }
        }
    }

}
