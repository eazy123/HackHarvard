//
//  AnswerViewController.swift
//  hackHarvard
//
//  Created by Mack FitzPatrick on 10/22/16.
//  Copyright © 2016 Mack FitzPatrick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class AnswerViewController: UIViewController, UITextViewDelegate {

    var selectedQuestion = question(Uid: "", title: "", description: "")
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var answerField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertLabel.text = ""
        
        titleLabel.text = selectedQuestion.title
        descriptionLabel.text = selectedQuestion.description
        
        self.answerField.delegate = self
        
        // Set up for right gesture swipe recognition
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AnswerViewController.showSelectedQuestionViewController))
        
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(swipeGestureRecognizer)
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
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            answerField.resignFirstResponder()
            return false
        }
        return true
    }
    
    // takes you back to the selected question via the back button
    @IBAction func back() {
        performSegue(withIdentifier: "backToQuestionInfo", sender: selectedQuestion)
    }
    
    // takes you back to the selected question via the back right gesture swipe
    func showSelectedQuestionViewController() {
        
        performSegue(withIdentifier: "backToQuestionInfo", sender: selectedQuestion)
        
    }
    
    // make sure data is sent back to the selected question page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "backToQuestionInfo") {
            let guest = segue.destination as! SelectedQuestionViewController
            guest.selectedQuestion = sender as! question
        }
    }
    
    @IBAction func submitNewAnswer() {
        let answer = answerField.text!
        
        if (answer == "")
        {
            alertLabel.text = "You can't leave this field blank!"
        }
        else{
            // create a new answer to add to the database
            let answer: [String: AnyObject] = ["answer": "\n" + answer as AnyObject]
            
            let ref = FIRDatabase.database().reference()
            
            // Give the answer a special id
            ref.child("Questions/\(selectedQuestion.Uid)/responses").childByAutoId().updateChildValues(answer)
            
            // clear the textfield
            answerField.text = ""
            performSegue(withIdentifier: "backToQuestionInfo", sender: selectedQuestion)
        }
        
        
    }
}
