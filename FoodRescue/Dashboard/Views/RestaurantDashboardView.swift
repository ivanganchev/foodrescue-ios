//
//  RestaurantDashboardView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-24.
//

import Foundation
import SwiftUI

struct RestaurantDashboardView: View {
    @ObservedObject var viewModel: MealsViewModel
    
    var createMealAction: () -> Void
    let deleteMealAction: (IndexSet) -> Void
    
    var body: some View {
        VStack {
            Text(viewModel.restaurant.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            if viewModel.meals.isEmpty {
                Text("No meals available")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(viewModel.meals) { meal in
                        MealCell(meal: meal)
                    }
                    .onDelete(perform: deleteMealAction)
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
            
            if viewModel.isUserOwner() {
                Button(action: {
                    createMealAction()
                }) {
                    Text("Add Meal")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(UIColor.mainGreen))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
        }
    }
}

struct MealCell: View {
    let meal: Meal
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            AsyncImage(url: URL(string: meal.image)) { result in
                result.image?.resizable()
            }
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(meal.name)
                    .font(.headline)
                Text(meal.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(meal.price)
                    .font(.subheadline)
                    .foregroundColor(.green)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
