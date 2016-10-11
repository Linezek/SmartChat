//
//  Message.swift
//  chatchat
//
//  Created by Antoine Galpin on 07/10/2016.
//  Copyright © 2016 Antoine Galpin. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var fromId: String?
    var text: String?
    var toid: String?
    var timestamp: NSNumber?
    
    func chatPartnerId() -> String? {
        if fromId == FIRAuth.auth()?.currentUser?.uid {
            return toid
        } else {
            return fromId
        }
    }
}
