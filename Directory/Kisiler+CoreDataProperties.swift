//
//  Kisiler+CoreDataProperties.swift
//  Directory
//
//  Created by MacBook on 26.02.2022.
//
//

import Foundation
import CoreData


extension Kisiler {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Kisiler> {
        return NSFetchRequest<Kisiler>(entityName: "Kisiler")
    }

    @NSManaged public var kisi_tel: String?
    @NSManaged public var kisi_ad: String?

}

extension Kisiler : Identifiable {

}
