//
//  ViewController.swift
//  movingView
//
//  Created by Mack FitzPatrick on 10/22/16.
//  Copyright © 2016 Mack FitzPatrick. All rights reserved.
//

import UIKit
import Darwin

class ViewController: UIViewController {
    
    var hits = 0
    var counter = 0.0
    var timer = Timer()
    
    var location = CGPoint(x: 0, y: 0)
    
    @IBOutlet weak var hider: UIView!
    @IBOutlet weak var person: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touch : UITouch = touches.first as UITouch!
        location = touch.location(in: self.view)
        person.center = location
        label.text = "X: " + String(describing: location.x) + "Y: " + String(describing: location.y)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch = touches.first as UITouch!
        location = touch.location(in: self.view)
        person.center = location
        label.text = "X: " + String(describing: location.x) + "\nY: " + String(describing: location.y)
        
        if (hider.center == person.center){
            counter += 5.0
            hits += 1
            hitsLabel.text = "Covered: " + String(hits)
            randomize()
        }
    }
    
    @IBOutlet weak var hitsLabel: UILabel!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    // set random color generator
    func getRandomColor() -> UIColor{
        //Generate between 0 to 1
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
    
    // set hider to a random position
    func randomize() {
        let intMax = 300
        
        self.hider.backgroundColor  = getRandomColor()
        
        let setX = arc4random_uniform(UInt32(intMax))
        let setY = arc4random_uniform(UInt32(intMax))
        
        let cgfloatX = CGFloat(setX)
        let cgfloatY = CGFloat(setY)
        
        hider.center = CGPoint(x: cgfloatX, y: cgfloatY + 250)
    }
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (keychain.get("highScore") == nil){
            keychain.set("0", forKey: "highScore")
        }
        
        highScoreLabel.text = "High Score:" + keychain.get("highScore")!
        counter = 30.0
        hits = 0
        alertLabel.text = ""
        hitsLabel.text = "Covered: " + String(hits)
        
        randomize()
        
        person.center = CGPoint(x: 200, y: 200)
        label.text = "X: " + String(describing: location.x) + "Y: " + String(describing: location.y)
        
        self.person.layer.zPosition = 1;
        
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    // called every time interval from the timer
    func timerAction() {
        counter -= 0.1
        timerLabel.text = String(format: "%.1f", counter)
        if (counter < 0.0){
            timer.invalidate()
            counter = 0.0
            alertLabel.layer.zPosition = 1
            alertLabel.text = "GAME OVER!"
            if (hits > Int(keychain.get("highScore")!)!){
                highScoreLabel.text = "High Score:" + String(hits)
                self.keychain.set(String(hits), forKey: "highScore")
            }
        }
    }
    
    @IBAction func restart() {
        viewDidLoad()
    }
    
    let keychain = KeychainSwift()

}

