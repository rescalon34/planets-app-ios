//
//  UiExtensions.swift
//  PlanetsApp
//
//  Created by rescalon on 28/3/24.
//

import SwiftUI

extension View {
    func planetImageItemModifier() -> some View {
        modifier(PlanetImageItemModifier())
    }
    
    func getMagnificationGestureValue(value: CGFloat) -> CGFloat {
        print("current value: \(value)")
        var gestureValue = 0.0
        if value > 1 {
            gestureValue = value - 1
        } else {
            print("MAX zoom limit: \(gestureValue)")
        }
        return gestureValue
    }
    
    /*
     Function to convert an image to UIImage.
     */
    func toUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        // Render the view into a UIImage
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// An Extension View to convert AnyView to a View.
extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
