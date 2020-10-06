//
//  AuthVC.swift
//  WiCs
//
//  Created by Edward Palermo on 1/24/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear (_ animated: Bool)
    {
        // When logged in, set view to dismiss (main menu view)
        // then check using firebase function Auth.auth.
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil
        {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // To go back. then simply drag and drop the button on the top of the VC: Exit
    @IBAction func unwindFromRegisterVC(unwindSegue: UIStoryboardSegue)
    {
        
    }

    @IBAction func signInWithEmailBtnPressed(_ sender: Any)
    {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
    @IBAction func signInWithGoogleBtnPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func signInWithFIUBtnPressed(_ sender: Any)
    {
        
    }
}
