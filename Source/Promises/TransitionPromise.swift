//
//  TransitionPromise.swift
//  B-stream
//
//  Created by Misha Kharitonchick on 27/09/2017.
//  Copyright © 2017 Misha Kharitonchick. All rights reserved.
//

import UIKit

typealias TransitionPostLinkAction = () -> Void

// MARK: - TransitionPromise

class TransitionPromise<T> {
	
	// MARK: Properties
	
	private var postLinkAction: TransitionPostLinkAction?
	
	private var animated: Bool = true
	
	private var source: UIViewController
	private var destination: UIViewController
	private var type: T.Type
	
	/// Initilization with source and destination
	///
	/// - Parameters:
	///   - source: Source UIViewController
	///   - destination: Destination UIViewController
	///   - type: ModuleInput type
	
	init(source: UIViewController, destination: UIViewController, for type: T.Type) {
		self.source      = source
		self.destination = destination
		self.type        = type
	}
	
	func then(_ block: TransitionSetupBlock<T>) {
		
		var moduleInput: ModuleInput? = destination.moduleInput
		
		if destination is UINavigationController {
			
			let result = (destination as? UINavigationController)?.topViewController ?? destination
			moduleInput = result.moduleInput
		}
		
		if let moduleInput = moduleInput as? T {
			block(moduleInput)
			self.push()
		} else {
			fatalError("Cannot cast type '\(T.self)' to '\(moduleInput as Any)' object")
		}
	}
	
	func to(preferredTransitionStyle style: TransitionStyle) -> TransitionPromise<T> {
		
		postLinkAction = nil
		
		postLinkAction {
			
			switch style {
			case .navigationController(navigationStyle: let navCase):
				
				guard let navController = self.source.navigationController else {
					return
				}
				
				switch navCase {
				case .pop:
					navController.popToViewController(self.destination, animated: self.animated)
				case .present:
					navController.present(self.destination, animated: self.animated, completion: nil)
				case .push:
					navController.pushViewController(self.destination, animated: self.animated)
				}
				
			case .present:
				self.source.present(self.destination, animated: self.animated, completion: nil)
			}
		}
		
		return self
	}
	
	func animate(_ animate: Bool) -> TransitionPromise<T> {
		self.animated = animate
		return self
	}
	
	func push() {
		self.postLinkAction?()
	}
	
	func postLinkAction( _ completion: @escaping TransitionPostLinkAction) {
		self.postLinkAction = completion
	}
}
