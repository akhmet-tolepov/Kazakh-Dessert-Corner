import SwiftUI

struct OrderSummaryView: View {
    @State private var order: Order? = Order.loadFromUserDefaults()

    var body: some View {
        NavigationStack {
            if let order = order {
                Form {
                    Section(header: Text("Order Details")) {
                        Text("Name: \(order.name)")
                        Text("Street Address: \(order.streetAddress)")
                        Text("City: \(order.city)")
                        Text("Zip: \(order.zip)")
                    }

                    Section(header: Text("Order Summary")) {
                        Text("Item: \(order.itemName)")
                        
                        if !order.selectedOptions.isEmpty {
                            ForEach(order.selectedOptions, id: \.self) { option in
                                Text("Selected option: \(option)")
                            }
                        }

                        Text("Total Price: \(order.totalPrice)₸")
                    }
                }
                .navigationTitle("Order Summary")
            } else {
                Text("No order found.")
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .onAppear {
            // Reload the order each time this view appears
            self.order = Order.loadFromUserDefaults()
        }
    }
}


#Preview {
    OrderSummaryView()
}
