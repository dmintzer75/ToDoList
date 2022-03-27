//
//  Category.swift
//  ToDoList
//
//  Created by Dario Mintzer on 24/03/2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
