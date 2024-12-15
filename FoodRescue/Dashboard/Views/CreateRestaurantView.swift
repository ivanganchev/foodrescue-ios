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
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isPhotoPickerPresented = false
    
    var isFormComplete: Bool {
        !restaurantName.isEmpty && !description.isEmpty && selectedImageData != nil
    }
    
    var cancelAction: () -> Void
    var finishAction: (_ name: String, _ description: String, _ image: UIImage) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Restaurant")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Text("Restaurant Name")
                .font(.headline)
            
            TextField("Enter restaurant name", text: $restaurantName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            Text("Description")
                .font(.headline)
            
            TextField("Enter description", text: $description)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            
            HStack {
                Button(action: {
                    sourceType = .photoLibrary
                    isPhotoPickerPresented = true
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Attach photo")
                    }
                    .padding()
                    .background(Color(UIColor.mainGreen) )
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .photosPicker(
                    isPresented: $isPhotoPickerPresented,
                    selection: $selectedImage,
                    matching: .images,
                    photoLibrary: .shared()
                )
                .onChange(of: selectedImage) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    sourceType = .camera
                    showImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Take Photo")
                    }
                    .padding()
                    .background(Color(UIColor.mainGreen) )
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            
            if let selectedImageData,
               let image = UIImage(data: selectedImageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            
            Spacer()
            
            HStack {
                Button("Cancel") {
                    cancelAction()
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
                
                Button("Finish") {
                    finishAction(restaurantName, description, UIImage(data: selectedImageData!)!)
                }
                .padding()
                .background(isFormComplete ? Color(UIColor.mainGreen) : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
                .disabled(!isFormComplete)
            }
        }
        .padding()
    }
}
