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
    private let realTimeUpdateManager = RealTimeUpdatesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.mapView.gestures.singleTapGestureRecognizer.addTarget(self, action: #selector(handleMapTap(_:)))
        
        mapView.pointAnnotationManager.delegate = self
        
        restaurantViewModel.getAllRestaurants { [weak self] restaurants in
            for var restaurant in restaurants {
                self?.mapView.createRestaurantAnnotation(at: CLLocationCoordinate2D(latitude: restaurant.latitude,
                                                                                    longitude: restaurant.longitude),
                                                         name: restaurant.name,
                                                         imageUrl: restaurant.images.first ?? "") { annotationId in
                    restaurant.annotationId = annotationId
                    self?.restaurantViewModel.restaurants.append(restaurant)
                }
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
            
            let createRestaurantVC = CreateRestaurantViewController(userSessionService: userSessionService,
                                                                    latitude: coordinate.latitude,
                                                                    longitude: coordinate.longitude,
                                                                    restaurantViewModel: restaurantViewModel)
            createRestaurantVC.modalPresentationStyle = .fullScreen
            
            createRestaurantVC.onFinishAddingRestaurant = { [weak self] restaurant in
                var mutableRestaurant = restaurant
                self?.mapView.createRestaurantAnnotation(at: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                                    longitude: coordinate.longitude),
                                                         name: restaurant.name,
                                                         imageUrl: restaurant.images.first ?? "") { annotationId in
                    mutableRestaurant.annotationId = annotationId
                    self?.restaurantViewModel.restaurants.append(mutableRestaurant)
                }
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
