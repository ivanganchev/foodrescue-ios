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

    var body: some View {
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
