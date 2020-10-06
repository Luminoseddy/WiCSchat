//
//  DataService.swift
//  WiCs
//
//  Created by Edward Palermo on 1/24/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import UIKit
import Foundation
import Firebase


let DB_BASE = Database.database().reference() // Allows access to URL of the database

class DataService
{
    static let instance = DataService() // Creating the instance of this class inside itself
    
    
    private var _REF_BASE = DB_BASE // our database
    
    
    private var _REF_USERS = DB_BASE.child("Usernames")
//    private var _REF_PASSW = DB_BASE.child("Passwords")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("statusUpdates")
    
    /*
       - Accesors
       - 4 public variables accessing the private ones
       - If we need to set or access, we can pull the values from the private variables. */
    var REF_BASE:  DatabaseReference{ return _REF_BASE   }
    var REF_USERS: DatabaseReference{ return _REF_USERS  }
    var REF_GROUPS:DatabaseReference{ return _REF_GROUPS }
    var REF_FEED:  DatabaseReference{ return _REF_FEED   } //using firebase closures so to get values out, a completion handler
    
    // uid -> unique ID
    // passing in data using Dictionary, type String and any value to push data into firebase
    func createDBUser(uid: String, userData: Dictionary <String, Any>) {
        /*
           - access REF USERS and create a new child path String (uid) access the dictionary "userData"
           - path String (uid) passing in "userData" dictionary inside the updateChildValue */
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    // convert the uID from firebase to the username
    // using firebase closures, so to get values out we need to use a completion handler
    // type handler >> escape, inside function, pass username,used at the end for when we have the username
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        // Observe user reference, and cycle through all users, and find one that matches the UID thats passed in

        // We call REF_USERS.observeSingleEvent, single because we only need for it to look through it one time.
        // we observe, value, all values inside the user refference.
        // and then we get snapshot back 'usersnapshot'
        
        REF_USERS.observeSingleEvent(of: .value) {(userSnapshot) in
            // Creaate a constant that holds that snapshot, and then create the for loop that cycles through all of them.
            //  _ = usernsapshot (that got returned) .children (all childeren inside the usersnap shot)
            // and return all objects, with force cast as array [DataSnapshot]
            // if empty, we have the else, which returns and exits.
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot]
            else
            {
                return
                
            }
            // This checks to see if user .key is = to uid we pass in, then call handler and pass in a
            // child called email. From registerUser function.
            // We want the value not the key, and passed as a string, because it has to be read through handler
            // as a string.
            // Once uid passed, it'll cycle through, find user that matches uid, then returns the email back.
            for user in userSnapshot
            {
                if user.key == uid
                {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }

    // groupKey is optional, we may have it, we may not.
    func uploadPost (withMessage message: String, forUID uid: String, withGroupKey groupKey: String?,
                     sendComplete: @escaping (_ status: Bool) -> ())
    {
        // is the send complete or not? Handler.
        // escaping to get out of firebase exclosure.
        /* returns empty function */
            if groupKey != nil
            {   // When sending a message, automatically creates it on Firebase
                // inside the child we are passing the senders uid, and we updateChild with a dictionary
                // creates messages folder inside any group, assigns each message a random id, and inside it
                // will have a content and message from uid
               
                REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderID": uid])
                // Send to group refferences
                sendComplete(true) // telling handler we'ire done messaging
            }
            else
            {
                // pass it to the feed. generate unique identifier for every message that comes in
                // Needs contents: comes from message parameter we pass in senderID, so we know who sent it.
                self.REF_FEED.childByAutoId().updateChildValues( ["content": message, "senderID": uid] )
                sendComplete(true)
            }
    }
    
    func getAllFeedMessages(handler: @escaping(_ messages: [Message])-> ())
    {
        //use modeal layer to return array of message.
        // pass message to view controller and oad it into function.
        // using handler always needsa return, just a return a function, doesn't really matter what it returns.
        // Observe single event, and we want to download every message
        var messageArray = [Message] () //cycle through every datasnapshot.
        REF_FEED.observeSingleEvent(of: .value)
        {   // [DataSnapShot]pull all objects out of feed.
            (feedMessageSnapshot) in guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot]
            
            else
            { // if no objects, return.
                return
            }
           
            // cycle through the messages
            for message in feedMessageSnapshot
            {
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderID").value as! String
                let message = Message (content: content, senderId: senderId)
                messageArray.append(message)
            }
            handler(messageArray) // can download messages and pass them into an array of type message
        }
    }
    
    
    
    
    // getEmail (what we want back) we pass in query type string
    // we want an array to return on all potential emails.  Like if you type "ca" it'll
    // return carol, carlos, ca___ etc.
    
    func getEmail (forSearchQuery query: String, handler: @escaping ( _ emailArray: [String] ) -> () )
    {
        //create email array
        // .value means, any data changes at the location, or recursively at any childs node.
        
        var emailArray = [String]()
        REF_USERS.observe(.value) // looks through entire user reference. Look through all and returns that match search query
        {
            (userSnapshot) in
            // create insatance od userSnapshotlook through it with for loop
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot]
                else {  return } // if we can't do it return )exit function
            
            for user in userSnapshot // loop through all users. Once found, iot takes user and pulls out email.
            {
                let email = user.childSnapshot(forPath: "email").value as! String // Pull out email, save as constant.
                
                //!= Auth.auth().currentUser?.email ->  your account shouldn't appear in the query when searching
                if email.contains(query) == true && email != Auth.auth().currentUser?.email
                {
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getIds(forUsersnames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()){
        //observe a single value, cycle through one time, return all id's from usernames that we pass in
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            var idArray = [String] ()
                guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
        
        for user in userSnapshot{
            let email = user.childSnapshot(forPath: "email").value as! String
            
            if usernames.contains(email){
                idArray.append(user.key)
                
            }
        }
        handler(idArray)
        }
    }
        //Creates the groups inside the firebase, if you go up on top, you cdan see how we initializze REZ_GROUP
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
            self.REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members":ids])
            handler(true)
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()) {
        var groupMessageArray = [Message] ()
        
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) {
            (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for groupMessage in groupMessageSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderId: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray) // after for loop done, call handler to return messages
            // Now we can set it up in GroupVC
        }
    }
    
    
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()){
        var emailArray = [String] ()
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapshot {
                if group.members.contains(user.key){ // if member contains key from userSnapshot
                    let email = user.childSnapshot(forPath: "email").value as! String // pull oput value and cast as string
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of:.value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for group in groupSnapshot {
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                
                let title = group.childSnapshot(forPath:"title").value as! String
                let descruiption = group.childSnapshot(forPath: "description").value as! String
                
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let group = Group(title: title, description: descruiption, key: group.key, members: memberArray, memberCount: memberArray.count)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
    }
}
// Function that converts email into ID from firebase.
// Firebase
// Every message has a content and senderId
// every account has id and email.

