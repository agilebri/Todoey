//
//  ToDoItem.swift
//  Todoey
//
//  Created by Brian Barr on 7/10/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoItem : Object {
    @objc dynamic var toDoItemText : String = ""
    @objc dynamic var toDoItemChecked : Bool = false
    @objc dynamic var toDoItemDateCreated : Date = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "toDoItems")
}
