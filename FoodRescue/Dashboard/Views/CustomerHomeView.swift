//
//  CustomerHomeView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2025-01-19.
//

import SwiftUI
import CoreLocation

struct CustomerHomeView: View {
    @StateObject var locationManager: LocationManager
    @ObservedObject var viewModel: RestaurantViewModel
    var restaurantTapAction: (Restaurant) -> Void
    
    var body: some View {
        Text("Restaurants nearby")
            .multilineTextAlignment(.center)
            .font(.title)
            .fontWeight(.bold)
            .offset(y: -20)
        Spacer()
        VStack {
            if locationManager.isLocationEnabled {
                if let location = locationManager.userLocation {
                    List(viewModel.restaurants, id: \.id) { restaurant in
                        CustomerRestaurantCell(restaurant: restaurant, tapAction: {
                            restaurantTapAction(restaurant)
                        })
                    }
                }
            } else {
                Text("Location is disabled. Please go to Map and enable it.")
            }
        }
        .onAppear {
            if locationManager.isLocationEnabled {
                if let location = locationManager.userLocation {
                    viewModel.getAllNearbyRestaurants(
                        userLatitude: location.coordinate.latitude,
                        userLongitude: location.coordinate.longitude,
                        maxDistance: 1000
                    )
                }
            }
        }
        Spacer()
    }
}

struct CustomerRestaurantCell: View {
    let restaurant: Restaurant
    let tapAction: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            AsyncImage(url: URL(string: restaurant.images.first ?? "")) { result in
                result.image?.resizable()
            }
            .scaledToFill()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(restaurant.name)
                    .font(.headline)
                Text(restaurant.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
        .background(Color.clear)
        .cornerRadius(8)
        .onTapGesture {
            tapAction()
        }
    }
}
