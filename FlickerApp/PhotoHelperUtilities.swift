//
//  PhotoHelperUtilities.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik on 18/06/21.
//

import Foundation
import UIKit
typealias PhotosList = [PhotoModel]
typealias SectionList = [Section]

class PhotoHelperUtilities {
  
  /**
   This functions take a list of photoModel. Filters it based on the Screen hight which is the default you can also send your customised height.
   
   - Parameters:
   - listOfPhotos: List of photoModel
   - height:  For which it has to be broken down into
    
   - Returns: A List of Section that has list of photoModel which fits the given height .
   */
  static func convertToSections(listOfPhotos: PhotosList,
                                height: Int = Constants.SizeConstants.screenHeight) -> SectionList {
      
    var subsetArrayLst: SectionList = []
    var singleSection = Section(blockOfPhotos: [])
    var sumOfSection = 0
    
    for photo in listOfPhotos {
      if photo.height > height {
        continue
      }
      
      if photo.height == height {
        subsetArrayLst.append(Section(blockOfPhotos: [photo]))
        continue
      }
      if (photo.height + sumOfSection) <= height {
        singleSection.blockOfPhotos.append(photo)
        sumOfSection += photo.height
      } else {
        sumOfSection = 0
        subsetArrayLst.append(singleSection)
        singleSection.blockOfPhotos.removeAll()
        singleSection.blockOfPhotos.append(photo)
        sumOfSection = photo.height
      }
    }
    if !singleSection.blockOfPhotos.isEmpty {
      subsetArrayLst.append(singleSection)
    }
    return subsetArrayLst
  }
}
