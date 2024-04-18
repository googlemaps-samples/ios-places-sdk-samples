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
import SwiftUI

struct Sample: Hashable {
  enum ViewType: Hashable {
    case swiftUI(any View)
    case uiKit(UIViewController.Type)

    static func == (lhs: Sample.ViewType, rhs: Sample.ViewType) -> Bool {
      switch (lhs, rhs) {
      case (.swiftUI(let lhsView), swiftUI(let rhsView)):
        return type(of: lhsView) == type(of: rhsView)
      case (.uiKit(let lhsViewControllerType), uiKit(let rhsViewControllerType)):
        return lhsViewControllerType == rhsViewControllerType
      default:
        return false
      }
    }

    func hash(into hasher: inout Hasher) {
      switch self {
      case .swiftUI(let view):
        hasher.combine(String(describing: view))
      case .uiKit(let viewControllerType):
        hasher.combine(String(describing: viewControllerType))
      }
    }
  }

  let viewType: ViewType
  let title: String
}

struct SampleSection: Hashable {
  let name: String
  let samples: [Sample]
}

enum Samples {
  static func allSampleSections() -> [SampleSection] {
    let basicSamples: [Sample] = [
      Sample(viewType: .swiftUI(ClientRequests()), title: "Client Requests")
    ]
    return [
      SampleSection(name: "Basic", samples: basicSamples),
    ]
  }
}
