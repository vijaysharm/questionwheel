//
//  ViewController.swift
//  Story Wheel
//
//  Created by Vijay Sharma on 2016-02-11.
//  Copyright © 2016 Vijay Sharma. All rights reserved.
//

import UIKit

class ViewController: UIViewController, StoryWheelDelegate {
	let sections: [String] = ["who", "how", "why", "what", "when", "where"]
	var spinner: StoryWheel!
	var background: UIImageView!
	var topTitle: UIImageView!
	var instructions: UIImageView!
	var pick: UIImageView!
	var isAnimating: Bool = false
	
	override func viewDidLoad() {
		spinner = StoryWheel(frame: CGRectMake(0, 0, 300, 300), sections:sections, delegate:self)
		background = UIImageView(image: UIImage(named: "background"))
		topTitle = UIImageView(image: UIImage(named: "title"))
		instructions = UIImageView(image: UIImage(named: "tap"))
		pick = UIImageView()
		
		self.view.addSubview(background)
		self.view.addSubview(spinner)
		self.view.addSubview(topTitle)
		self.view.addSubview(instructions)
		self.view.addSubview(pick)
		
		setPositions(self.view.bounds.size)
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if isAnimating {
			return
		}
		
		isAnimating = true
		spinner.rotate()
	}
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent;
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator:UIViewControllerTransitionCoordinator) {
		self.setPositions(size)
	}

	func storyWheel(index: Int) {
//		print("Selected: \(index): \(sections[index])")
		
		let size = self.view.bounds.size
		pick.image = UIImage(named: "\(sections[index])_label")
		pick.frame = CGRectMake(0, 0, self.pick.image!.size.width, self.pick.image!.size.height)
		pick.center = CGPointMake(size.width / 2.0, size.height / 2.0)
		
		self.pick.alpha = 1
		pick.transform = CGAffineTransformMakeScale(0.1, 0.1)
		UIView.animateWithDuration(
			0.8,
			delay: 0.0,
			usingSpringWithDamping: 0.5,
			initialSpringVelocity: 0,
			options: .CurveEaseOut,
			animations: { () -> Void in
				self.pick.transform = CGAffineTransformIdentity
			},
			completion: nil
		)
		
		UIView.animateWithDuration(
			0.3,
			delay: 2.5,
			options: .CurveEaseIn,
			animations: { () -> Void in
				self.pick.transform = CGAffineTransformMakeScale(0.1, 0.1)
				self.pick.alpha = 0
			}, completion:{_ -> Void in
				self.pick.transform = CGAffineTransformIdentity
				self.isAnimating = false
		})
	}
	
	private func setPositions(size: CGSize) {
		topTitle.center = CGPointMake(size.width / 2.0, 104)
		instructions.center = CGPointMake(size.width / 2.0, size.height - 104)
		spinner.center = CGPointMake(size.width / 2.0, size.height / 2.0)
		background.center = CGPointMake(size.width / 2.0, size.height / 2.0)
		pick.center = CGPointMake(size.width / 2.0, size.height / 2.0)

		if size.width >= size.height {
			background.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
		} else {
			background.transform = CGAffineTransformMakeRotation(0);
		}
	}
}
