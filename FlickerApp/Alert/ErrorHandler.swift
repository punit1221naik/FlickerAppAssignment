//
//  ErrorHandler.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik
//

import UIKit

protocol ErrorHandler {
  typealias Events = (_ retry: Bool) -> Void
  
  func showAlertWithError(_ message: String, completionHandler: @escaping Events)
}

extension ErrorHandler where Self: UIViewController {
  
  // MARK: - Show Error Alert
  func showAlertWithError(_ message: String, completionHandler: @escaping Events) {
    DispatchQueue.main.async { [weak self] in
      let alert = UIAlertController(title: NSLocalizedString("Opps!", comment: ""),
                                    message: message,
                                    preferredStyle: .alert)
      
      alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                    style: .cancel,
                                    handler: nil))
      
      alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""),
                                    style: .default,
                                    handler: { _ in completionHandler(true) }))
      self?.present(alert, animated: true, completion: nil)
    }
  }
}
