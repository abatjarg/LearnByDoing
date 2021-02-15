//
//  StorageService.swift
//  HackChat
//
//  Created by AJ Batja on 2/15/21.
//

import Foundation
import Firebase

// Firebase realtime database refrence
let STORAGE_BASE = Storage.storage().reference()

class StorageService {
    static let instance = StorageService()
    
    private var _REF_BASE = STORAGE_BASE
    
    var REF_BASE: StorageReference {
        return _REF_BASE
    }
    
    func uploadProfileImage(withImage image: UIImage, forUID uid: String,  sendComplete: @escaping (_ status: Bool) -> ()) {
        REF_BASE.child("images/\(uid)").putData(image.pngData()!, metadata: nil) { (metadata, error) in
            if (error != nil) {
                sendComplete(true)
            }
        }
    }
    
    func getProfileImage(forUID uid: String, handler: @escaping (_ image: UIImage?) -> ()) {
        REF_BASE.child("images/\(uid)").getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                
            } else {
                let image = UIImage(data: data!)
                handler(image)
            }
        }
    }
}
