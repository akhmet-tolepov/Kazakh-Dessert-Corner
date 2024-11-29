import SwiftUI

struct ContentView: View {
    // Load the restaurant data from the bundle using the decode method
    let foods: Restaurant? = Bundle.main.decode("restaurant.json", to: Restaurant.self)
    
    // Initialize the order with a default value, or load it from UserDefaults
    @State private var order = Order.loadFromUserDefaults() ?? Order()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    if let foods = self.foods {
                        Image(foods.imageName)
                            .resizable()
                            .scaledToFit()
                        
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
                        
                        // Loop through the dishes and create a navigation link for each
                        ForEach(foods.dishes) { dish in
                            NavigationLink {
                                // Passing the `order` binding to MenuView
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: OrderView(order: $order)) {
                        HStack {
                            Text("My orders")
                                .foregroundColor(.black)
                                .bold()

                            Image(systemName: "cart.fill")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
