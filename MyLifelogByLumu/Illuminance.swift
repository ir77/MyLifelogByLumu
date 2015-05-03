//
//  Illuminance.swift
//  MyLifelogByLumu
//
//  Created by ucuc on 5/3/15.
//  Copyright (c) 2015 ucuc. All rights reserved.
//

import Foundation
import CoreData

@objc(Illuminance)
class Illuminance: NSManagedObject {

    @NSManaged var illuminance: NSNumber
    @NSManaged var timeStamp: String
    @NSManaged var createdAt: NSDate

}
