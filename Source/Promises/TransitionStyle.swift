//
//  TransitionStyle.swift
//  B-stream
//
//  Created by Misha Kharitonchick on 27/09/2017.
//  Copyright © 2017 Misha Kharitonchick. All rights reserved.
//

import Foundation

// MARK: - TransitionStyle

/// Sets the current transitional period
///
/// - navigationController: Will be added to navigation controller
/// - present: Will be presented

enum TransitionStyle {
	case navigationController(navigationStyle: TransitionNavigationStyle)
	case present
}
