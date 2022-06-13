//
//  DrinksEntity+CoreDataProperties.swift
//  Perfect Drink
//
//  Created by Aravind P on 12/03/22.
//
//

import Foundation
import CoreData


extension DrinksEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinksEntity> {
        return NSFetchRequest<DrinksEntity>(entityName: "DrinksEntity")
    }

    @NSManaged public var idDrink: String?
    @NSManaged public var strDrink: String?
    @NSManaged public var strInstructions: String?
    @NSManaged public var strDrinkThumb: String?

}

extension DrinksEntity : Identifiable {

}
