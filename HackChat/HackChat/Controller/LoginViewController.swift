//
//  LoginViewController.swift
//  HackChat
//
//  Created by AJ Batja on 2/7/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if usernameField.text != nil && passwordField.text != nil {
            AuthService.instance.loginUser(withEmail: usernameField.text!, andPassword: passwordField.text!) { (success, loginError) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    print(String(describing: loginError?.localizedDescription))
                }
                
                AuthService.instance.registerUser(withEmail: self.usernameField.text!, andPassword: self.passwordField.text!) { (success, registrationError) in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.usernameField.text!, andPassword: self.passwordField.text!) { (success, _) in
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully registered user")
                        }
                    } else {
                        print(String(describing: registrationError?.localizedDescription))
                    }
                }
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
}
