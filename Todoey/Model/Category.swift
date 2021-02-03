//
//  Category.swift
//  Todoey
//
//  Created by Desiree on 2/3/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //forward relationship
    let items = List<Item>()
}
