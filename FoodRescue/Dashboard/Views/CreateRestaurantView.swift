//
//  CreateRestaurantView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-08-10.
//

import SwiftUI
import PhotosUI

struct CreateRestaurantView: View {
    @State private var restaurantName: String = ""
    @State private var description: String = ""
    @State private var selectedImageData: Data? = nil
    
    var cancelAction: () -> Void
    var finishAction: (_ name: String, _ description: String, _ image: UIImage) -> Void
    
    var body: some View {
        CreateContentView(
            name: $restaurantName,
            description: $description,
            price: .constant(""),
            selectedImageData: $selectedImageData,
            title: "Your Restaurant",
            descriptionLabel: "Restaurant Name",
            priceLabel: nil,
            cancelAction: cancelAction,
            finishAction: { name, description, _, image in
                finishAction(name, description, image)
            }
        )
    }
}
