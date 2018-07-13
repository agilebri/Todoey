//
//  Category.swift
//  Todoey
//
//  Created by Brian Barr on 7/10/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    
    let toDoItems = List<ToDoItem>()
}

