//
//  FlickerSliderHomeViewController.swift
//  FlickerApp
//
//  Created by Punit Ramachandra Naik on 18/06/21.
//

import UIKit

class FlickerSliderHomeViewController: UIViewController, ErrorHandler {
  
  let scrollView = UIScrollView()
  lazy var imageVerticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    return stackView
  }()
  
  private var viewModel: FlickerScreenViewModel?
  
  // MARK: - Controller Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupScrollView()
    loadData()
  }
  
  private func loadData() {
    viewModel = FlickerScreenViewModel()
    viewModel?.delegate = self
    showSpinner()
    viewModel?.loadData { [weak self] in
      self?.removeSpinner()
      self?.setUpStackView()
    } failureCompletion: { [weak self] error in
      self?.removeSpinner()
      self?.showAlertWithError(error ?? "something went wrong") {[weak self] _ in
        self?.loadData()
      }
    }
  }
  
  // MARK: - UI SetUP Methods
  
  private func setupScrollView() {
    DispatchQueue.main.async { [weak self] in
      guard let safeSelf = self else { return }
      safeSelf.scrollView.translatesAutoresizingMaskIntoConstraints = false
      safeSelf.view.addSubview(safeSelf.scrollView)
      safeSelf.scrollView.centerXAnchor.constraint(equalTo: safeSelf.view.centerXAnchor).isActive = true
      safeSelf.scrollView.widthAnchor.constraint(equalTo: safeSelf.view.widthAnchor).isActive = true
      safeSelf.scrollView.topAnchor.constraint(equalTo: safeSelf.view.topAnchor).isActive = true
      safeSelf.scrollView.bottomAnchor.constraint(equalTo: safeSelf.view.bottomAnchor).isActive = true
    }
  }
  
  private func setUpStackView() {
    DispatchQueue.main.async { [weak self] in
      guard let safeSelf = self else { return }
      safeSelf.imageVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
      safeSelf.scrollView.addSubview(safeSelf.imageVerticalStackView)
      safeSelf.imageVerticalStackView.centerXAnchor.constraint(equalTo: safeSelf.scrollView.centerXAnchor).isActive = true
      safeSelf.imageVerticalStackView.widthAnchor.constraint(equalTo: safeSelf.scrollView.widthAnchor).isActive = true
      safeSelf.imageVerticalStackView.topAnchor.constraint(equalTo: safeSelf.scrollView.topAnchor).isActive = true
      safeSelf.imageVerticalStackView.bottomAnchor.constraint(equalTo: safeSelf.scrollView.bottomAnchor).isActive = true
    }
  }
  
  private func createImageView(image: UIImage) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = image
    return imageView
  }
  
  private func addImageToStack(image: UIImage) {
    let imageView = createImageView(image: image)
    imageVerticalStackView.addArrangedSubview(imageView)
  }
}

extension FlickerSliderHomeViewController: FlickerScreenViewModelDelegate {
  
  func didLoadSectionImage(images: [UIImage]) {
    DispatchQueue.main.async { [weak self] in
      guard let safeSelf = self else { return }
      for image in images {
        safeSelf.addImageToStack(image: image)
      }
      let bottomOffset = CGPoint(x: 0, y: (self?.scrollView.contentSize.height ?? 0))
      self?.scrollView.setContentOffset(bottomOffset, animated: true)
    }
  }
}
