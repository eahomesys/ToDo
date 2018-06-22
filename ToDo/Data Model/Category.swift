//
//  Category.swift
//  ToDo
//
//  Created by Eric Anderson on 6/21/18.
//  Copyright © 2018 Eric Anderson. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name: String = ""
  let items = List<Item>()
}
