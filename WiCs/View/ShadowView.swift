//
//  ShadowView.swift
//  WiCs
//
//  Created by Edward Palermo on 1/24/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit

class ShadowView: UIView{
    
    override func awakeFromNib(){
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        super.awakeFromNib()
    }
}
