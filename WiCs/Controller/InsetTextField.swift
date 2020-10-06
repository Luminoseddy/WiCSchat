//
//  InsetTextField.swift
//  WiCs
//
//  Created by Edward Palermo on 1/24/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//


import UIKit

class InsetTextField: UITextField
{
    
    private var textSetOffSet: CGFloat = 20 // how far we want to shift the rectangle
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0) // What the padden should look like on the rectangle
    
    
// To customize its look we need to implement overrides.
    override func awakeFromNib(){
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)])
        self.attributedPlaceholder = placeholder
        super.awakeFromNib()
    }
    
    // give rectangle so it knows to inset it X amount
    // when looking at text inside text rectangle without editing/modifying
    override func textRect(forBounds bounds: CGRect) -> CGRect{
        // takes rectangle, takes the insets, and returns the rectangle taking into account the amount you want in the set
        //  UIEdgeInsetsInsetRect: Creates the rectangle with specified Inset
        return UIEdgeInsetsInsetRect(bounds, padding)
        
    }
    
    // The rectangle that you're typing the text in.
    override func editingRect(forBounds bounds: CGRect) -> CGRect{
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // Placeholder text
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect{
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    // Called from awakeFromNib
    // gives access to the keys
}


