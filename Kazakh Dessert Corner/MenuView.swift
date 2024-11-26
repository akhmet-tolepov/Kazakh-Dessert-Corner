import SwiftUI

struct MenuView: View {
    let dish: Dish
    @State private var selectedOptions: [String]
    @Binding var order: Order // This is the binding to the Order
    
    // Custom initializer to handle initialization of all properties
    init(dish: Dish, order: Binding<Order>) {
        self.dish = dish
        _order = order // Binding the order
        
        // Initialize selectedOptions with the first option of each customization
        _selectedOptions = State(initialValue: dish.customizationOptions?.compactMap { option in
            option.options.first?.option // Default to the first option of each customization
        } ?? [])
    }

    // Computed property to calculate total price with customizations
    private var totalPrice: Int {
        var total = dish.price // Start with the base price of the dish
        if let customizationOptions = dish.customizationOptions {
            for (index, option) in customizationOptions.enumerated() {
                if let selectedOption = option.options.first(where: { $0.option == selectedOptions[index] }),
                   selectedOption.price > 0 {
                    total += selectedOption.price
                }
            }
        }
        return total
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Dish image
                    Image(dish.imageName)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 200)

                    // Dish details
                    Text(dish.name)
                        .font(.largeTitle.bold())

                    Text(dish.longDescription)
                        .padding(.vertical)

                    // Customization options
                    if let customizationOptions = dish.customizationOptions {
                        ForEach(Array(customizationOptions.enumerated()), id: \.element.name) { index, option in
                            VStack(alignment: .leading) {
                                Text(option.name)
                                    .font(.subheadline.bold())

                                Picker("Select an option", selection: $selectedOptions[index]) {
                                    // Add a "None" option for deselection
                                    ForEach(option.options, id: \.option) { item in
                                        Text("\(item.option) \(item.price == 0 ? "" : "\(item.price)₸")")
                                            .tag(item.option)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                            .padding(.top)
                        }
                    }

                    // Display total price
                    Text("Total Price: \(totalPrice)₸")
                        .font(.title.bold())
                        .foregroundColor(.red)
                        .padding(.top, 30)
                        .padding(.bottom, -20)
                    Text("Base Price: \(dish.price)₸")
                        .fontWeight(.bold)
                    
                    // Navigation link to AddressView
                    NavigationLink {
                        AddressView(order: $order) // Pass the Binding to AddressView
                    } label: {
                        Text("Check out")
                            .font(.title3)
                            .padding(.horizontal, 70)
                            .padding(.vertical, 10) // Adding vertical padding for better height
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

