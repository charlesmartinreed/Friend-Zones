//
//  Friend.swift
//  Friend Zones
//
//  Created by Charles Martin Reed on 1/16/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import Foundation
import UIKit

struct Friend: Codable {
    var name = "New Friend"
    var timeZone = TimeZone.current //assuming most of your friends are nearby, geographically
}
