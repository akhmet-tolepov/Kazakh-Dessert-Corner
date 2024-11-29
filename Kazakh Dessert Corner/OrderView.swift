//
//  OrderView.swift
//  Kazakh Dessert Corner
//
//  Created by Akhmet Tolepov on 29.11.2024.
//

// OrderView.swift
import SwiftUI

struct OrderView: View {
    // Use @Binding to allow dynamic updates from the parent view
    @Binding var order: Order
    
    var body: some View {
        VStack {
            if order.items.isEmpty {
                Text("No items in your order.")
                    .font(.title)
                    .foregroundColor(.gray)
            } else {
                List(order.items, id: \.id) { dish in
                    HStack {
                        Image(dish.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text(dish.id)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text("$\(dish.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
            }
            
            Spacer()
            
            // Add a checkout button (optional)
            Button(action: {
                // Perform checkout or reset action
            }) {
                Text("Checkout")
                    .font(.title2)
                    .bold()
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 30)
        }
        .navigationTitle("Your Order")
        .padding()
    }
}

