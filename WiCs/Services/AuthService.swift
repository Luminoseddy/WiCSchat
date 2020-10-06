//
//  AuthService.swift
//  WiCs

//  Copyright © 2018 PalermoX. All rights reserved.
//

import Foundation
import Firebase


class AuthService{
    // allow static variable to be alive while program runs.
    static let instance = AuthService()
    
    // If user is not registered, it regesters the user then logs them in
    // If register then just simply logs them in.
    // withEmail, andPassword are internal parameters, they let you set the actual name of what information you're dealing with
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping // escape, so values can be sent out
        (_ status: Bool,_ error: Error?) -> ()){ //returns an empty function, Bool: is it complete T or F, then pass in the error. hence make it optional ? accepting nil.
        
        // firebase built in function, with values being passed in from this main function
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            //if user returns do this, handler that returns out of it.
            // Create the user if returned
            guard let user = user?.user else
            {
                userCreationComplete (false, error) // handling the error, false never created.
                return
            }
            
            // providor from firebase pulls out the providorId.
            let userData = ["provider": user.providerID, "email": user.email] //provider id can be facebook, google, ms, etc::
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, Any>) // This is how the data gets passed into firebase
            userCreationComplete(true, nil) // nil because theres no error.
        }
    }
    
    
    //account is already registered, simply call login function and call sign them in.
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping
        (_ status: Bool, _ error: Error?) -> ())
    {
        //Log in the user
        Auth.auth().signIn(withEmail: email, password: password){
            (user, error) in
            if error != nil
            {
                loginComplete (false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
