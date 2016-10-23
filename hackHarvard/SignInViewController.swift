//
//  SignInViewController.swift
//  hackHarvard
//
//  Created by Mack FitzPatrick on 10/21/16.
//  Copyright © 2016 Mack FitzPatrick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailField.delegate = self
        self.passwordField.delegate = self
        
        alertLabel.text = ""
        
        // check keychain for old email and old password and use those to long in for the user if they are avalible. This way the user doesn't have to login in manually everytime they open the app
        let oldEmail = keychain.get("email")
        let oldPassword = keychain.get("password")
        if (oldEmail != nil && oldPassword != nil) {
            checkUser(email: oldEmail!, password: oldPassword!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // hide keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    // hide keyboard when user presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return (true)
    }
    
    // takes you to sign up page
    @IBAction func signUp() {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
    // try to login the user after they hit the login button
    @IBAction func login() {
        checkUser(email: emailField.text!, password: passwordField.text!)
    }
    
    
    let keychain = KeychainSwift()
    
    // see if a user is already signed up and can sign in
    func checkUser(email: String, password: String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {
            user, error in
            
            if error != nil {
                self.alertLabel.text = "password or email is incorrect..."
            }
            else {
                self.alertLabel.text = "Successfully logged in. Welcome to Askii!"
                
                // save the users log in info for the next time they open the app. This way they won't need to re-enter it unless they log out
                self.keychain.set(email, forKey: "email")
                self.keychain.set(password, forKey: "password")
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }
            
        })
    }
}
