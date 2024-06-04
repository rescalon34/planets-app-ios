//
//  DownloadFileManager.swift
//  PlanetsApp
//
//  Created by rescalon on 25/5/24.
//

import Foundation
import SwiftUI
import Combine

/**
 Helper clas to save and retrive images from FileManager using combine to handle asynchronous
 operations.
 */
class DownloadFileManager {
    
    static let instance = DownloadFileManager()
    let folderName = "PlanetsApp_Images"
    let imageFileExtensions = ["jpg", "jpeg", "png", "gif", "bmp", "tiff"]
    
    private init() {
        createImageFolder()
    }
        
    // MARK: - Image storage management (create folder, get image path).
    func createImageFolder() {
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent(folderName, conformingTo: .archive)
                .path else { return }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(
                    atPath: path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                print("DownloadFileManager - Folder created successfuly!")
            } catch let error {
                print("DownloadFileManager - Error while creating directory. \(error)")
            }
        }
    }
    
    /**
     Get the image's path by its name.
     */
    func getImagePath(imageName: String) -> URL? {
        guard let path = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .appendingPathComponent("\(imageName).jpg") else {
            print("DownloadFileManager - Error getting image path.")
            return nil
        }
        
        return path
    }
    
    /**
     Save the given image to the specific directory.
     */
    func saveImageToFileManager(image: UIImage, imageName: String) -> Future<Bool, Never> {
        return Future { promise in
            guard
                let data = image.jpegData(compressionQuality: 1.0),
                let path = self.getImagePath(imageName: imageName) else {
                print("DownloadFileManager - Error getting image data!")
                promise(.success(false))
                return
            }
            do {
                try data.write(to: path)
                print("DownloadFileManager - Success Saving Image!")
                promise(.success(true))
            } catch let error {
                print("DownloadFileManager - Error Saving Image: \(error)")
                promise(.success(false))
            }
        }
    }
    
    /**
     Get a single saved image by name.
     */
    func getSavedImage(imageName: String) -> UIImage? {
        guard
            let path = getImagePath(imageName: imageName)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("DownloadFileManager - Error getting saved image!")
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    /**
     Get all the saved images within the given directory from the "FileManager".
     This function retrives all images using combine.
     */
    func getAllSavedImagesFromFileManager() -> Future<[URL], Never> {
            return Future { promise in
                let folderName = "PlanetsApp_Images"
                
                guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                    print("DownloadFileManager - Unable to find caches directory")
                    promise(.success([]))
                    return
                }
                
                let folderURL = cachesDirectory.appendingPathComponent(folderName, isDirectory: true)
                
                if !FileManager.default.fileExists(atPath: folderURL.path) {
                    do {
                        try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                        print("DownloadFileManager - Created directory at: \(folderURL.path)")
                    } catch {
                        print("DownloadFileManager - Error creating directory \(folderURL.path): \(error.localizedDescription)")
                        promise(.success([]))
                        return
                    }
                }
                
                do {
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                    
                    let imagePaths = fileURLs.filter { url in
                        let isImageFile = self.imageFileExtensions.contains(url.pathExtension.lowercased())
                        if !isImageFile {
                            print("DownloadFileManager - Skipping non-image file: \(url)")
                        }
                        return isImageFile
                    }
                    
                    print("DownloadFileManager - Image paths: \(imagePaths)")
                    promise(.success(imagePaths))
                } catch {
                    print("DownloadFileManager - Error while enumerating files \(folderURL.path): \(error.localizedDescription)")
                    promise(.success([]))
                }
            }
        }
}
