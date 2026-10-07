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

/// Demo showing autocomplete suggestions in the results view of a `UISearchController`, using
/// `GMSPlacesClient.fetchAutocompleteSuggestions(from:)`. Please refer to
/// https://developers.google.com/places/ios-sdk/autocomplete
class AutocompleteWithSearchViewController: AutocompleteBaseViewController {
  let searchBarAccessibilityIdentifier = "searchBarAccessibilityIdentifier"

  private lazy var resultsController: AutocompleteResultsViewController = {
    let controller = AutocompleteResultsViewController()
    controller.autocompleteFilter = autocompleteConfiguration?.autocompleteFilter
    controller.delegate = self
    return controller
  }()

  private lazy var searchController: UISearchController = {
    let controller = UISearchController(searchResultsController: resultsController)
    controller.hidesNavigationBarDuringPresentation = false
    controller.searchBar.autoresizingMask = .flexibleWidth
    controller.searchBar.searchBarStyle = .minimal
    controller.searchBar.delegate = self
    controller.searchBar.accessibilityIdentifier = searchBarAccessibilityIdentifier
    controller.searchBar.sizeToFit()
    return controller
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.titleView = searchController.searchBar
    definesPresentationContext = true

    searchController.searchResultsUpdater = resultsController
    searchController.modalPresentationStyle =
      UIDevice.current.userInterfaceIdiom == .pad ? .popover : .fullScreen
  }
}

extension AutocompleteWithSearchViewController: AutocompleteResultsViewControllerDelegate {
  func resultsController(
    _ resultsController: AutocompleteResultsViewController,
    didSelect suggestion: GMSAutocompletePlaceSuggestion
  ) {
    searchController.isActive = false
    fetchAndDisplayPlace(for: suggestion, sessionToken: resultsController.sessionToken)
    resultsController.startNewSession()
  }

  func resultsController(
    _ resultsController: AutocompleteResultsViewController, didFailWith error: Error
  ) {
    searchController.isActive = false
    super.autocompleteDidFail(error)
  }
}

extension AutocompleteWithSearchViewController: UISearchBarDelegate {
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    // Inform user that the autocomplete query has been cancelled and dismiss the search bar.
    searchController.isActive = false
    searchController.searchBar.isHidden = true
    super.autocompleteDidCancel()
  }
}
