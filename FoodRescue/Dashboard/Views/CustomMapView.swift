//
//  CustomMapView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-07-28.
//

import UIKit
import MapboxMaps
import AVFoundation

class CustomMapView: UIView {
    var mapView: MapView!
    var cameraLocationConsumer: CameraPuckLocationConsumer!
    var pointAnnotationManager: PointAnnotationManager!
    
    private var cameraLocationState = CameraLocationState(rawValue: "none")
    
    var locateMeButton = MapInteractionButton(imageName: "location",
                                              backgroundColor: UIColor.mainGrey,
                                              tintColor: UIColor.mapButtonColor,
                                              cornerRadius: 8.0)
    
    var addRestaurantButton =  MapInteractionButton(imageName: "plus",
                                                    text: "Add your place",
                                                    fontSize: 14.0,
                                                    backgroundColor: UIColor.mainGreen,
                                                    tintColor: .white,
                                                    cornerRadius: 12.0)
    
    var cancelButton =  MapInteractionButton(imageName: "xmark",
                                                    text: "Cancel",
                                                    fontSize: 14.0,
                                                    backgroundColor: UIColor.mainGreen,
                                                    tintColor: .white,
                                                    cornerRadius: 12.0)
    
    var instructionText = UILabel(frame: .zero)
    
    private let followPuckOptions = FollowPuckViewportStateOptions(
        padding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100),
        zoom: 15.0,
        bearing: .constant(0)
    )
    private var followPuckViewportState: FollowPuckViewportState!
    
    var canAddRestaurant = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mapView = MapView(frame: self.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let cameraOptions = CameraOptions(center:
                                            CLLocationCoordinate2D(latitude: 39.5, longitude: -98.0),
                                          zoom: 15.0, bearing: 0, pitch: 0)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        mapView.ornaments.options.scaleBar.visibility = .visible
        
        cameraLocationConsumer = CameraPuckLocationConsumer(mapView: self.mapView)

        self.addSubview(mapView)
        
        setLocateMeButton()
        setAddRestaurantButton()
        setInstructionText()
        setCancelButton()
        setConstraints()
        
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLocateMeButton() {
        self.locateMeButton.translatesAutoresizingMaskIntoConstraints = false
        self.locateMeButton.addTarget(self, action: #selector(locateMeButtonTapped), for: .touchUpInside)
    }
    
    private func setAddRestaurantButton() {
        self.addRestaurantButton.translatesAutoresizingMaskIntoConstraints = false
        self.addRestaurantButton.addTarget(self, action: #selector(addRestaurantTapped), for: .touchUpInside)
        self.addRestaurantButton.isHidden = false
    }
    
    private func setCancelButton() {
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.addTarget(self, action: #selector(resetAddRestaurantState), for: .touchUpInside)
        self.cancelButton.isHidden = true
    }
    
    private func setInstructionText() {
        self.instructionText.translatesAutoresizingMaskIntoConstraints = false
        self.instructionText.backgroundColor = UIColor.mainGrey
        self.instructionText.font = UIFont.systemFont(ofSize: 14)
        self.instructionText.text = "Tap to finish placement"
        self.instructionText.layer.cornerRadius = 6
        self.instructionText.layer.masksToBounds = true
        self.instructionText.textColor = .white
        self.instructionText.textAlignment = .center
        self.instructionText.isHidden = true
    }
    
    private func setConstraints() {
        let guide = self.safeAreaLayoutGuide
        
        self.addSubview(self.locateMeButton)
        self.addSubview(self.addRestaurantButton)
        self.addSubview(self.cancelButton)
        self.addSubview(self.instructionText)
        
        NSLayoutConstraint.activate([
            self.locateMeButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: 60),
            self.locateMeButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -10),
            self.locateMeButton.heightAnchor.constraint(equalToConstant: 40),
            self.locateMeButton.widthAnchor.constraint(equalToConstant: 40),
            
            self.addRestaurantButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),
            self.addRestaurantButton.heightAnchor.constraint(equalToConstant: 44),
            self.addRestaurantButton.widthAnchor.constraint(equalToConstant: 130),
            self.addRestaurantButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            self.cancelButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -10),
            self.cancelButton.heightAnchor.constraint(equalToConstant: 44),
            self.cancelButton.widthAnchor.constraint(equalToConstant: 100),
            self.cancelButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            self.instructionText.topAnchor.constraint(equalTo: guide.topAnchor),
            self.instructionText.centerXAnchor.constraint(equalTo: centerXAnchor),
            self.instructionText.heightAnchor.constraint(equalToConstant: 44),
            self.instructionText.widthAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    @objc private func locateMeButtonTapped() {
        guard let cameraLocationState = self.cameraLocationState else { return }
        
        if self.cameraLocationState == .noState {
            self.changeLocateMeButton(state: cameraLocationState)
            self.cameraLocationState = .jumpLocation
        } else if self.cameraLocationState == .jumpLocation {
            self.changeLocateMeButton(state: cameraLocationState)
            self.cameraLocationState = .followLocation
        } else if self.cameraLocationState == .followLocation {
            self.changeLocateMeButton(state: cameraLocationState)
            self.cameraLocationState = .noState
        }
    }
    
    private func changeLocateMeButton(state: CameraLocationState) {
        switch state {
        case .noState:
            self.mapView.location.options.puckType = .puck2D()
            
            self.followPuckViewportState = self.mapView.viewport.makeFollowPuckViewportState(
                options: self.followPuckOptions)
            self.mapView.viewport.transition(to: followPuckViewportState)
            
            self.locateMeButton.setButtonImage(name: "location.fill")
        case .jumpLocation:
            self.mapView.location.addPuckLocationConsumer(self.cameraLocationConsumer)
            
            self.locateMeButton.setButtonImage(name: "location.north.fill")
        case .followLocation:
            self.mapView.location.options.puckType = .none
            
            self.locateMeButton.setButtonImage(name: "location")
            
            self.mapView.viewport.idle()
            self.mapView.location.removePuckLocationConsumer(self.cameraLocationConsumer)
        }
    }
    
    @objc func addRestaurantTapped() {
        self.instructionText.isHidden = false
        self.addRestaurantButton.isHidden = true
        self.cancelButton.isHidden = false
        self.canAddRestaurant = true
    }
    
    @objc func resetAddRestaurantState() {
        self.instructionText.isHidden = true
        self.addRestaurantButton.isHidden = false
        self.cancelButton.isHidden = true
        self.canAddRestaurant = false
    }
    
    func createRestaurantAnnotation(at location: CLLocationCoordinate2D, name: String, imageUrl: String, completion: @escaping (String?) -> Void) {
        UIImage.from(urlString: imageUrl) { [weak self] image in
            guard let image = image else {
                print("Failed to load image for annotation")
                return
            }
            
            let resizedImage = image.resize(targetSize: CGSize(width: 70, height: 70))
            let cirularImage = resizedImage.circularImage(withBorderWidth: 2, borderColor: .black)
            
            var restaurantPointAnnotation = PointAnnotation(coordinate: location)
            restaurantPointAnnotation.image = .init(image: cirularImage ?? resizedImage, name: "restaurant-\(UUID().uuidString)")
            restaurantPointAnnotation.textField = name
            restaurantPointAnnotation.iconAnchor = .bottom
            restaurantPointAnnotation.iconOffset = [0, -12]
            
            DispatchQueue.main.async {
                self?.pointAnnotationManager.annotations.append(restaurantPointAnnotation)
                completion(restaurantPointAnnotation.id)
            }
        }
    }
}
