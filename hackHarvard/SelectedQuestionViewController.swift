//
//  SelectedQuestionViewController.swift
//  hackHarvard
//
//  Created by Mack FitzPatrick on 10/21/16.
//  Copyright © 2016 Mack FitzPatrick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SelectedQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedQuestion = question(Uid: "", title: "", description: "")
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var answerTable: UITableView!
    
    // where we will store all the answers
    var answers = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up for right gesture swipe recognition
        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(SelectedQuestionViewController.showQuestionListViewController))
        
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(swipeGestureRecognizer)

        // get data passed from last page
        titleLabel.text = selectedQuestion.title
        descriptionLabel.text = selectedQuestion.description
    
        answerTable.delegate = self
        answerTable.dataSource = self
    
        // make the table cells dynamic for differnt length of comments
        answerTable.estimatedRowHeight = 200
        answerTable.rowHeight = UITableViewAutomaticDimension
        
        let ref = FIRDatabase.database().reference()
    
        // go to firebase and get all the parties and all there info
        ref.child("Questions/\(selectedQuestion.Uid)/responses").queryOrderedByKey().observe(.childAdded, with: {
        snapshot in
            let snapshotValue = snapshot.value as? NSDictionary
            let answer = snapshotValue?["answer"] as! String
    
            self.answers.append(answer)
    
        // update the table view to the all the questions
            DispatchQueue.main.async {
                self.answerTable.reloadData()
            }
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // go to add answer page when plus sign is pressed
    @IBAction func addAnswer() {
        performSegue(withIdentifier: "toAnswer", sender: selectedQuestion)
    }
    
    // go back to question list via the back button
    @IBAction func back() {
        performSegue(withIdentifier: "backToQuestionList", sender: nil)
    }
    
    // go back to question list via the right gesture swipe
    func showQuestionListViewController() {
        
        performSegue(withIdentifier: "backToQuestionList", sender: self)
        
    }
    
    // ensure that data is passed on the the add an answer page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toAnswer") {
            let guest = segue.destination as! AnswerViewController
            guest.selectedQuestion = sender as! question
        }
    }
    
    // creates the number of cells in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    // create the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // Make table cells the show the user name
        let cell = answerTable.dequeueReusableCell(withIdentifier: "Cell")
    
        let titleLabel = cell?.viewWithTag(2) as! UILabel
        titleLabel.text = answers[answers.count - indexPath.row - 1]
    
        return cell!
    }
    

}
