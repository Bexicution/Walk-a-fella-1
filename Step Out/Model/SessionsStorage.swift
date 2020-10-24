//
//  SessionsStorage.swift
//  Step Out
//
//  Created by Mac on 8/21/20.
//  Copyright © 2020 Bexultan. All rights reserved.
//

import Foundation

class SessionsStorage {
    var sessions = [Person]()

    func add (_ session: Person) {
        sessions.append(session)
    }
}

