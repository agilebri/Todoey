//
//  Data.swift
//  Todoey
//
//  Created by Brian Barr on 7/9/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}

