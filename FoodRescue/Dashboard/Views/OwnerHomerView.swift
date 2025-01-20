//
//  OwnerHomerView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-19.
//

import SwiftUI

struct OwnerHomeView: View {
    @ObservedObject var viewModel: MealsViewModel

    var body: some View {
        List {
            ForEach(viewModel.mealsByRestaurant, id: \.restaurant) { group in
                RestaurantSectionView(
                    restaurant: group.restaurant,
                    meals: group.meals,
                    viewModel: viewModel
                )
            }
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            viewModel.updateTimers()
        }
    }
}



struct RestaurantSectionView: View {
    let restaurant: String
    let meals: [Meal]
    let viewModel: MealsViewModel

    var body: some View {
        Section(header: Text(restaurant).font(.title3)) {
            ForEach(meals) { meal in
                MealCell(
                    meal: meal,
                    isSelected: false,
                    isDisabled: false,
                    timeRemaining: viewModel.reservedMeals[meal.id],
                    selectAction: {
                        
                    },
                    viewModel: viewModel,
                    reservedBy: nil
                )
            }
        }
    }
}
