//
//  Module.swift
//  B-stream
//
//  Created by Misha Kharitonchick on 27/09/2017.
//  Copyright © 2017 Misha Kharitonchick. All rights reserved.
//

import UIKit

// MARK: - Module

protocol Module {
	
	associatedtype Input
	
	init()
	
	/// Instantiate transition handler
	///
	/// - Returns: UIViewController instance
	func instantiateTransitionHandler() -> UIViewController
}

