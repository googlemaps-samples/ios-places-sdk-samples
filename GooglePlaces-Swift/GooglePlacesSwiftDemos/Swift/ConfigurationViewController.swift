// Copyright 2021 Google LLC. All rights reserved.
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

/// The section of configuration.
struct ConfigSection {
  let name: String
  let samples: [ConfigData]
}

/// The configuration data.
struct ConfigData {
  let name: String
  let tag: Int
  let action: Selector
}

/// The location option for autocomplete search.
enum LocationOption: Int {
  case unspecified = 100
  case canada = 101
  case kansas = 102

  var northEast: CLLocationCoordinate2D {
    switch self {
    case .canada:
      return CLLocationCoordinate2D(latitude: 70.0, longitude: -60.0)
    case .kansas:
      return CLLocationCoordinate2D(latitude: 39.0, longitude: -95.0)
    default:
      return CLLocationCoordinate2D()
    }
  }

  var southWest: CLLocationCoordinate2D {
    switch self {
    case .canada:
      return CLLocationCoordinate2D(latitude: 50.0, longitude: -140.0)
    case .kansas:
      return CLLocationCoordinate2D(latitude: 37.5, longitude: -100.0)
    default:
      return CLLocationCoordinate2D()
    }
  }
}

/// Manages the configuration options view for the demo app.
class ConfigurationViewController: UIViewController {
  // MARK: - Properties

  private let cellIdentifier = "cellIdentifier"
  private let filterTagBase = 1000

  /// The selectable type collections for `GMSAutocompleteFilter.types`.
  static let filterTypeOptions: [(name: String, types: [String])] = [
    ("Geocode", ["geocode"]),
    ("Address", ["address"]),
    ("Establishment", ["establishment"]),
    ("Region", ["(regions)"]),
    ("City", ["(cities)"]),
  ]

  private lazy var configurationSections: [ConfigSection] = {
    var sections: [ConfigSection] = []

    let autocompleteFiltersSelector = #selector(autocompleteFiltersSwitch)
    let filterSamples = Self.filterTypeOptions.enumerated().map { (index, option) in
      ConfigData(name: option.name, tag: filterTagBase + index, action: autocompleteFiltersSelector)
    }
    sections.append(ConfigSection(name: "Autocomplete filters", samples: filterSamples))

    let canada = ConfigData(
      name: "Canada", tag: LocationOption.canada.rawValue, action: #selector(canadaSwitch))
    let kansas = ConfigData(
      name: "Kansas", tag: LocationOption.kansas.rawValue, action: #selector(kansasSwitch))
    sections.append(
      ConfigSection(name: "Autocomplete Restriction Bounds", samples: [canada, kansas]))

    var placeSamples = [ConfigData]()
    let actionSelector = #selector(placesPropertiesSwitch)
    for (index, property) in GMSPlaceProperty.allProperties.enumerated() {
      placeSamples.append(
        ConfigData(name: property.description, tag: index, action: actionSelector))
    }
    sections.append(ConfigSection(name: "Place Properties", samples: placeSamples))
    return sections
  }()

  private var configuration: AutocompleteConfiguration

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  private lazy var closeButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .systemBlue
    button.setTitle("Close", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(tapCloseButton(_:)), for: .touchUpInside)
    return button
  }()

  // MARK: - Public functions

  public init(configuration: AutocompleteConfiguration) {
    self.configuration = configuration
    super.init(nibName: nil, bundle: nil)
  }

  required init(coder: NSCoder) { fatalError() }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(tableView)
    view.addSubview(closeButton)
    let guide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: guide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: closeButton.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
    ])
    NSLayoutConstraint.activate([
      closeButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
      closeButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
      closeButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
    ])
  }

  // MARK: - Private functions

  @objc private func tapCloseButton(_ sender: UISwitch) {
    dismiss(animated: true)
    guard let location = configuration.location else { return }
    let northEast = location.northEast
    let southWest = location.southWest
    // Update configuration
    switch location {
    case .canada, .kansas:
      configuration.autocompleteFilter.origin = CLLocation(
        latitude: northEast.latitude, longitude: northEast.longitude)
      configuration.autocompleteFilter.locationRestriction =
        GMSPlaceRectangularLocationOption(northEast, southWest)
    default:
      configuration.autocompleteFilter.origin = nil
      configuration.autocompleteFilter.locationRestriction = nil
    }
  }

  @objc private func autocompleteFiltersSwitch(_ sender: UISwitch) {
    for sample in configurationSections[0].samples {
      guard let switchView = view.viewWithTag(sample.tag) as? UISwitch else { continue }
      if switchView.tag != sender.tag {
        switchView.setOn(false, animated: true)
      }
    }
    // The index of the option is tag - filterTagBase
    let index = sender.tag - filterTagBase
    guard index >= 0 && index < Self.filterTypeOptions.count else { return }
    configuration.autocompleteFilter.types = sender.isOn ? Self.filterTypeOptions[index].types : nil
  }

  @objc private func canadaSwitch(_ sender: UISwitch) {
    if sender.isOn {
      // Turn off the Kansas switch
      guard let switchView = view.viewWithTag(LocationOption.kansas.rawValue) as? UISwitch else {
        return
      }
      switchView.setOn(false, animated: true)
      configuration.location = .canada
    } else {
      configuration.location = .unspecified
    }
  }

  @objc private func kansasSwitch(_ sender: UISwitch) {
    if sender.isOn {
      // Turn off the Canada switch
      guard let switchView = view.viewWithTag(LocationOption.canada.rawValue) as? UISwitch else {
        return
      }
      switchView.setOn(false, animated: true)
      configuration.location = .kansas
    } else {
      configuration.location = .unspecified
    }
  }

  @objc private func placesPropertiesSwitch(_ sender: UISwitch) {
    let property = GMSPlaceProperty.allProperties[sender.tag]

    if sender.isOn {
      configuration.placeProperties.append(property)
    } else {
      let properties = configuration.placeProperties.filter { $0 != property }
      configuration.placeProperties = properties
    }
  }
}

