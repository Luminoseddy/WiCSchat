//
//  GroupFeedVC.swift
//  WiCs
//
//  Created by Edward Palermo on 2/24/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    //Set up the tableView
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel! // This will change as VC is opened.
    @IBOutlet weak var membersLabel: UILabel!
    @IBOutlet weak var sendButtonView: UIView!
    
    @IBOutlet weak var messageTextField: InsetTextField!
    @IBOutlet weak var sendButton: UIButton!
    
   
    var group: Group?
    var groupMessages = [Message]() // Array that holds all messages
    
    func initGroupData(forGroup group: Group){
        self.group = group
    }
    
    // Set up table view
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButtonView.bindToKeyboard() // uses extension to bindkeyboard to slide up when typing.
        tableView.delegate = self
        tableView.dataSource = self
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set title and label with all the information
        // without having to get to firebase. 
        groupTitleLabel.text = group?.groupTitle
        
        //Converts all the uid's into their usernames (emails)
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in // we get array back as returnedEmails
            self.membersLabel.text = returnedEmails.joined(separator:", ")
        }
        
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, handler:
                { (returnedGroupMessages) in
                    self.groupMessages = returnedGroupMessages // group messages returned
                    self.tableView.reloadData() // all messages load where thy're suppose to be.
                    
                    
                    //Animates the text to the bottom whenever a message has been recieved
                    if self.groupMessages.count > 0 {
                        self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0),
                                                   at: .none, animated: true)
                    }
            })
        }
    }
    
    
    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendButton.isEnabled = false
            DataService.instance.uploadPost(withMessage: messageTextField.text!, forUID:
                Auth.auth().currentUser!.uid, withGroupKey: group?.key , sendComplete: { (complete) in
                     // because we are in a closure we need to use self.
                    if complete {
                        self.messageTextField.text = "" // Blanks out message after sending, that way you don';t send the same message multi times
                        self.messageTextField.isEnabled = true
                        self.sendButton.isEnabled = true
                        
                    }
            })
        }
    }
    
    @IBAction func backButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}





extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count // returns ##messages
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as?
                GroupFeedCell else { return UITableViewCell() }
        
            let message = groupMessages [indexPath.row]
        
            DataService.instance.getUsername(forUID: message.senderId) { (email) in            
                cell.configureCell (profileImage: UIImage(named: "defaultProfileImage")!, email: email, content: //Here we can modify profile image settings
                message.content)
            }
            return cell
    }
}
