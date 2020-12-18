//
//  Task+CoreDataProperties.swift
//  Task management
//
//  Created by Ivan Ivanušić on 18.12.2020..
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var more_info: String?

}

extension Task : Identifiable {

}
