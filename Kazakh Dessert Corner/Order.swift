//
//  Order.swift
//  Kazakh Dessert Corner
//
//  Created by Akhmet Tolepov on 12.11.2024.
//

import Foundation
@Observable
class Order: Codable {
    var quantity: Int = 1
    var totalPrice = 0
    var itemName: String = ""
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var check: Bool {
        name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty
    }
}

extension Order {
    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "currentOrder")
        }
    }
    
    static func loadFromUserDefaults() -> Order? {
        if let savedOrder = UserDefaults.standard.object(forKey: "currentOrder") as? Data {
            return try? JSONDecoder().decode(Order.self, from: savedOrder)
        }
        return nil
    }
}


