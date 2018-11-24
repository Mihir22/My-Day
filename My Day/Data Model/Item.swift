//
//  Item.swift
//  My Day
//
//  Created by Mihir Mesia on 07/11/18.
//  Copyright © 2018 Mihir Mesia. All rights reserved.
//This class created instead of item entity in dataModel

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated : Date?
    //defining reverse realtionship with category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
