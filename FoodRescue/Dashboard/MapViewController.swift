//
//  MapViewController.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-07-28.
//

import UIKit
import MapboxMaps

class MapViewController: UIViewController {
    private var mapView = CustomMapView(frame: .zero)
    private let restaurantViewModel = RestaurantViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapView.gestures.singleTapGestureRecognizer.addTarget(self, action: #selector(handleMapTap(_:)))
        
        mapView.pointAnnotationManager.delegate = self
        
        restaurantViewModel.getAllRestaurants { [weak self] restaurants in
            for restaurant in restaurants {
                self?.mapView.createRestaurantAnnotation(at: CLLocationCoordinate2D(latitude: restaurant.latitude,
                                                                                    longitude: restaurant.longitude),
                                                         name: restaurant.name,
                                                         imageUrl: restaurant.images.first ?? "")
            }
        }
    }
    
    override func loadView() {
        self.view = mapView
    }
    
    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if mapView.canAddRestaurant {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.mapView.mapboxMap.coordinate(for: location)
            
            let createRestaurantVC = CreateRestaurantViewController(latitude: coordinate.latitude, longitude: coordinate.longitude, restaurantViewModel: restaurantViewModel)
            createRestaurantVC.modalPresentationStyle = .fullScreen
            
            createRestaurantVC.onFinishAddingRestaurant = { [weak self] restaurant in
                self?.mapView.createRestaurantAnnotation(at: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                                    longitude: coordinate.longitude), name: restaurant.name, imageUrl: restaurant.images.first ?? "")
            }
            
            self.present(createRestaurantVC, animated: true) { [weak self] in
                self?.mapView.resetAddRestaurantState()
            }
        }
    }
}

extension MapViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        
        
//        let createMealController = CreateMealsViewController(restaurantViewModel: restaurantViewModel)
//        createMealController.modalPresentationStyle = .fullScreen
//        
//        createMealController.onFinishAddingMeal = { [weak self] meal in
//        }
    }
}
