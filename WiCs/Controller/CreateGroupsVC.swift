//
//  CreateGroupsVC.swift
//  WiCs
//
//  Created by Edward Palermo on 2/16/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController
{

    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var groupMemberLabel: UILabel!
    
    
    var emailArray = [String]()
    var chosenUserArray = [String] () // holds all emails we choose while searching for emails.
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        emailSearchTextField.delegate = self // because of extension, we have the ability to control and interact with textfield the way we want to. 
        emailSearchTextField.addTarget(self, action: #selector(textFiedldDidChange),for: .editingChanged) // this calls a notification for every key you type in.
    }
    
    override func viewWillAppear(_ animated: Bool) {
             super.viewWillAppear(animated)
             doneBtn.isHidden = true
    }

    
    // 2 things we need to think about
    // When typing it should be searching and updatying the email array
    // and when removing all characters it should clear array and reload the table view with no cells.
    @objc func textFiedldDidChange(){ // call this above inside the selector
        if emailSearchTextField.text == ""{ // if theres nothing in textField search, reload tableView.
            emailArray = [] // Creating array.
            tableView.reloadData()
        }
        else{
            // search query is coming from textField
            DataService.instance.getEmail (forSearchQuery: emailSearchTextField.text!, handler:{
                (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            } )
        }
    }

    @IBAction func doneBtnWasPressed(_ sender: Any){
        if titleTextField.text != "" && descriptionTextField.text != "" {
            DataService.instance.getIds(forUsersnames: chosenUserArray, handler: { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                // Fucntion ahas been created ^^
                
                DataService.instance.createGroup(withTitle: self.titleTextField.text!, andDescription:
                    self.descriptionTextField.text!, forUserIds: userIds, handler: { (groupCreated) in
                        if groupCreated {
                            self.dismiss(animated: true, completion: nil)
                        }
                        else{
                            print ("Failed to create group. Try again.")
                        }
                    })
                })
            }
        }
    
    @IBAction func closeBtnPressed(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    

    /*
     ** KEYBOARD FUNCTIONS **
     */
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
        //tableView.delegate = selftable.dataSource = self
    }
    
    //Hide keyboaard when user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{ // ->Bool: returning Bool
        textField.resignFirstResponder()
        return(true)
    }
    
    @IBAction func closedBtnPressed(_ sender: Any){
        dismiss(animated: true, completion: nil) //gets rid off the VC
    }
}



extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return emailArray.count // returns the amount in the array.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
            else{
                return UITableViewCell()
        }
        
        let profileImage = UIImage (named: "defaultProfileImage")
        // check index path of cell, compare it with chosenUserArray, and see if chosenUserArray ia selected,
        // If they're in the chosenUserArray, they should show as selected
        if chosenUserArray.contains(emailArray[indexPath.row]) {
            // emailArray[indexPath.row] -> if we have first cell it pulls out first user from the array and pas it as the proper cell.
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: true) // if they're selected show checkmark
        }
        else{
            cell.configureCell(profileImage: profileImage!, email: emailArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    
    //Use to create temp array for all the people selected when searching for emails.
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at : indexPath) as? UserCell // creating cell pull the email from the cell
            else{
                return
        }
        
        // If user in array is not added yet, then add them, that way you don't add doubles.
        if !chosenUserArray.contains(cell.emailLabel.text!){
            chosenUserArray.append(cell.emailLabel.text!) // The email is added.
            groupMemberLabel.text = chosenUserArray.joined(separator: ", ") // When tapping on user, it appears on label on top; adds a seperator "," for after every string
            doneBtn.isHidden = false // show done button when someone is tapped.
        }
        else{
            chosenUserArray = chosenUserArray.filter( {$0 != cell.emailLabel.text!} ) // filter is like a forloop, $0 temp variable, then is updated with everyone except the one whjo we tapped.
            
            if chosenUserArray.count >= 1{
                groupMemberLabel.text = chosenUserArray.joined(separator: ", ")
            }
            else{
                groupMemberLabel.text = "add people to your group"
                doneBtn.isHidden = true
            }
        }
    }
}

// no reauired del;egate methods needed. but we can use it to monitor the stuff in text field
extension CreateGroupsVC: UITextFieldDelegate{
    
}
















