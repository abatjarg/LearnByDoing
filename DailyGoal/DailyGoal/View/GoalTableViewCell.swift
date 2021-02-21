//
//  GoalTableViewCell.swift
//  DailyGoal
//
//  Created by AJ Batja on 2/16/21.
//

import UIKit

class GoalTableViewCell: UITableViewCell {

    @IBOutlet weak var goalDescription: UILabel!
    @IBOutlet weak var goalType: UILabel!
    @IBOutlet weak var goalProgress: UILabel!
    @IBOutlet weak var goalCompletionView: UIView!
    
    func configureCell(goal: Goal) {
        self.goalDescription.text = goal.goalDescription
        self.goalType.text = goal.goalType
        self.goalProgress.text = String(describing: goal.goalProgress)
        if goal.goalProgress == goal.goalCompletionValue {
            self.goalCompletionView.isHidden = false
        } else {
            self.goalCompletionView.isHidden = true
        }
    }

}
