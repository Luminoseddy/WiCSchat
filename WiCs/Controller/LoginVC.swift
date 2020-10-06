//
//  LoginVC.swift
//  WiCs
//
//  Created by Edward Palermo on 1/24/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController
{
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    
    
    override func viewWillAppear (_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.emailField.text = Auth.auth().currentUser?.email // was emailLabel
    }

    
    
    
    @IBAction func signInBtnPressed(_ sender: Any){
        if emailField.text != nil && passwordField.text != nil{
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!,
            loginComplete:
            { (success, loginError) in  //Bool is success
                    
                //if success dismiss VC
                if success{
                    print("Account exist in database... Logging in.. Success")
                    self.dismiss(animated: true, completion: nil)
                }
                else{
                    print("Failed to login, account does not exist.")
                    print(String(describing: loginError?.localizedDescription))
                    
                    //This is where the warning screen pops up from the bottom
                    let loginPopup = UIAlertController(title: "Uh oh..", message:"Username or password is incorrect.", preferredStyle: .actionSheet) // actin sheet pops up from om the bottom.
                    
                    // .desctructive: used to destroy/remove the account from the app. -> signout.
                    let loginAction = UIAlertAction(title: "Try again", style: .destructive)
                    {
                        (buttonTapped) in
//                        // error handler.
//                        // could possibly have errors. use a try catch block.
//                        do
//                        {
//                            try Auth.auth().signOut()
//                            let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
//                            self.present(authVC!, animated: true, completion: nil)
//                        }
//                        catch
//                        {
//                            print(error) // comes from signout. but using catch block it automatically captures a vairable called error, so if theres a problem we'll know
//                        }
                    }
                    loginPopup.addAction(loginAction) // call the pop up
                    self.present(loginPopup, animated: true, completion: nil)
                }
                
                // If theres a success we remove the screen to main app, else we go here
//                AuthService.instance.registerUser (withEmail: self.emailField.text!, andPassword: self.passwordField.text!,
//                                                userCreationComplete:
//                { (success, registrationError) in
//                    if success
//                    {
//                        AuthService.instance.loginUser ( withEmail: self.emailField.text!, andPassword:
//                        self.passwordField.text!, loginComplete:
//                        {(success, registrationError) in
//                            self.dismiss(animated: true, completion: nil)
//                            print("UserRegistered")
//                        })
//                    }
//                    else
//                    {
//                        print(String(describing: registrationError?.localizedDescription))
//                    }
//                })
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
    
    @IBAction func closedBtnPressed(_ sender: Any){
        dismiss(animated: true, completion: nil) //gets rid off the VC
    }
}

extension LoginVC: UITextFieldDelegate
{
    
}





