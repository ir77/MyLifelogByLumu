//
//  Illuminance.swift
//  MyLifelogByLumu
//
//  Created by ucuc on 5/1/15.
//  Copyright (c) 2015 ucuc. All rights reserved.
//

import Foundation
import CoreData

@objc(Illuminance)
class Illuminance: NSManagedObject {

    @NSManaged var illuminance: NSNumber
    @NSManaged var timeStamp: NSDate

}
