//
//  Message.swift
//  HackChat
//
//  Created by AJ Batja on 2/8/21.
//

import Foundation

struct Message {
    private var _content: String
    private var _senderId: String
    
    var content: String {
        return _content
    }
    
    var senderId: String {
        return _senderId
    }
    
    init(content: String, senderId: String) {
        self._content = content
        self._senderId = senderId
    }
}