extension ConfigurationViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard section <= configurationSections.count else {
      return 0
    }
    return configurationSections[section].samples.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: cellIdentifier, for: indexPath)
    guard
      indexPath.section < configurationSections.count
        && indexPath.row < configurationSections[indexPath.section].samples.count
    else { return cell }
    let sample = configurationSections[indexPath.section].samples[indexPath.row]
    cell.textLabel?.text = sample.name
    let switchView = UISwitch(frame: .zero)
    switchView.tag = Int(sample.tag)
    switch indexPath.section {
    case 0:
      let option = Self.filterTypeOptions[indexPath.row]
      if configuration.autocompleteFilter.types == option.types {
        switchView.setOn(true, animated: false)
      }
    case 1:
      let isOn = (sample.tag == configuration.location?.rawValue)
      switchView.setOn(isOn, animated: false)
    case 2:
      let property = GMSPlaceProperty.allProperties[indexPath.row]
      if configuration.placeProperties.contains(property) {
        switchView.setOn(true, animated: false)
      }
    default:
      break
    }
    switchView.addTarget(self, action: sample.action, for: .valueChanged)
    cell.accessoryView = switchView
    return cell
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    configurationSections.count
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard section <= configurationSections.count else {
      return ""
    }
    return configurationSections[section].name
  }
}

extension ConfigurationViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sample = configurationSections[indexPath.section].samples[indexPath.row]
    let cell = tableView.cellForRow(at: indexPath)
    guard let switchView = cell?.accessoryView as? UISwitch else { return }
    switchView.setOn(!switchView.isOn, animated: true)
    perform(sample.action, with: switchView)
  }
}

extension GMSPlaceProperty: CustomStringConvertible {
  /// All place properties.
  public static var allProperties: [GMSPlaceProperty] = [
    .name,
    .placeID,
    .plusCode,
    .coordinate,
    .openingHours,
    .phoneNumber,
    .formattedAddress,
    .rating,
    .priceLevel,
    .types,
    .website,
    .viewport,
    .addressComponents,
    .photos,
    .userRatingsTotal,
    .utcOffsetMinutes,
    .businessStatus,
    .iconImageURL,
    .iconBackgroundColor,
    .takeout,
    .delivery,
    .dineIn,
    .curbsidePickup,
    .reservable,
    .servesBreakfast,
    .servesLunch,
    .servesDinner,
    .servesBeer,
    .servesWine,
    .servesBrunch,
    .servesVegetarianFood,
    .wheelchairAccessibleEntrance,
    .editorialSummary,
    .currentOpeningHours,
    .secondaryOpeningHours,
  ]

  public var description: String {
    switch self {
    case .name: return "Name"
    case .placeID: return "Place ID"
    case .plusCode: return "Plus Code"
    case .coordinate: return "Coordinate"
    case .openingHours: return "Opening Hours"
    case .phoneNumber: return "Phone Number"
    case .formattedAddress: return "Formatted Address"
    case .rating: return "Rating"
    case .priceLevel: return "Price Level"
    case .types: return "Types"
    case .website: return "Website"
    case .viewport: return "Viewport"
    case .addressComponents: return "Address Components"
    case .photos: return "Photos"
    case .userRatingsTotal: return "User Ratings Total"
    case .utcOffsetMinutes: return "UTC Offset Minutes"
    case .businessStatus: return "Business Status"
    case .iconImageURL: return "Icon Image URL"
    case .iconBackgroundColor: return "Icon Background Color"
    case .takeout: return "Takeout"
    case .delivery: return "Delivery"
    case .dineIn: return "Dine In"
    case .curbsidePickup: return "Curbside Pickup"
    case .reservable: return "Reservable"
    case .servesBreakfast: return "Serves Breakfast"
    case .servesLunch: return "Serves Lunch"
    case .servesDinner: return "Serves Dinner"
    case .servesBeer: return "Serves Beer"
    case .servesWine: return "Serves Wine"
    case .servesBrunch: return "Serves Brunch"
    case .servesVegetarianFood: return "Serves Vegetarian Food"
    case .wheelchairAccessibleEntrance: return "Wheelchair Accessible Entrance"
    case .currentOpeningHours: return "Current Opening Hours"
    case .secondaryOpeningHours: return "Secondary Opening Hours"
    case .editorialSummary: return "Editorial Summary"
    default: return "Unknown Case"
    }
  }
}
