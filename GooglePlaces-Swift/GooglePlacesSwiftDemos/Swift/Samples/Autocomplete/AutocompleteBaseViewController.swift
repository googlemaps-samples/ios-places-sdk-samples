// Copyright 2020 Google LLC. All rights reserved.
//
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
// file except in compliance with the License. You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.

import GooglePlaces
import UIKit

/// All other autocomplete demo classes inherit from this class. This class fetches the full place
/// for a selected autocomplete suggestion, and displays the details of the fetched place.
class AutocompleteBaseViewController: UIViewController {
  private lazy var textView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    return textView
  }()

  private lazy var photoButton: UIBarButtonItem = {
    return UIBarButtonItem(
      title: "Photos", style: .plain, target: self, action: #selector(showPhotos))
  }()

  private lazy var pagingPhotoView: PagingPhotoView = {
    let photoView = PagingPhotoView()
    photoView.isHidden = true
    photoView.accessibilityIdentifier = String(describing: PagingPhotoView.self)
    return photoView
  }()

  var autocompleteConfiguration: AutocompleteConfiguration?
  let placesClient = GMSPlacesClient.shared()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    view.addSubview(textView)
    textView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(pagingPhotoView)
    pagingPhotoView.translatesAutoresizingMaskIntoConstraints = false
    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      textView.topAnchor.constraint(equalTo: guide.topAnchor),
      textView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
      textView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
    ])
    NSLayoutConstraint.activate([
      pagingPhotoView.topAnchor.constraint(equalTo: guide.topAnchor),
      pagingPhotoView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
      pagingPhotoView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      pagingPhotoView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
    ])
  }

  @objc func showPhotos() {
    pagingPhotoView.isHidden = false
    navigationItem.rightBarButtonItem = nil
    textView.isHidden = true
  }

  /// Fetches the full place details for an autocomplete suggestion and displays them.
  ///
  /// Passing the session token from the autocomplete request that produced the suggestion
  /// completes that autocomplete billing session.
  func fetchAndDisplayPlace(
    for suggestion: GMSAutocompletePlaceSuggestion,
    sessionToken: GMSAutocompleteSessionToken?
  ) {
    let placeProperties =
      autocompleteConfiguration?.placeProperties ?? GMSPlaceProperty.allProperties
    let request = GMSFetchPlaceRequest(
      placeID: suggestion.placeID,
      placeProperties: placeProperties.map { $0.rawValue },
      sessionToken: sessionToken)
    placesClient.fetchPlace(with: request) { [weak self] place, error in
      guard let self else { return }
      if let error {
        self.autocompleteDidFail(error)
        return
      }
      guard let place else { return }
      self.autocompleteDidSelectPlace(place)
    }
  }

  func autocompleteDidSelectPlace(_ place: GMSPlace) {
    let isOpenRequest = GMSPlaceIsOpenRequest(place: place, date: nil)
    placesClient.isOpen(with: isOpenRequest) { [weak self] response, error in
      guard let self else { return }
      let text = NSMutableAttributedString(string: place.description)
      text.append(NSAttributedString(string: "\nPlace status: "))
      text.append(NSAttributedString(string: response.status.description))
      if let error {
        let errorDescription = String(
          format: NSLocalizedString(
            "Demo.Content.Autocomplete.FailedErrorMessage",
            comment: "Format string for 'autocomplete failed with error' message"), error as NSError
        )
        text.append(NSAttributedString(string: errorDescription))
      }
      if let attributions = place.attributions {
        text.append(NSAttributedString(string: "\n\n"))
        text.append(attributions)
      }

      text.addAttribute(.foregroundColor, value: UIColor.label, range: NSMakeRange(0, text.length))

      self.textView.attributedText = text
      self.textView.isHidden = false
    }
    pagingPhotoView.isHidden = true
    if let photos = place.photos, photos.count > 0 {
      preloadPhotoList(photos: photos)
    }
  }

  func autocompleteDidFail(_ error: Error) {
    textView.text = String(
      format: NSLocalizedString(
        "Demo.Content.Autocomplete.FailedErrorMessage",
        comment: "Format string for 'autocomplete failed with error' message"), error as NSError)
  }

  func autocompleteDidCancel() {
    textView.text = NSLocalizedString(
      "Demo.Content.Autocomplete.WasCanceledMessage",
      comment: "String for 'autocomplete canceled message'")
  }

  override func viewWillTransition(
    to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
  ) {
    super.viewWillTransition(to: size, with: coordinator)
    pagingPhotoView.shouldRedraw = true
  }
}

extension AutocompleteBaseViewController {
  // Preload the photos to be displayed.
  func preloadPhotoList(photos: [GMSPlacePhotoMetadata]) {
    var attributedPhotos: [AttributedPhoto] = []
    DispatchQueue.global().async {
      let downloadGroup = DispatchGroup()
      photos.forEach { photo in
        downloadGroup.enter()
        let fetchPhotoRequest = GMSFetchPhotoRequest(
          photoMetadata: photo, maxSize: CGSize(width: 4800, height: 4800))
        self.placesClient.fetchPhoto(with: fetchPhotoRequest) { image, error in
          if let image, let attributions = photo.attributions {
            attributedPhotos.append(AttributedPhoto(image: image, attributions: attributions))
          }
          downloadGroup.leave()
        }
      }

      downloadGroup.notify(queue: DispatchQueue.main) {
        self.navigationItem.rightBarButtonItem = self.photoButton
        self.pagingPhotoView.updatePhotos(attributedPhotos)
      }
    }
  }
}

extension GMSPlaceOpenStatus: CustomStringConvertible {
  public var description: String {
    switch self {
    case .open:
      return "Open"
    case .closed:
      return "Closed"
    case .unknown:
      return "Unknown"
    default:
      return ""
    }
  }
}
