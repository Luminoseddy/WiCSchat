//
//  UserCell.swift
//  WiCs
//
//  Created by Edward Palermo on 2/16/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell
{
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    var showing = false
    
    func configureCell (profileImage image: UIImage, email: String, isSelected: Bool)
    {
        self.profileImage.image = image
        self.emailLabel.text = email // email the one we pass in from function
        
        // If name is selected, then check image shows, isHidden = false.
        if isSelected
        {
            checkImage.isHidden = false
        }
        else
        {
            // hidden is true because nothing has been selected yet.
            self.checkImage.isHidden = true
        }
    }

    
    
    // This confiures the view for selected state,
    // we uawe it to toggle checkmark, so when selected it will be non-hidden
    // then when selected again it will be hidden
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        if selected // If tapped on the cell. 
        {
            if showing == false
            {
                checkImage.isHidden = false
                showing = true
            }
            else
            {
                checkImage.isHidden = true
                showing = false
            }
        }
    }
}
