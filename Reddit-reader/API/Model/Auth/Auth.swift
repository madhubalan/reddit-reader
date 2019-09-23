//
//  Auth.swift
//  Reddit-reader
//
//  Created by Madhu on 23/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit

struct Auth: Codable {

    let access_token : String?
    let token_type : String?
    let device_id : String?
    let expires_in : Int
    let scope : String?
}
