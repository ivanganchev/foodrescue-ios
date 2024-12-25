//
//  RestaurantDashboardView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-24.
//

import Foundation
import SwiftUI

struct RestaurantDashboardView: View {
    var restaurantName: String
    @State var meals: [Meal]
        
    var body: some View {
        VStack {
            Text(restaurantName)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            if meals.isEmpty {
                Text("No meals available")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List {
                    ForEach(meals) { meal in
                        MealCell(meal: meal)
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
            
            Button(action: {
                addMeal()
            }) {
                Text("Add Meal")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
    }
        
        private func addMeal() {
    //        meals.append(newMeal)
        }
}

struct MealCell: View {
    let meal: Meal
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(meal.image)
                .resizable()
                .scaledToFit()
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
