//
//  Expenditure+CoreDataProperties.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-23.
//
//

import Foundation
import CoreData


extension Expenditure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenditure> {
        return NSFetchRequest<Expenditure>(entityName: "Expenditure")
    }

    @NSManaged public var amount: Double
    @NSManaged public var dateTime: Date?
    @NSManaged public var title: String?
    @NSManaged public var frequencyMode: Int16

}

extension Expenditure : Identifiable {

}
