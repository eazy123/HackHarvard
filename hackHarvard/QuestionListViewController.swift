//
//  QuestionListViewController.swift
//  hackHarvard
//
//  Created by Mack FitzPatrick on 10/21/16.
//  Copyright © 2016 Mack FitzPatrick. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

struct question {
    let Uid: String
    let title: String
    let description: String
}
class QuestionListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionTable: UITableView!
    
    // set up for search bar filtering
    let searchController = UISearchController(searchResultsController: nil)
    var filteredQuestions = [question]()
    
    func filterContentForSearchText(SearchText: String, scope: String = "All"){
        filteredQuestions = questions.filter{ question in
            return (question.title.lowercased().range(of: SearchText.lowercased()) != nil)
        }
        questionTable.reloadData()
    }
    
    // where we will store all the questions
    var questions = [question]()

    override func viewDidLoad() {
        super.viewDidLoad()

        questionTable.delegate = self
        questionTable.dataSource = self
        
        let ref = FIRDatabase.database().reference()
        
        // go to firebase and get all the parties and all there info
        ref.child("Questions").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            let Uid = snapshot.key
            let snapshotValue = snapshot.value as? NSDictionary
            let description = snapshotValue?["description"] as! String
            let title = snapshotValue?["title"] as! String
            
            self.questions.append(question(Uid: Uid, title: title, description: description))
            
            // update the table view to the all the questions
            DispatchQueue.main.async {
                self.questionTable.reloadData()
            }
        })
        
        // search bar flitering
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        questionTable.tableHeaderView = searchController.searchBar
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logout() {
        // since the user has chosen to logout, we clear their saved keychain email and password login info and we take them back to the welcome screen
        let keychain = KeychainSwift()
        keychain.delete("email")
        keychain.delete("password")
        performSegue(withIdentifier: "logout", sender: nil)
    }

    // go to ask question page viw the plus sign
    @IBAction func askNewQuestion() {
         performSegue(withIdentifier: "toAsk", sender: nil)
    }
    
    // creates the number of cells in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searchController.isActive && searchController.searchBar.text != ""){
           return filteredQuestions.count
        }
        
        return questions.count
    }
    
    // define all the cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Make table cells the show the user name
        let cell = questionTable.dequeueReusableCell(withIdentifier: "Cell")
        
        if (searchController.isActive && searchController.searchBar.text != ""){
            let titleLabel = cell?.viewWithTag(1) as! UILabel
            titleLabel.text = filteredQuestions[filteredQuestions.count - indexPath.row - 1].title
        }
        else{
            let titleLabel = cell?.viewWithTag(1) as! UILabel
            titleLabel.text = questions[questions.count - indexPath.row - 1].title
        }
        
        return cell!
    }
    
    // when user clicks on a person in the table it takes them to the second page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if (searchController.isActive && searchController.searchBar.text != ""){
            performSegue(withIdentifier: "toQuestionInfo", sender: filteredQuestions[filteredQuestions.count - indexPath.row - 1])
        }
        else{
            performSegue(withIdentifier: "toQuestionInfo", sender: questions[questions.count - indexPath.row - 1])
        }
    }
    
    // insures question info is sent to the next page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toQuestionInfo") {
            let guest = segue.destination as! SelectedQuestionViewController
            guest.selectedQuestion = sender as! question
        }
    }

}

// final set uo for search bar
extension QuestionListViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(SearchText: searchController.searchBar.text!)
    }
}
