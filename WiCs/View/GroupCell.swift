//
//  GroupCell.swift
//  WiCs
//
//  Created by Edward Palermo on 2/19/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var groupDescriptionLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    
    
    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupTitleLabel.text = title
        self.groupDescriptionLabel.text = description
        self.memberCountLabel.text = "\(memberCount) members."
    }
    
}
