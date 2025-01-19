//
//  HomeView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-18.
//

import SwiftUI

struct HomeView: View {
    let restaurantViewModel: RestaurantViewModel
    let mealsViewModel: MealsViewModel
    
    var body: some View {
        if mealsViewModel.userSessionService.getUserRole() == .customer {
            CustomerHomeView()
        } else {
            OwnerHomeView(viewModel: mealsViewModel)
        }
    }
}


struct CustomerHomeView: View {
    var body: some View {
        Text("Customer Home View")
    }
}

struct OwnerHomeView: View {
    let viewModel: MealsViewModel
    
    var body: some View {
        Text("Owner Home View")
//        List {
//            ForEach(mealsByRestaurant.keys.sorted(), id: \.self) { restaurant in
//                Section(header: Text(restaurant).font(.title2)) {
//                    if let meals = mealsByRestaurant[restaurant] {
//                        ForEach(meals) { meal in
//                            MealCell(
//                                meal: meal,
//                                isDisabled: false,
//                                timeRemaining: meal.timeRemaining,
//                                reservedBy: meal.reservedBy,
//                                selectAction: {
//                                },
//                                viewModel: viewModel
//                            )
//                        }
//                    }
//                }
//            }
//        }
    }
}

