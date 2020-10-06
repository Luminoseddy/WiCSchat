//
//  FirstViewController.swift
//  WiCs
//
//  Created by Edward Palermo on 1/24/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController
{
    
    @IBOutlet weak var tableView: UITableView!
    
    var messageArray = [Message] ()
    let messageBubbleBackground = UIView()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.tableView.reloadData()
        // must set the delegates and dataSource below so it knnows where to obtain data
         configureViewTable()
        
    }
    
    //download messages and fill the local array in FeedVC
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        DataService.instance.getAllFeedMessages{
            (returnedMessagesArray) in
            // the .reverse() this takes the array of feedback post and allow last update to be on top.
            self.messageArray = returnedMessagesArray.reversed()
            self.tableView.reloadData()
        }
    }
    
    func configureViewTable(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    func messageBackground(){
        
        let messageBackground = [ messageBubbleBackground.backgroundColor = .green,
        messageBubbleBackground.translatesAutoresizingMaskIntoConstraints = false,
//        addSubview(messageBubbleBackground),
        messageBubbleBackground.topAnchor.constraint(equalTo: FeedCell().contentLabel.topAnchor, constant: 16),
        messageBubbleBackground.leadingAnchor.constraint(equalTo: FeedCell().contentLabel.leadingAnchor, constant: 16),
        messageBubbleBackground.bottomAnchor.constraint(equalTo: FeedCell().contentLabel.bottomAnchor, constant: 16),
        messageBubbleBackground.widthAnchor.constraint(equalToConstant: 50) ] as [Any]
        
        NSLayoutConstraint.activate(messageBackground as! [NSLayoutConstraint])
    }
}

//The 3 functions are REQUIRED
extension FeedVC: UITableViewDelegate, UITableViewDataSource{
    //Number of sections in table view
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    //Number of rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return messageArray.count // returns the number of messages, if 5, then show 5.
    }
    
    //
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell
            
        
        else
        {
            return UITableViewCell()
        }
 
        let image = UIImage(named: "defaultProfileImage")
        let message = messageArray[indexPath.row] //populate the items in the array.
        
        //Gives email value to show in cell
        DataService.instance.getUsername(forUID: message.senderId)
        {
            (returnedUsername) in
            cell.configureCell(profileImage: image!, email: returnedUsername, content: message.content)
        }
        return cell
    }
    
    
    
}





