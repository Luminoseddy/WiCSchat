//
//  FeedCell.swift
//  WiCs
//
//  Created by Edward Palermo on 1/28/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell
{
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    func configureCell(profileImage: UIImage, email: String, content: String)
    {
        self.profileImage.image = profileImage
        self.emailLabel.text = email
        self.contentLabel.text = content
    }
    
}
