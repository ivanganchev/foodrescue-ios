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
    private let userSessionService = UserSessionService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapView.gestures.singleTapGestureRecognizer.addTarget(self, action: #selector(handleMapTap(_:)))
        
        mapView.pointAnnotationManager.delegate = self
        
        restaurantViewModel.getAllRestaurants { [weak self] restaurants in
            for restaurant in restaurants {
                self?.createRestaurantAnnotation(from: restaurant)
            }
        }
        
        restaurantViewModel.onRestaurantAdded = { [weak self] restaurant in
            self?.createRestaurantAnnotation(from: restaurant)
        }
    }
    
    override func loadView() {
        self.view = mapView
    }
    
    private func createRestaurantAnnotation(from restaurant: Restaurant) {
        var mutableRestaurant = restaurant
        self.mapView.createRestaurantAnnotation(at: CLLocationCoordinate2D(latitude: mutableRestaurant.latitude,
                                                                            longitude: mutableRestaurant.longitude),
                                                 name: mutableRestaurant.name,
                                                 imageUrl: mutableRestaurant.images.first ?? "") { annotationId in
            mutableRestaurant.annotationId = annotationId
            self.restaurantViewModel.restaurants.append(mutableRestaurant)
        }
    }
    
    @objc func handleMapTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if mapView.canAddRestaurant {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.mapView.mapboxMap.coordinate(for: location)
            
            let createRestaurantVC = CreateRestaurantViewController(userSessionService: userSessionService,
                                                                    latitude: coordinate.latitude,
                                                                    longitude: coordinate.longitude,
                                                                    restaurantViewModel: restaurantViewModel)
            createRestaurantVC.modalPresentationStyle = .fullScreen
            
            createRestaurantVC.onFinishAddingRestaurant = { [weak self] restaurant in
                self?.createRestaurantAnnotation(from: restaurant)
            }
            
            self.present(createRestaurantVC, animated: true) { [weak self] in
                self?.mapView.resetAddRestaurantState()
            }
        }
    }
}

extension MapViewController: AnnotationInteractionDelegate {
    public func annotationManager(_ manager: AnnotationManager, didDetectTappedAnnotations annotations: [Annotation]) {
        guard let tappedAnnotationRestaurant = self.restaurantViewModel.restaurants.filter({ $0.annotationId == annotations.first?.id }).first else { return }
        
        let restaurantDashboard = RestaurantDashboardController(mealsViewModel: MealsViewModel(userSessionService: userSessionService, restaurant: tappedAnnotationRestaurant))
        restaurantDashboard.modalPresentationStyle = .pageSheet
        
        self.present(restaurantDashboard, animated: true, completion: nil)
    }
}
