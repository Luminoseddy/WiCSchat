//
//  Message.swift
//  WiCs
//
//  Created by Edward Palermo on 1/27/18.
//  Copyright © 2018 PalermoX. All rights reserved.
//

import Foundation

class Message
{
    
    private var _content: String
    private var _senderId: String
    
    var content: String
    {
        return _content
    }
    
    var senderId: String
    {
        return _senderId
    }
    
    // whenever we waant to create an object of m essage,
    // we init that message tith the right content and senderId
    // This function pulls all the data from the feed of firebase,
    // pass all the info into instance of message and append to an array
    // of messages that will be displayed in tableview
    init(content: String, senderId: String)
    {
        self._content = content // gives ability to access this content variable.
        self._senderId = senderId
    }
}
