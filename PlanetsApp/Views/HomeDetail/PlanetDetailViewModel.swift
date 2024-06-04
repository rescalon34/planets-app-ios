//
//  PlanetDetailViewModel.swift
//  PlanetsApp
//
//  Created by rescalon on 27/5/24.
//

import Foundation
import SwiftUI
import Combine

class PlanetDetailViewModel : ObservableObject {
    
    private var uiImage: UIImage? = nil
    private var imageName: String = ""
    
    // MARK: Combine variables
    let onImageSaved = PassthroughSubject<Bool, Never>()
    @Published var isImageSaved : Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    func setSaveImageData(image: Image, imageName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.uiImage = image.toUIImage()
            self?.imageName = imageName
            print("UIImage: \(self?.uiImage.debugDescription ?? "")")
            print("ImageName: \(imageName)")
        }
    }
    
    func savePlanetImage() {
        guard let uiImage = uiImage else { return }
        DownloadFileManager.instance.saveImageToFileManager(image: uiImage, imageName: imageName)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isImageSaved in
//                self?.onImageSaved.send(true)
                self?.isImageSaved = true
                print("DetailViewModel Image Saved!")
            }
            .store(in: &cancellables)
    }
}
