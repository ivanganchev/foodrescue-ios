//
//  CreateContentView.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-12-15.
//

import SwiftUI
import PhotosUI

struct CreateContentView: View {
    @Binding var name: String
    @Binding var description: String
    @Binding var price: String?
    @Binding var selectedImageData: Data?
    @State private var isPhotoPickerPresented = false
    @State private var selectedImage: PhotosPickerItem? = nil

    var title: String
    var descriptionLabel: String
    var priceLabel: String?
    var cancelAction: () -> Void
    var finishAction: (_ name: String, _ description: String, _ price: String, _ image: UIImage) -> Void

    private var priceBinding: Binding<String> {
        Binding(
            get: { price ?? "" },
            set: { price = $0.isEmpty ? nil : $0 }
        )
    }

    var isFormComplete: Bool {
        !name.isEmpty && !description.isEmpty && selectedImageData != nil && (price != nil || priceLabel == nil)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            Text(descriptionLabel)
                .font(.headline)

            TextField("Enter \(descriptionLabel.lowercased())", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            Text("Description")
                .font(.headline)

            TextField("Enter description", text: $description)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

            if let priceLabel = priceLabel {
                Text(priceLabel)
                    .font(.headline)

                TextField("Enter price", text: priceBinding)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }

            HStack {
                Button(action: {
                    isPhotoPickerPresented = true
                }) {
                    HStack {
                        Image(systemName: "photo.on.rectangle")
                        Text("Attach photo")
                    }
                    .padding()
                    .background(Color(UIColor.mainGreen))
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
                    // Trigger camera picker here if needed
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Take Photo")
                    }
                    .padding()
                    .background(Color(UIColor.mainGreen))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }

            if let selectedImageData, let image = UIImage(data: selectedImageData) {
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
                    guard let selectedImageData = selectedImageData,
                          let image = UIImage(data: selectedImageData)
                    else { return }
                    finishAction(name, description, price, image)
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

