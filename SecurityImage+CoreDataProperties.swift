//
//  SecurityImage+CoreDataProperties.swift
//  Unify
//
//  Created by Zach Strenfel on 5/8/17.
//  Copyright © 2017 Zach Strenfel. All rights reserved.
//

import Foundation
import CoreData


extension SecurityImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SecurityImage> {
        return NSFetchRequest<SecurityImage>(entityName: "SecurityImage")
    }

    @NSManaged public var data: NSData?
    @NSManaged public var created_at: NSDate?

}
