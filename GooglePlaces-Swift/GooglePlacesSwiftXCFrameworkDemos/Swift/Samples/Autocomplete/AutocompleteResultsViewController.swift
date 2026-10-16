// Copyright 2026 Google LLC. All rights reserved.
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

protocol AutocompleteResultsViewControllerDelegate: AnyObject {
  func resultsController(
    _ resultsController: AutocompleteResultsViewController,
    didSelect suggestion: GMSAutocompletePlaceSuggestion)
  func resultsController(
    _ resultsController: AutocompleteResultsViewController, didFailWith error: Error)
}

/// A table of autocomplete suggestions for a query, fetched with
/// `GMSPlacesClient.fetchAutocompleteSuggestions(from:)`. Text input can come from any source;
/// feed each change of the query text to `update(query:)`, or install this controller as the
/// results updater of a `UISearchController`.
class AutocompleteResultsViewController: UITableViewController {
  private let cellIdentifier = "SuggestionCellIdentifier"

  weak var delegate: AutocompleteResultsViewControllerDelegate?
  var autocompleteFilter: GMSAutocompleteFilter?

  /// The token that groups the autocomplete requests of one session into a single billed session.
  /// The session is completed by a fetch-place request made with this same token; start a new
  /// session for any autocomplete requests after that.
  private(set) var sessionToken = GMSAutocompleteSessionToken()

  private let placesClient = GMSPlacesClient.shared()
  private var suggestions: [GMSAutocompletePlaceSuggestion] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.backgroundColor = .systemBackground
  }

  /// Begins a new autocomplete billing session.
  func startNewSession() {
    sessionToken = GMSAutocompleteSessionToken()
  }

  /// Fetches autocomplete suggestions for the query and displays them.
  func update(query: String) {
    guard !query.isEmpty else {
      clearResults()
      return
    }
    let request = GMSAutocompleteRequest(query: query)
    request.sessionToken = sessionToken
    request.filter = autocompleteFilter
    placesClient.fetchAutocompleteSuggestions(from: request) { [weak self] suggestions, error in
      guard let self else { return }
      if let error {
        self.delegate?.resultsController(self, didFailWith: error)
        return
      }
      self.suggestions = (suggestions ?? []).compactMap { $0.placeSuggestion }
      self.tableView.reloadData()
    }
  }

  func clearResults() {
    suggestions = []
    tableView.reloadData()
  }

  // MARK: - UITableViewDataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return suggestions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    let suggestion = suggestions[indexPath.row]
    var content = cell.defaultContentConfiguration()
    content.attributedText = suggestion.attributedPrimaryText
    if let secondaryText = suggestion.attributedSecondaryText {
      content.secondaryAttributedText = secondaryText
    }
    cell.contentConfiguration = content
    return cell
  }

  // MARK: - UITableViewDelegate

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    delegate?.resultsController(self, didSelect: suggestions[indexPath.row])
  }
}

extension AutocompleteResultsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    update(query: searchController.searchBar.text ?? "")
  }
}
