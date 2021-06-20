//
//  UIViewController+ActivityIndicator.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik
//
import UIKit

class LoadingIndicatorSpinner {
  var activityIndicator: UIActivityIndicatorView?
  static var sharedLoadingIndicator: LoadingIndicatorSpinner = {
    let loadingIndicator = LoadingIndicatorSpinner()
    loadingIndicator.activityIndicator = UIActivityIndicatorView(style: .large)
    return loadingIndicator
  }()
  
  private init() {}
  // MARK: - Accessors
}

extension UIViewController {

  static func applicationWindow() -> UIWindow? {
    return UIApplication.shared.windows.first
  }
  
  func showSpinner(with color: UIColor = .white) {
    LoadingIndicatorSpinner.sharedLoadingIndicator.activityIndicator?.frame = self.view.frame
    if let activityIndicator = LoadingIndicatorSpinner.sharedLoadingIndicator.activityIndicator {
      activityIndicator.color = color
      let frameSizeCenter = CGPoint(x: UIScreen.main.bounds.size.width * 0.5, y: UIScreen.main.bounds.size.height * 0.5)
      activityIndicator.center = frameSizeCenter
      activityIndicator.startAnimating()
      self.view.addSubview(activityIndicator)
      self.view.bringSubviewToFront(activityIndicator)
    }
  }
  
  func removeSpinner() {
    DispatchQueue.main.async {
      if let activityIndicator = LoadingIndicatorSpinner.sharedLoadingIndicator.activityIndicator {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
      }
    }
  }
}
