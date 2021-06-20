//
//  FlickerScreenViewModel.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik on 18/06/21.
//

import Foundation
import UIKit

class FlickerScreenViewModel: FlickerScreenViewModelProtocol {
  
  var sections: [Section] = []
  weak var delegate: FlickerScreenViewModelDelegate?
  private let imageProvider = ImageProvider()
  
  // MARK: - FlickerScreenViewModel implementation methods
  /**
   This is the Viewmodel which will iteract with the controller and provide the required data to the controller for displaying the images on the slider menu.
   
   - Callbacks :
   - successCompletion: Inform the controller to load the stackview as the viewmodel recieved the data
   - failureCompletion:  Inform the controller that the load method has failed and show the required output.
   
   */
  func loadData(successCompletion: @escaping () -> Void, failureCompletion: @escaping (_ error: String?) -> Void) {
    
    FlickerApiManager.getImageList { [weak self] response in
      
      guard let safeSelf = self else {
        failureCompletion("Something went wrong")
        return
      }
      
      guard let photosList = response?.photos.photo else {
        failureCompletion("Something went wrong")
        return
      }
      successCompletion()       // so that the stack view is loaded
      safeSelf.loadImagesAndUpdateUI(listOfPhotos: photosList)
    }
    // Failure Completion
    failureCompletion: { error in
      failureCompletion(error)
    }
  }
  
  /**
   This functions downloads the image from the given Url and return the image in the callBack.
   
   - Parameters:
   - imageUrl: Image Url from where the imahe has to be loaded 
    
   - Callback: load Image and returns  the image as the completeion handler.
   */
  func downloadImageTask(imageUrl: URL,
                         downloadCompletion: @escaping (UIImage) -> Void) {
    imageProvider.requestImage(from: imageUrl) { image in
      downloadCompletion(image)
    }
  }
  
  // MARK: - FlickerScreenViewModelProtocol  methods
  /**
   This functions takes a list of photos converts it to section and send delegate to show the images.
   
   - Parameters:
   - listOfPhotos: List of photoModel
   
   - logic takes a list of photo models and converts them into sections.
   - each section contains list of photos thats fits the given height.
   - after conversion is complete each section data is loaded and a delegate is call to the controller.
   */
  private func loadImagesAndUpdateUI(listOfPhotos: PhotosList) {
    sections = PhotoHelperUtilities.convertToSections(listOfPhotos: listOfPhotos)
    for section in sections {
      self.loadImagesForSection(section: section) { [weak self] images in
        self?.didLoadSectionImage(images: images)
      }
      sleep(UInt32(Constants.ScrollConstants.scrollTime))
    }
  }
  
  /**
   This functions downloads the image from the given Url and return the image in the callBack.
   
   - Parameters:
   - section: its a struct which contains a list lf photos
   - callback is sent back to the calling function along with the set of images
   */
  private func loadImagesForSection(section: Section,
                                    completionHandler: @escaping ([UIImage]) -> Void) {
    
    let concurrentQueue = DispatchQueue(label: "downloadBatchOfImages", attributes: .concurrent)
    let group = DispatchGroup()
    var imageList: [UIImage] = []
    
    for photo in section.blockOfPhotos {
      group.enter()

      concurrentQueue.async {
        guard let imageURL = photo.getImageUrl() else {
          return
        }
        self.downloadImageTask(imageUrl: imageURL) { image in
          imageList.append(image)
          group.leave()
        }
      }
    }
    
    group.notify(queue: DispatchQueue.main) {
        return completionHandler(imageList)
    }
  }
}

extension FlickerScreenViewModel: FlickerScreenViewModelDelegate {
  /**
   This functions downloads the image from the given Url and return the image in the callBack.
   
   - Parameters:
   - listOfPhotos: List of images
   
   - logic the list of images are delegated back to the controller.
   */
  func didLoadSectionImage(images: [UIImage]) {
    delegate?.didLoadSectionImage(images: images)
  }
}
