//
//  ViewOutputProvider.swift
//  B-stream
//
//  Created by Misha Kharitonchick on 27/09/2017.
//  Copyright © 2017 Misha Kharitonchick. All rights reserved.
//

import Foundation

// MARK: - ViewOutputProvider

protocol ViewOutputProvider {
	
	/// Module input for current object
	var viewOutput: ModuleInput? { get }
}

