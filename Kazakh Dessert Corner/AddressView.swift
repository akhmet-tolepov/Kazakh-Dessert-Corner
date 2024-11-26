import SwiftUI

struct AddressView: View {
    @Binding var order: Order
    @State private var isProcessingOrder = false
    @State private var successMessage: String?
    @State private var errorMessage: String?

    // Custom initializer
    init(order: Binding<Order>) {
        self._order = order // Initialize the @Binding property
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $order.name)
                    TextField("Street Address", text: $order.streetAddress)
                    TextField("City", text: $order.city)
                    TextField("Zip", text: $order.zip)
                }

                Section {
                    Button("Check Out") {
                        Task {
                            await placeOrder()
                        }
                    }
                    .disabled(order.check || isProcessingOrder) // Disabled if check is true
                    .padding()
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(order.check || isProcessingOrder) // Same as above
                
                NavigationLink("View Order Summary") {
                    OrderSummaryView()
                }
            }
            .navigationTitle("Delivery details")
            .navigationBarTitleDisplayMode(.inline)
            
            // Display messages below the form
            if let successMessage = successMessage {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }

    func placeOrder() async {
        order.saveToUserDefaults()
        isProcessingOrder = true
        errorMessage = nil

        do {
            // Simulating async operation (e.g., API call or processing)
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            
            // Save order details to UserDefaults after successful placement
            order.saveToUserDefaults()
            
            // Show success message or navigate to OrderSummaryView if desired
            successMessage = "Order placed successfully!"
            print("Order placed successfully and saved!")
            
        } catch {
            errorMessage = "An error occurred while placing your order. Please try again."
            print("Error placing order: \(error.localizedDescription)")
        }
        
        isProcessingOrder = false
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
    
    // Create a sample order or load it from UserDefaults
    let order = Order() // Default order or load from UserDefaults as needed

    // Pass the order to AddressView with .constant
    return AddressView(order: .constant(order))
}
