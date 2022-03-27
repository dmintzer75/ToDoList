//
//  Item.swift
//  ToDoList
//
//  Created by Dario Mintzer on 24/03/2022.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    //Set the relationship: the class type (Category.self) and the property inside that will be linked (items)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
