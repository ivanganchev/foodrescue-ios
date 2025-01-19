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
    let reserveMealAction: (IndexSet) -> Void
    
    var body: some View {
        VStack {
            Text(viewModel.restaurant?.name ?? "")
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
                    ForEach(viewModel.meals.indices, id: \.self) { index in
                        MealCell(
                            meal: viewModel.meals[index],
                            isSelected: viewModel.selectedMealIndex == index,
                            isDisabled: viewModel.reservedMeals.keys.contains(index),
                            timeRemaining: viewModel.reservedMeals[index],
                            selectAction: {
                                viewModel.selectedMealIndex = viewModel.selectedMealIndex == index ? nil : index
                            },
                            viewModel: viewModel,
                            reservedBy: nil
                        )
                    }
                    .onDelete(perform: deleteMealAction)
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
            
            HStack(spacing: 10) {
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
                } else {
                    Button(action: {
                        if let selectedIndex = viewModel.selectedMealIndex {
                            reserveMeal(index: selectedIndex)
                        }
                    }) {
                        Text("Reserve Meal")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.selectedMealIndex != nil ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .disabled(viewModel.selectedMealIndex == nil || viewModel.reservedMeals.keys.contains(viewModel.selectedMealIndex!))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateTimers()
        }
    }
    
    func reserveMeal(index: Int) {
        reserveMealAction(IndexSet(integer: index))
    }
    
    private func updateTimers() {
        for (index, timeRemaining) in viewModel.reservedMeals {
            if timeRemaining.minutes > 0 || timeRemaining.seconds > 0 {
                let newSeconds = timeRemaining.seconds - 1
                let updatedTime = TimeComponents(
                    minutes: newSeconds < 0 ? timeRemaining.minutes - 1 : timeRemaining.minutes,
                    seconds: newSeconds < 0 ? 59 : newSeconds
                )
                viewModel.reservedMeals[index] = updatedTime
            } else {
                viewModel.reservedMeals.removeValue(forKey: index)
            }
        }
    }
}


struct MealCell: View {
    let meal: Meal
    let isSelected: Bool
    let isDisabled: Bool
    let timeRemaining: TimeComponents?
    let selectAction: () -> Void
    let viewModel: MealsViewModel
    let reservedBy: String?

    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            AsyncImage(url: URL(string: meal.image)) { result in
                result.image?.resizable()
            }
            .scaledToFill()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .overlay(Circle().stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(meal.name)
                    .font(.headline)
                Text(meal.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(meal.price)
                    .font(.subheadline)
                    .foregroundColor(.green)
                
                if let reservedBy = reservedBy {
                    Text("Reserved by: \(reservedBy)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                if let time = timeRemaining {
                    Text("Reserved for \(time.minutes) min \(time.seconds) sec")
                        .font(.subheadline)
                        .foregroundColor(.red)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
        .cornerRadius(8)
        .onTapGesture {
            if !isDisabled && !viewModel.isUserOwner() {
                selectAction()
            }
        }
    }
}
