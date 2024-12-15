//
//  UIImageExtension.swift
//  FoodRescue
//
//  Created by Ivan Ganchev on 2024-08-04.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledImageSize))
        }

        return scaledImage
    }
    
    static func from(urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL string")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Unable to convert data to UIImage")
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    func circularImage(withBorderWidth borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
        let minEdge = min(size.width, size.height)
        let imageSize = CGSize(width: minEdge, height: minEdge)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        let context = UIGraphicsGetCurrentContext()
        
        let circleRect = CGRect(origin: .zero, size: imageSize)
        
        let borderInset = borderWidth / 2.0
        let borderRect = circleRect.insetBy(dx: borderInset, dy: borderInset)
        context?.setLineWidth(borderWidth)
        context?.setStrokeColor(borderColor.cgColor)
        context?.strokeEllipse(in: borderRect)
        
        let innerCircleRect = circleRect.insetBy(dx: borderWidth, dy: borderWidth)
        let path = UIBezierPath(ovalIn: innerCircleRect)
        path.addClip()
        
        draw(in: circleRect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
