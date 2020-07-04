//
//  ViewController.swift
//  SwiftUIInsideUIKit
//
//  Created by abatjarg on 7/3/20.
//  Copyright © 2020 abatjarg. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    let button: UIButton = {
        var b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("SwiftUI", for: .normal)
        b.backgroundColor = .blue
        b.addTarget(self, action:#selector(handlePress), for: .touchUpInside)
        b.setTitleColor(.white, for: .normal)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func handlePress() {
        let vc = UIHostingController(rootView: SwiftUIView())
        present(vc, animated: true)
    }


}

