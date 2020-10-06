//
//  RegisterVC.swift
//  WiCs
//
//  Created by Edward Palermo on 10/31/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit
import Firebase

class RegisterVC: UIViewController {

    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailField.delegate = self as? UITextFieldDelegate
        passwordField.delegate = self as? UITextFieldDelegate
    }
    
    @IBAction func continueBtnPressed(_ sender: Any)
    {
        if emailField.text != nil && passwordField.text != nil
        { // if email and password text fields are filled, then register the account
           AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!, loginComplete:
            {(success, loginError) in  //Bool is success
                //if success dismiss VC
                if success
                {
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    print(String(describing: loginError?.localizedDescription))
                    print("Failed to login, account does not exist.")
                    print(String(describing: loginError?.localizedDescription))
                    
                    //This is where the warning screen pops up from the bottom
                    let registerPopup = UIAlertController(title: "Uh oh..", message:"Email already exists.", preferredStyle: .actionSheet) // actin sheet pops up from om the bottom.
                    
                    // .desctructive: used to destroy/remove the account from the app. -> signout.
                    let registerAction = UIAlertAction(title: "Try again", style: .destructive)
                    {
                        (buttonTapped) in
                    }
                    registerPopup.addAction(registerAction) // call the pop up
                    self.present(registerPopup, animated: true, completion: nil)
                }
                AuthService.instance.registerUser (withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete:
                    {(success, registrationError) in
                        if success{
                            AuthService.instance.loginUser (withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete:
                                {(success, registrationError) in
                                    self.dismiss(animated: true, completion: nil)
                                    print("UserRegistered")
                            })
                        }
                        else
                        {
                            print(String(describing: registrationError?.localizedDescription))
                        }
                    })
            })
        }
    }
    
    /*
     ** KEYBOARD FUNCTIONS **
     */
    //Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    //Hide keyboaard when user presses return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // ->Bool: returning Bool type.
    {
        textField.resignFirstResponder()
        return(true)
    }
    
    @IBAction func closedBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil) //gets rid off the VC
    }
    
}
