//
//  Item.swift
//  ToDo
//
//  Created by Eric Anderson on 6/21/18.
//  Copyright © 2018 Eric Anderson. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
  @objc dynamic var dateCreated: Date?
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
