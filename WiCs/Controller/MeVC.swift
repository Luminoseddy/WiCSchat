//
//  MeVC.swift
//  WiCs
//
//  Created by Edward Palermo on 1/25/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self 
    }
    
    override func viewWillAppear (_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.emailLabel.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func signOutButtonPressed(_ sender: Any)
    {
        //This is where the warning screen pops up from the bottom
        let logoutPopup = UIAlertController(title: "_ Moment of truth _", message:"Are you for sure for sure you want to log out?", preferredStyle: .actionSheet) // actin sheet pops up frm om the bottom.
        
        // .desctructive: used to destroy/remove the account from the app. -> signout.
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive)
        {
            (buttonTapped) in
            // error handler.
            // could possibly have errors. use a try catch block.
            do
            {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                
                self.present(authVC!, animated: true, completion: nil)
            }
            catch
            {
                print(error) // comes from signout. but using catch block it automatically captures a vairable called error, so if theres a problem we'll know
            }
        }
        
        logoutPopup.addAction(logoutAction) // call the pop up
        present(logoutPopup, animated: true, completion: nil)
    }
    
    // Upload picture
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func loadingImageButtonTapped(_ sender: UIButton)
    {
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .photoLibrary
//        present(imagePicker, animated: true, completion: nil)
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    
    {
        dismiss(animated: true, completion: nil)
    }
    
}




