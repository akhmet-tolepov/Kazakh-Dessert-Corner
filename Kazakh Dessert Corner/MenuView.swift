import SwiftUI

// Function to format prices for size options (with "k" suffix)
private func formatSizePrice(_ price: Int) -> String {
    if price >= 1000 {
        return String(format: "%.1f", Double(price) / 1000) + "k"
    } else {
        return "\(price)₸"
    }
}

// Function to format the total price (no "k" suffix)
private func formatTotalPrice(_ price: Int) -> String {
    return "\(price)₸"
}


struct MenuView: View {
    let dish: Dish
    @State private var selectedOptions: [String]
    @Binding var order: Order
    
    init(dish: Dish, order: Binding<Order>) {
        self.dish = dish
        _order = order
        _selectedOptions = State(initialValue: dish.customizationOptions?.compactMap { option in
            option.options.first?.option // Default to the first option of each customization
        } ?? [])
    }

    private var totalPrice: Int {
        var total = dish.price
        if let customizationOptions = dish.customizationOptions {
            for (index, option) in customizationOptions.enumerated() {
                if let selectedOption = option.options.first(where: { $0.option == selectedOptions[index] }),
                   selectedOption.price > 0 {
                    total += selectedOption.price
                }
            }
        }

        // Update the order state
        order.totalPrice = total
        order.selectedOptions = selectedOptions
        order.itemName = dish.name
        
        // Save to UserDefaults each time the order is updated
        order.saveToUserDefaults()
        
        return total
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(dish.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    Text(dish.name)
                        .font(.largeTitle.bold())

                    Text(dish.longDescription)
                        .padding(.vertical)

                    if let customizationOptions = dish.customizationOptions {
                        ForEach(Array(customizationOptions.enumerated()), id: \.element.name) { index, option in
                            VStack(alignment: .leading) {
                                Text(option.name)
                                    .font(.subheadline.bold())

                                Picker("Select an option", selection: $selectedOptions[index]) {
                                    ForEach(option.options, id: \.option) { item in
                                        Text("\(item.option) \(formatSizePrice(item.price))")
                                            .tag(item.option)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .padding(.top)
                        }
                    }

                    Text("Total Price: \(formatTotalPrice(totalPrice))")
                        .font(.title.bold())
                        .foregroundColor(.red)
                        .padding(.top, 30)

                    Text("Base Price: \(dish.price)₸")
                        .fontWeight(.bold)

                    NavigationLink {
                        AddressView(order: $order)
                    } label: {
                        Text("Check out")
                            .font(.title3)
                            .padding(.horizontal, 70)
                            .padding(.vertical, 10)
                            .background(Color.brown)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                }
                .padding()
            }
            .navigationTitle(dish.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let sampleCustomizationOptions = [
        CustomizationOption(
            name: "Choose your topping",
            options: [
                Option(option: "Honey", price: 50),
                Option(option: "Jam", price: 30),
                Option(option: "Sugar", price: 20)
            ]
        ),
        CustomizationOption(
            name: "Choose your serving",
            options: [
                Option(option: "Single", price: 0),
                Option(option: "Double", price: 100),
                Option(option: "Family size", price: 200)
            ]
        )
    ]
    
    let sampleDish = Dish(
        name: "Baursak",
        summary: "A popular fried bread",
        longDescription: "Baursak is a traditional fried dough that is soft, fluffy, and slightly sweet...",
        imageName: "baursak",
        price: 200,
        customizationOptions: sampleCustomizationOptions
    )
    
    // Safe default Order (not using the decoder approach)
    let order = Order() // Safe initialization for preview

    return MenuView(dish: sampleDish, order: .constant(order)) // Pass the order as Binding
}
