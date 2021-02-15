//
//  AboutViewController.swift
//  HackChat
//
//  Created by AJ Batja on 2/7/21.
//

import UIKit
import Firebase

class AboutViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    var imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.emailLabel.text = Auth.auth().currentUser?.email
    }
    
    @objc func handleTap() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true

            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            StorageService.instance.uploadProfileImage(withImage: image, forUID: Auth.auth().currentUser!.uid) { (complete) in
                if complete {
                    let imageUrl = "images/\(Auth.auth().currentUser!.uid)"
                    DataService.instance.uploadProfileImage(forUID: Auth.auth().currentUser!.uid, withImageUrl: imageUrl) { (complete) in
                        if complete {
                            print("Uploaded Image")
                        }
                    }
                } else {
                    print("Erro")
                }
            }
        }
        self.imagePicker.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func signoutButtonPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            do {
                try Auth.auth().signOut()
                let loginViewController = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as? LoginViewController
                loginViewController?.modalPresentationStyle = .fullScreen
                self.present(loginViewController!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
    
    
}
