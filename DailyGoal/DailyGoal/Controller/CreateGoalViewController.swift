//
//  CreateGoalViewController.swift
//  DailyGoal
//
//  Created by AJ Batja on 2/17/21.
//

import UIKit

class CreateGoalViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermButton: UIButton!
    @IBOutlet weak var longTermButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalTextView.delegate = self
        
        nextButton.bindToKeyboard()
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
    }
    
    @IBAction func shortTermButtonPressed(_ sender: Any) {
        goalType = .shortTerm
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
    }
    
    @IBAction func longTermButtonPressed(_ sender: Any) {
        goalType = .longTerm
        shortTermButton.setDeselectedColor()
        longTermButton.setSelectedColor()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToFinishGoal" {
            guard let destination = segue.destination as? FinishGoalViewController else {
                return
            }
            destination.initData(description: goalTextView.text, type: goalType)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextView.text = ""
    }
}
