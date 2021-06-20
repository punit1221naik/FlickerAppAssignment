//
//  Protocols.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik on 18/06/21.
//

import Foundation
import UIKit

protocol FlickerScreenViewModelDelegate: AnyObject {
  func didLoadSectionImage(images: [UIImage])
}

protocol ImageCacheManagerProtocol {
  func saveImage(image: UIImage, for key: NSURL)
  func getImage(for key: NSURL) -> UIImage?
}

protocol FlickerScreenViewModelProtocol {
  
  var sections: [Section] { get }
  
  func loadData(successCompletion: @escaping () -> Void,
                failureCompletion: @escaping (_ error: String?) -> Void)
  func downloadImageTask(imageUrl: URL,
                         downloadCompletion: @escaping (UIImage) -> Void)
  
}
