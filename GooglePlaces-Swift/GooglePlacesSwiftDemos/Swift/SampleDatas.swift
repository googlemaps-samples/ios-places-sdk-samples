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

import UIKit

struct Sample {
  let viewControllerClass: UIViewController.Type
  let title: String
}

struct Section {
  let name: String
  let samples: [Sample]
}

enum Samples {
  static func allSamples() -> [Section] {
    let autoCompleteSample: [Sample] = [
      Sample(
        viewControllerClass: AutocompleteWithSearchViewController.self,
        title: NSLocalizedString(
          "Demo.Title.Autocomplete.UISearchController",
          comment:
            "Title of the UISearchController autocomplete demo for display in a list or nav header")
      ),
      Sample(
        viewControllerClass: AutocompleteWithTextFieldController.self,
        title: NSLocalizedString(
          "Demo.Title.Autocomplete.UITextField",
          comment: "Title of the UITextField autocomplete demo for display in a list or nav header")
      ),
    ]
    let currentPlaceSample: [Sample] = [
      Sample(
        viewControllerClass: CurrentPlaceViewController.self,
        title: "Search Nearby (Current Location)")
    ]
    return [
      Section(name: "Autocomplete", samples: autoCompleteSample),
      Section(name: "Current Place", samples: currentPlaceSample),
    ]
  }
}
