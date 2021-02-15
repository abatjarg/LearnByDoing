//
//  CreateGroupViewController.swift
//  HackChat
//
//  Created by AJ Batja on 2/9/21.
//

import UIKit
import Firebase

class CreateGroupViewController: UIViewController {
    
    
    
    @IBOutlet weak var titleTextfield: InsetTextField!
    @IBOutlet weak var descriptionTextfield: InsetTextField!
    @IBOutlet weak var emailSearchTextfield: InsetTextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var peopleTableView: UITableView!
    @IBOutlet weak var groupMemberLabel: UILabel!
    

    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        emailSearchTextfield.delegate = self
        // Add listener for text field editing change
        emailSearchTextfield.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneButton.isEnabled = false
    }
    
    @objc func textFieldDidChange() {
        if emailSearchTextfield.text == "" {
            emailArray = []
            peopleTableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailSearchTextfield.text!) { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.peopleTableView.reloadData()
            }
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        if titleTextfield.text != "" && descriptionTextfield.text != "" {
            DataService.instance.getIds(forUsernames: chosenUserArray) { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(withTitle: self.titleTextfield.text!, andDescription: self.descriptionTextfield.text!, forUserIds: userIds) { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("Unable to create the group")
                    }
                }
            }
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateGroupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = peopleTableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell else {
            print("Error")
            return UITableViewCell()
        }
        let profileImage = UIImage(named: "defaultProfileImage")
        if chosenUserArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserTableViewCell else {
            return
        }
        if !chosenUserArray.contains(cell.emailLabel.text!) {
            chosenUserArray.append(cell.emailLabel.text!)
            groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            doneButton.isEnabled = true
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLabel.text! })
            if chosenUserArray.count >= 1 {
                groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            } else {
                groupMemberLabel.text = "add people to your group"
                doneButton.isEnabled = false
            }
        }
    }

}

extension CreateGroupViewController: UITextFieldDelegate {
    
}
