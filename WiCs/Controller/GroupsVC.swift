//
//  SecondViewController.swift
//  WiCs
//
//  Created by Edward Palermo on 1/24/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController
{
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    var groupsArray = [Group] ()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in //. observe does the updates in real time.
            DataService.instance.getAllGroups{ (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.groupsTableView.reloadData()
            }
        }
    }
}

//Dont forget you must put GroupCell in identifier
extension GroupsVC: UITableViewDelegate, UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as?
        GroupCell else {return UITableViewCell()}
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDesc, memberCount: group.memberCount)
        return cell
    }
    
    // Whatever cell is selected, will be presented (the group will be presented)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Use guard let incase it doesn't return a value
        guard let groupFeedVC = storyboard?.instantiateViewController (withIdentifier: "GroupFeedVC") as?
            GroupFeedVC else {return}
        groupFeedVC.initGroupData(forGroup: groupsArray[indexPath.row])
            present(groupFeedVC, animated: true, completion: nil)
    }
}



