//
//  OwnerHomerView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-19.
//

import SwiftUI

struct OwnerHomeView: View {
    @ObservedObject var restaurantViewModel: RestaurantViewModel
    @ObservedObject var mealsViewModel: MealsViewModel
    let userSession: UserSessionService

    var body: some View {
        Text("My restaurants")
            .multilineTextAlignment(.center)
            .font(.title)
            .fontWeight(.bold)
            .offset(y: -20)
        
        Spacer()
        
        List {
            ForEach(mealsViewModel.mealsByRestaurant, id: \.restaurant) { group in
                RestaurantSectionView(
                    restaurantId: group.restaurant,
                    meals: group.meals,
                    restaurantViewModel: restaurantViewModel,
                    mealsViewModel: mealsViewModel
                )
            }
        }
        .onAppear() {
            restaurantViewModel.getAllRestaurants(for: userSession.getUserId())
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            mealsViewModel.updateTimers()
        }
    }
}



struct RestaurantSectionView: View {
    let restaurantId: String
    let meals: [Meal]
    let restaurantViewModel: RestaurantViewModel
    let mealsViewModel: MealsViewModel

    var body: some View {
        Section(header: Text("🍕 \(restaurantViewModel.getRestaurantById(restaurantId)?.name ?? "")")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)) {
            ForEach(meals) { meal in
                MealCell(
                    meal: meal,
                    isSelected: false,
                    isDisabled: false,
                    timeRemaining: mealsViewModel.reservedMeals[meal.id],
                    selectAction: {},
                    viewModel: mealsViewModel,
                    reservedBy: nil
                )
            }
        }
    }
}
