//
//  OrderSummaryView.swift
//  Kazakh Dessert Corner
//
//  Created by Akhmet Tolepov on 13.11.2024.
//

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
                        Text("Item: \(order.itemName)") // Replace with your order item data
                        Text("Quantity: \(order.quantity)")
                        Text("Total Price: \(order.totalPrice)₸") // Assuming `totalPrice` is a computed property
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
            // Refresh order data whenever the view appears
            self.order = Order.loadFromUserDefaults()
        }
    }
}

#Preview {
    OrderSummaryView()
}
