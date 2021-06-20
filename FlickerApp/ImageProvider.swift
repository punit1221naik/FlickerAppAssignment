//
//  ImageProvider.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik on 18/06/21.
//
import Foundation
import UIKit

struct ImageProvider: RequestImages {
  
  private let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)
  private let imageCacheManager: ImageCacheManagerProtocol = ImageCacheManager.shared
  
  // MARK: - Fetch image from URL and Images cache
  fileprivate func loadImages(from url: URL, completion: @escaping (_ image: UIImage) -> Void) {
    downloadQueue.async(execute: { () -> Void in
      if let image = imageCacheManager.getImage(for: url as NSURL) {
        DispatchQueue.main.async {
          completion(image)
        }
        return
      }
      
      do {
        let data = try Data(contentsOf: url)
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            imageCacheManager.saveImage(image: image, for: url as NSURL)
            completion(image)
          }
        } else {
          print("Could not decode image")
        }
      } catch {
        print("Could not load URL: \(url): \(error)")
      }
    })
  }
  
}

protocol RequestImages {}

extension RequestImages where Self == ImageProvider {
  func requestImage(from url: URL,
                    completion: @escaping (_ image: UIImage) -> Void) {
    self.loadImages(from: url, completion: completion)
  }
}
