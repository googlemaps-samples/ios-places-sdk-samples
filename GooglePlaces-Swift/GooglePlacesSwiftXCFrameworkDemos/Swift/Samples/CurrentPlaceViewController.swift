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

import CoreLocation
import GooglePlaces
import UIKit

/// Demo that lists the places around the device's current location with
/// `GMSPlacesClient.searchNearby(with:)`. Please refer to
/// https://developers.google.com/maps/documentation/places/ios-sdk/nearby-search
class CurrentPlaceViewController: UIViewController {
  private let cellIdentifier = "NearbyPlaceCellIdentifier"
  private let padding: CGFloat = 20
  private let searchRadius: CLLocationDistance = 250
  private var places: [GMSPlace]?
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    return manager
  }()
  private lazy var errorLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = self
    return tableView
  }()
  private lazy var placesClient: GMSPlacesClient = GMSPlacesClient.shared()
  private var isAuthorized: Bool {
    let status = locationManager.authorizationStatus
    return status == .authorizedAlways || status == .authorizedWhenInUse
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.isTranslucent = false
    view.backgroundColor = .systemBackground

    let button = UIButton()
    button.setTitle("Find places near current location", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(
      self, action: #selector(findPlacesNearCurrentLocation), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
      button.heightAnchor.constraint(equalToConstant: 40),
      button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
    ])

    errorLabel.isHidden = true
    errorLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(errorLabel)
    NSLayoutConstraint.activate([
      errorLabel.topAnchor.constraint(equalTo: button.bottomAnchor, constant: padding),
      errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
    ])

    tableView.isHidden = true
    tableView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: padding),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    findPlacesNearCurrentLocation()
  }

  @objc func findPlacesNearCurrentLocation() {
    guard isAuthorized else {
      locationManager.requestWhenInUseAuthorization()
      return
    }
    locationManager.requestLocation()
  }

  private func searchNearby(coordinate: CLLocationCoordinate2D) {
    let request = GMSPlaceSearchNearbyRequest(
      locationRestriction: GMSPlaceCircularLocationOption(coordinate, searchRadius),
      placeProperties: [
        GMSPlaceProperty.name.rawValue, GMSPlaceProperty.formattedAddress.rawValue,
      ])
    placesClient.searchNearby(
      with: request,
      completion: { [weak self] response, error in
        guard let self else { return }
        guard error == nil else {
          self.showError("There was an error searching for nearby places.")
          return
        }

        self.places = response?.places?.filter { !($0.name?.isEmpty ?? true) }
        self.errorLabel.isHidden = true
        self.tableView.isHidden = false
        self.tableView.reloadData()
      })
  }

  private func showError(_ message: String) {
    errorLabel.text = message
    errorLabel.isHidden = false
    tableView.isHidden = true
  }
}

extension CurrentPlaceViewController: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    if isAuthorized {
      // Retry the current location fetch once the user enables Location Services.
      findPlacesNearCurrentLocation()
    } else if manager.authorizationStatus != .notDetermined {
      showError("Please make sure location services are enabled.")
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    searchNearby(coordinate: location.coordinate)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    showError("Unable to determine the current location.")
  }
}

extension CurrentPlaceViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return places?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    guard let places, indexPath.row < places.count else {
      return cell
    }
    let place = places[indexPath.row]
    var content = cell.defaultContentConfiguration()
    content.text = place.name
    content.secondaryText = place.formattedAddress
    cell.contentConfiguration = content
    cell.selectionStyle = .none
    return cell
  }
}
