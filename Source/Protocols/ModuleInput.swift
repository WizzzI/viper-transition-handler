//
//  ModuleInput.swift
//  B-stream
//
//  Created by Misha Kharitonchick on 27/09/2017.
//  Copyright © 2017 Misha Kharitonchick. All rights reserved.
//

import Foundation

// MARK: - ModuleInput

protocol ModuleInput {
	
	/// Set module output for the current module
	///
	/// - Parameter moduleOutput: ModuleOutput instance
	func setModuleOutput(_ moduleOutput: ModuleOutput)
}

extension ModuleInput {
	func setModuleOutput(_ moduleOutput: ModuleOutput) {
		
	}
}
