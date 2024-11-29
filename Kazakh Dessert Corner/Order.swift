import Foundation

@Observable
class Order: Codable {
    var quantity: Int = 1
    var totalPrice = 0
    var itemName: String = "" // Название блюда
    var selectedOptions: [String] = [] // Массив для выбранных опций
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var items: [Dish] = [] // An array of dishes in the order

        // You can add additional properties and methods if needed
    func addDish(_ dish: Dish) {
            items.append(dish)
        }
    // Проверка на пустые поля и валидация
    var check: Bool {
        if name.isEmpty || streetAddress.isEmpty || city.isEmpty || zip.isEmpty {
            return true
        }
        
        let nameRegex = "^[a-zA-Zа-яА-ЯёЁ\\s]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        if !namePredicate.evaluate(with: name) {
            return true
        }
        
        let zipRegex = "^[0-9]+$"
        let zipPredicate = NSPredicate(format: "SELF MATCHES %@", zipRegex)
        if !zipPredicate.evaluate(with: zip) {
            return true
        }
        
        let addressRegex = "^[a-zA-Zа-яА-ЯёЁ0-9\\s]+$"
        let addressPredicate = NSPredicate(format: "SELF MATCHES %@", addressRegex)
        if !addressPredicate.evaluate(with: streetAddress) {
            return true
        }
        
        return false
    }
    
    // Метод для сохранения в UserDefaults
    func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "currentOrder")
        }
    }
    
    // Статический метод для загрузки заказа
    static func loadFromUserDefaults() -> Order? {
        if let savedOrder = UserDefaults.standard.object(forKey: "currentOrder") as? Data {
            return try? JSONDecoder().decode(Order.self, from: savedOrder)
        }
        return nil
    }
}
