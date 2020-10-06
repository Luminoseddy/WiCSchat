
import UIKit
import Firebase


class CreatePostVC: UIViewController
{
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        textView.delegate = self // call the extension, makes the view controller the delegate for the textView
        sendButton.bindToKeyboard()
        
    }
    
    // call before the view loadss, and upload the view changes, hence it doesn't show the wrong
    // email first then the right one. Isntead it show the right one right off the bat.
    // because we are logged in, we pull the data right out of firebase, email property pulls out the email name.
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.emailLabel.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func sendButtonPressed(_ sender: Any)
    {
        //is good, for the time that is sending.
        //This is where the data also gets sent into firebase. 
        if textView.text != nil && textView.text != "Post about your life right here... -> <- "
        {
            sendButton.isEnabled = false // For time sending, disbale button, that way no double/triple sent
            DataService.instance.uploadPost(withMessage:textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey:nil, sendComplete:
            {
                (isComplete) in
                if isComplete
                {
                    self.sendButton.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                }
                else
                {
                    self.sendButton.isEnabled = true
                    print("There was an error homie G, try again")
                }
            })
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }    
}

//So we can tell when it edits so it can remove "Write something here"
extension CreatePostVC: UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        //If it begins editing.
        textView.text = ""
    }
}











