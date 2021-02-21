//
//  UIButtonExtensions.swift
//  DailyGoal
//
//  Created by AJ Batja on 2/17/21.
//

import UIKit

extension UIButton {
    func setSelectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.09019607843, blue: 0.1411764706, alpha: 1)
    }
    
    func setDeselectedColor() {
        self.backgroundColor = #colorLiteral(red: 0.7607843137, green: 0.09019607843, blue: 0.1411764706, alpha: 0.4987142197)
    }
}
