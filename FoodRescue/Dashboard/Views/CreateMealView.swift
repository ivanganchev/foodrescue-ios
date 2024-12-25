//
//  CreateMealView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-15.
//

import Foundation
import SwiftUI

struct CreateMealView: View {
    @State private var mealName: String = ""
    @State private var description: String = ""
    @State private var price: String? = nil
    @State private var selectedImageData: Data? = nil
    
    var cancelAction: () -> Void
    var finishAction: (_ name: String, _ description: String, _ price: String, _ image: UIImage) -> Void
    
    var body: some View {
        CreateContentView(
            name: $mealName,
            description: $description,
            price: $price,
            selectedImageData: $selectedImageData,
            title: "Add a Meal",
            descriptionLabel: "Meal Name",
            priceLabel: "Price",
            cancelAction: cancelAction,
            finishAction: { name, description, price, image in
                finishAction(name, description, price!, image)
            }
        )
    }
}

