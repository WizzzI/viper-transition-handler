//
//  TransitionHandler.swift
//  B-stream
//
//  Created by Misha Kharitonchick on 27/09/2017.
//  Copyright © 2017 Misha Kharitonchick. All rights reserved.
//

import UIKit

typealias TransitionSetupBlock<T> = (T) -> Void

// MARK: - TransitionHandler

protocol TransitionHandler: class {
	
	var moduleInput: ModuleInput? { get set }
	
	
	/// Transition with ModuleFactory
	///
	/// - Parameters:
	///   - moduleFactory: ModuleFactory instance
	///   - type: ModuleInput type
	/// - Returns: Promise with setups
	func openModule<M>(_ moduleType: M.Type) -> TransitionPromise<M.Input> where M: Module
	
	/// Add submodule to your view controller container
	///
	/// - Parameters:
	///   - moduleType: module to insert
	///   - frame: frame to locate view submodule on view viewcontrolller container
	func addSubmodule<M>(_ moduleType: M.Type, on frame: CGRect) -> TransitionSubmodulePromise<M.Input> where M: Module
	
	/// Standard performSegueWithIdentifier
	///
	/// - Parameter segueIdentifier: Given segue identifier
	func performSegue(_ segueIdentifier: String)
	
	/// Transition with segue identifier and setup block
	///
	/// - Parameters:
	///   - segueIdentifier: Given segue identifier
	///   - type: Moduleinput type
	///   - setup: Block for setup ModuleInput
	func openModuleUsingSegue<T>(_ segueIdentifier: String, to type: T.Type, setup: @escaping TransitionSetupBlock<T>)
	
	/// Close current module
	///
	/// - Parameter animated: true if need to animate transition
	func closeCurrentModule(animated: Bool)
}

class TransitionSubmodulePromise<T> {
	
	private var destination: UIViewController
	
	init(destination: UIViewController) {
		self.destination = destination
	}
	
	func then(_ block: (T)->()) {
		let moduleInput: ModuleInput? = destination.moduleInput
		if let moduleInput = moduleInput as? T {
			block(moduleInput)
		} else {
			fatalError("Cannot cast type '\(T.self)' to '\(moduleInput as Any)' object")
		}
	}
}


