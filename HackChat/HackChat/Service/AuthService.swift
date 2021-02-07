//
//  AuthService.swift
//  HackChat
//
//  Created by AJ Batja on 2/7/21.
//

import Foundation
import Firebase

class AuthService {
    
    static let instance = AuthService()
    
    // Register user using email and password
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            guard let data = data else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = [
                "provider": data.user.providerID,
                "email": data.user.email
            ]
            DataService.instance.createDBUser(uid: data.user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) ->
        ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            
            loginComplete(true, nil)
        }
    }
    
}
