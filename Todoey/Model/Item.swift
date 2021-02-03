//
//  Item.swift
//  Todoey
//
//  Created by Desiree on 2/3/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    //reverse relationship
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
