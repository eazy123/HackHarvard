//
//  ViewController.swift
//  hackHarvard
//
//  Created by Mack FitzPatrick on 10/21/16.
//  Copyright © 2016 Mack FitzPatrick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertLabel.text = ""
        
        self.titleField.delegate = self
        self.descriptionField.delegate = self
        
        // Set up for right gesture swipe recognition
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AskViewController.showQuestionListViewController))
        
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // takes you back to the question list via the back button
    @IBAction func Back() {
        performSegue(withIdentifier: "toQuestionList", sender: nil)
    }
    
    // takes you back to the question list via a right swipe
    func showQuestionListViewController() {
        
        performSegue(withIdentifier: "toQuestionList", sender: self)
        
    }
    
    // hide keyboard when user touches outside of the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    // hide keyboard when user presses return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleField.resignFirstResponder()
        return (true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descriptionField.resignFirstResponder()
            return false
        }
        return true
    }
    
    

    @IBAction func createQuestion() {
        
        let title = titleField.text!
        let desc = descriptionField.text!
        
        if (title == "" || desc == "")
        {
            alertLabel.text = "You can't leave any field blank!"
        }
        else if (title.characters.count > 42)
        {
            alertLabel.text = "Title must be less then 42 characters! Current count: \(title.characters.count)"
        }
        else if (desc.characters.count > 140)
        {
            alertLabel.text = "Description must be less then 140 characters! Current count: \(desc.characters.count)"
        }
        else
        {
            // create a new question to add to the database, with all its attributes
            let question: [String: AnyObject] = ["title": title as AnyObject,
                                              "description": desc as AnyObject]
            
            let ref = FIRDatabase.database().reference()
            
            // Give the question a special id
            ref.child("Questions").childByAutoId().setValue(question)
            
            // clear all the textfields
            titleField.text = ""
            descriptionField.text = ""
            performSegue(withIdentifier: "toQuestionList", sender: nil)
        }
        
        
    }
}

