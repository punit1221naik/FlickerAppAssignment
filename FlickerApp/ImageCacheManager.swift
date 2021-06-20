//
//  ImageCacheManager.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik on 19/06/21.
//

import Foundation
import UIKit

class ImageCacheManager: ImageCacheManagerProtocol {
  
  internal var cache = NSCache<NSURL, UIImage>()
  
  static var shared = ImageCacheManager()
  
  private init() {}
  
  func saveImage(image: UIImage, for url: NSURL) {
    self.cache.setObject(image, forKey: url)
  }
  
  func getImage(for url: NSURL) -> UIImage? {
    if let image = self.cache.object(forKey: url) {
      return image
    }
    return nil
  }
}
