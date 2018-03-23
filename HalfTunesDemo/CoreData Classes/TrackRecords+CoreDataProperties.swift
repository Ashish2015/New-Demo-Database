//
//  TrackRecords+CoreDataProperties.swift
//  HalfTunesDemo
//
//  Created by Ashish LLC Prajapati on 23/03/18.
//  Copyright © 2018 Ashish LLC Prajapati. All rights reserved.
//
//

import Foundation
import CoreData


extension TrackRecords {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackRecords> {
        return NSFetchRequest<TrackRecords>(entityName: "TrackRecords")
    }

    @NSManaged public var name: String?
    @NSManaged public var artist: String?
    @NSManaged public var previewURL: String?

}
