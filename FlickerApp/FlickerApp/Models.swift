//
//  Models.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik on 17/06/21.
//

import Foundation

struct ResponseModel: Codable {
  var photos: Photos
}

struct Section {
  var blockOfPhotos: [PhotoModel]
}

struct Photos: Codable {
  var page: Int?
  var pages: Int?
  var photo: [PhotoModel]?
}

struct PhotoModel: Codable, PhotoURL {
  let id: Int? = nil
  var imageUrl: String?
  var width: Int = 0
  var height: Int = 0
  var title: String?
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case imageUrl = "url_n"
    case height = "height_n"
    case width = "width_n"
  }
}

protocol PhotoURL {  }

extension PhotoURL where Self == PhotoModel {
  
  func getImageUrl() -> URL? {
    if let path = self.imageUrl {
      return URL(string: path)
    }
    return nil
  }
}
