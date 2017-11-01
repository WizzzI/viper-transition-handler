//
//  UIViewController.swift
//  B-stream
//
//  Created by Misha Kharitonchick on 27/09/2017.
//  Copyright © 2017 Misha Kharitonchick. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func removeFromViewControllerContainer() {
		self.didMove(toParentViewController: nil)
		self.view.removeFromSuperview()
		self.removeFromParentViewController()
	}
}

// MARK: - TransitionHandler
extension UIViewController: TransitionHandler {
	
	func addSubmodule<M>(_ moduleType: M.Type, on frame: CGRect) -> TransitionSubmodulePromise<M.Input> where M : Module {
		let module = M()
		let controller = module.instantiateTransitionHandler()
		self.addChildViewController(controller)
		controller.view.frame = frame
		controller.didMove(toParentViewController: self)
		self.view.addSubview(controller.view)
		let transition = TransitionSubmodulePromise<M.Input>(destination: controller)
		return transition
	}
	
	private struct ModuleInputAssociatedKey {
		static var moduleInput: ModuleInput?
	}
	
	var moduleInput: ModuleInput? {
		get {
			guard let result = objc_getAssociatedObject(self, &ModuleInputAssociatedKey.moduleInput) as? ModuleInput else {
				if let result = (self as? ViewOutputProvider)?.viewOutput {
					return result
				} else {
					fatalError("Your UIViewController must implement protocol 'ViewOutputProvider'!")
				}
			}
			return result
		}
		
		set (moduleInput) {
			objc_setAssociatedObject(self, &ModuleInputAssociatedKey.moduleInput, moduleInput, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	func openModule<M>(_ moduleType: M.Type) -> TransitionPromise<M.Input> where M: Module {
		
		let module = M()
		let destination = module.instantiateTransitionHandler()
		let promise = TransitionPromise(source: self, destination: destination, for: M.Input.self)
		
		promise.postLinkAction {
			self.present(destination, animated: true, completion: nil)
		}
		
		return promise
	}
	
	func performSegue(_ segueIdentifier: String) {
		DispatchQueue.main.async {
			self.performSegue(withIdentifier: segueIdentifier, sender: nil)
		}
	}
	
	func openModuleUsingSegue<T>(_ segueIdentifier: String, to type: T.Type, setup: @escaping (T) -> Void) {
		DispatchQueue.main.async {
			self.performSegue(withIdentifier: segueIdentifier, sender: nil) { segue in
				
				var destination = segue.destination
				
				guard let moduleInput = destination.moduleInput as? T else {
					fatalError("Cannot cast controller \(String(describing: destination.self)) to expected type \(type)")
				}
				
				if destination is UINavigationController {
					destination = (segue.destination as? UINavigationController)?.topViewController ?? segue.destination
				}
				
				setup(moduleInput)
			}
		}
	}
	
	func closeCurrentModule(animated: Bool) {
		if let parent = parent as? UINavigationController, parent.childViewControllers.count > 1 {
			parent.popViewController(animated: animated)
		} else if let _ = presentingViewController {
			dismiss(animated: animated, completion: nil)
		} else {
			removeFromParentViewController()
			view?.removeFromSuperview()
		}
	}
}

// MARK: - Swizzling
extension UIViewController {
	
	class Value {
		
		let value: Any?
		
		init(_ value: Any?) {
			self.value = value
		}
	}
	
	@nonobjc static var PrepareForSegueKey = "com.incetro.method.prepareForSegue"
	
	var performSegueConfig: PerformSegueConfig? {
		
		get {
			let value = objc_getAssociatedObject(self, &UIViewController.PrepareForSegueKey) as? Value
			return value?.value as? PerformSegueConfig
		}
		
		set {
			objc_setAssociatedObject(self, &UIViewController.PrepareForSegueKey, Value(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	typealias PerformSegueConfig = (UIStoryboardSegue) -> ()
	
	func performSegue(withIdentifier identifier: String, sender: Any?, completion: @escaping PerformSegueConfig) {
		performSegueConfig = completion
		performSegue(withIdentifier: identifier, sender: sender)
	}
	
	func swizzledPrepare(for segue: UIStoryboardSegue, sender: Any?) {
		performSegueConfig?(segue)
		swizzledPrepare(for: segue, sender: sender)
		performSegueConfig = nil
	}
}




