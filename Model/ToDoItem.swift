//
//  ToDoItem.swift
//  Todoey
//
//  Created by Brian Barr on 7/6/18.
//  Copyright © 2018 AgileTrailblazers. All rights reserved.
//

import Foundation

class ToDoItem : Codable {
    var toDoItemText : String = ""
    var toDoItemChecked : Bool = false
    
    init(toDoItemText : String, toDoItemChecked : Bool) {
        self.toDoItemText = toDoItemText
        self.toDoItemChecked = toDoItemChecked
    }
    
//    required init(coder aDecoder: NSCoder) {
//        self.toDoItemText = (aDecoder.decodeObject(forKey: "toDoItemText") as? String)!
//        self.toDoItemChecked = (aDecoder.decodeObject(forKey: "toDoItemChecked") as? Bool)!
//        self.init(toDoItemText: toDoItemText, toDoItemChecked: toDoItemChecked)
//    }
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(self.toDoItemText, forKey: "toDoItemText")
//        aCoder.encode(self.toDoItemChecked, forKey: "toDoItemChecked")
//    }
}
