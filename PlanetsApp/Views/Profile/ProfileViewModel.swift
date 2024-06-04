//
//  ProfileViewModel.swift
//  PlanetsApp
//
//  Created by rescalon on 26/5/24.
//

import Foundation
import SwiftUI
import Combine

class ProfileViewModel : ObservableObject {
    
    @Published var profileImages: [String] = []
    @Published private(set) var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    func getAllSavedImages() {
        DownloadFileManager.instance.getAllSavedImagesFromFileManager()
            .map { $0.map { $0.path } }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] images in
                self?.isLoading = false
                self?.profileImages = images
            }
            .store(in: &cancellables)
    }
}
