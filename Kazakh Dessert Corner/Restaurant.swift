//
//  Foods.swift
//  Kazakh Dessert Corner
//
//  Created by Akhmet Tolepov on 07.11.2024.
//

import Foundation

struct Restaurant: Codable, Identifiable {
    let id = UUID() // Unique identifier for each restaurant
    let name: String
    let description: String
    let imageName: String
    let dishes: [Dish] // Array of dishes
}

struct Dish: Codable {
    let name: String
    let summary: String
    let longDescription: String
    let imageName: String
    let price: Int
    let customizationOptions: [CustomizationOption]? // Array of customization options
}

extension Dish: Identifiable {
    var id: String { name } // Use the name as the identifier
}

struct CustomizationOption: Codable, Identifiable {
    let id = UUID() // Unique identifier for each customization option
    let name: String // Name of the customization (e.g., Size, Sweetness Level, etc.)
    let options: [Option] // List of available options, each with a name and price
}

struct Option: Codable, Identifiable {
    let id = UUID() // Unique identifier for each option
    let option: String // Name of the option (e.g., Small, Medium, Large)
    let price: Int // Price adjustment for this option
}
