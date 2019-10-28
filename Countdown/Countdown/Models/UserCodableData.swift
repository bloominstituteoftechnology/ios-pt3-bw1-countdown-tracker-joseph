//
//  UserCodableData.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/28/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation

struct CountdownCodableInfo: Codable, Equatable {
    var name: String?
    var countdownExistingNotes: String?
}
