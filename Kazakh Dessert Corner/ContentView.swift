//
//  ContentView.swift
//  Kazakh Dessert Corner
//
//  Created by Akhmet Tolepov on 07.11.2024.
//

import SwiftUI

struct ContentView: View {
    // Load the restaurant data from the bundle using the decode method
    let foods: Restaurant? = Bundle.main.decode("restaurant.json", to: Restaurant.self)
    @State private var order = Order()
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    if let foods = self.foods {
                        Image(foods.imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(.top, -59)
                        
                            Text(foods.name)
                                .font(.largeTitle).bold()
                            Text(foods.description)
                            .padding(30)
                                .fontWeight(.medium)
                            Rectangle()
                            .foregroundColor(.brown)
                                .frame(height: 5)
                                .padding(.top)
                                .padding(.bottom, 70)
                        Text("Menu:")
                            .font(.title.weight(.semibold))
                            .padding(.bottom, 30)
                        Rectangle()
                            .frame(height: 32)
                            .foregroundColor(.brown)
                            .padding(.bottom, -8)
                            ForEach(foods.dishes) { dish in
                                NavigationLink {
                                    MenuView(dish: dish, order: $order)
                                } label: {
                                    VStack {
                                        Image(dish.imageName)
                                            .resizable()
                                            .scaledToFit()
                                        Text(dish.id)
                                            .foregroundColor(.primary)
                                            .font(.title2.weight(.medium))
                                        Text(dish.longDescription)
                                            .foregroundColor(.primary)
                                            .padding()
                                        
                                    }
                                }
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .frame(height: 2)
                                    .padding(.bottom, 50)
                            }
                        Rectangle()
                            .frame(height: 30)
                            .foregroundColor(.brown)
                            .padding(.top, -60)

                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
