//
//  Category.swift
//  My Day
//
//  Created by Mihir Mesia on 07/11/18.
//  Copyright © 2018 Mihir Mesia. All rights reserved.
//
// this class created instead of data model used in coreData
import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    //defining forward relationship with Item class
    let items = List<Item>()
}
