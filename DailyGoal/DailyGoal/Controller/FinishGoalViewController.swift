//
//  FinishGoalViewController.swift
//  DailyGoal
//
//  Created by AJ Batja on 2/18/21.
//

import UIKit

class FinishGoalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createGoalButton: UIButton!
    @IBOutlet weak var pointTextField: UITextField!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pointTextField.delegate = self
        // Do any additional setup after loading the view.
        createGoalButton.bindToKeyboard()
    }
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }

    @IBAction func createGoalButtonPressed(_ sender: Any) {
        if pointTextField.text != "" {
            self.save { (complete) in
                if complete {
                    print("Saved")
                    navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pointTextField.text = ""
    }
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return
        }
        let goal = Goal(context: managedContext)
        goal.goalDescription = goalDescription
        goal.goalType  = goalType.rawValue
        goal.goalCompletionValue = Int32(pointTextField.text!)!
        goal.goalProgress = Int32(0)
        
        do {
            try managedContext.save()
            completion(true)
        } catch  {
            print("Error: \(error.localizedDescription )")
            completion(false)
        }
    }
    
}
