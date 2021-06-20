//
//  FlickerApiManager.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik on 17/06/21.
//

import Foundation
import NetworkManagerPackage

class FlickerApiManager {

  // MARK: - Api calls

  static func getImageList(succesCompletion: @escaping (_ response: ResponseModel?) -> Void,
                           failureCompletion: @escaping FailureCompletionHandler) {
    let networkManager = NetworkManager.shared()
    networkManager.fetchRequest(FlickerApi.fetchImages,
                                succesCompletion: succesCompletion,
                                failureCompletion: failureCompletion)

  }

}
