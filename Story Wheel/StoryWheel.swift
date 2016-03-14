//
//  StoryWheel.swift
//  Story Wheel
//
//  Created by Vijay Sharma on 2016-02-12.
//  Copyright © 2016 Vijay Sharma. All rights reserved.
//

import UIKit

class StoryWheel: UIView {
	let sections: [String]
	var arrow: UIImageView!
	var sectors:[Sector] = []
	var currentAngle:Double = 0
	var delegate:StoryWheelDelegate?
	
	init(frame: CGRect, sections:[String], delegate:StoryWheelDelegate) {
		self.sections = sections
		self.delegate = delegate
		super.init(frame:frame)
		initView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		let s:String? = aDecoder.decodeObjectForKey("sections") as? String
		self.sections = (s?.componentsSeparatedByString(":"))!
		super.init(coder: aDecoder)
		initView()
	}
	
	override func encodeWithCoder(aCoder: NSCoder) {
		aCoder.encodeObject(self.sections.joinWithSeparator(":"), forKey: "sections")
	}
	
	func rotate() {
		let index = arc4random_uniform(UInt32(self.sections.count))
		let angle = sectors[Int(index)].midValue
		let spin = arc4random_uniform(3) + 2
		let duration = Double(arc4random_uniform(30) + 30) / 10.0
//		print("rotate: \(index): \(sections[Int(index)]) \(rad2Deg(angle))")
		runSpinAnimationOnView(arrow, from:currentAngle, to:angle, spin:Double(spin), duration:duration)
	}
	
	private func on(radians: Double) {
//		print("end: \(rad2Deg(radians))")
		for sector in sectors {
			if radians > sector.minValue && radians < sector.maxValue {
				self.currentAngle = sector.midValue
				if let delegate = delegate {
					delegate.storyWheel(sector.index)
				}
				break;
			}
		}
	}
	
	private func initView() {
		let container = UIView(frame: self.frame)
		container.userInteractionEnabled = false
		
		arrow = UIImageView(image: UIImage(named: "arrow"))
		arrow.layer.anchorPoint = CGPointMake(0.85, 0.5)
		arrow.layer.position = CGPointMake(
			container.bounds.size.width/2.0,
			container.bounds.size.height/2.0
		)
		
		let angleSize = 2 * M_PI / Double(self.sections.count)
		let fan = angleSize / 2
		
		for section in 0..<self.sections.count {
			let angle = angleSize * Double(section)
			let segment = UIImageView(image: UIImage(named: self.sections[section]))
			segment.layer.anchorPoint = CGPointMake(1.0, 0.5)
			segment.layer.position = CGPointMake(
				container.bounds.size.width/2.0,
				container.bounds.size.height/2.0
			)
			segment.transform = CGAffineTransformMakeRotation(CGFloat(angle))
			container .addSubview(segment)

			let midValue = angle
			let minValue = angle - fan
			let maxValue = angle + fan
			
			let sector = Sector(index: section, mid:midValue, max:maxValue, min:minValue)
//			print("\(section): min:\(rad2Deg(minValue)) mid:\(rad2Deg(midValue)) max:\(rad2Deg(maxValue))")
			self.sectors.append(sector)
		}
		
		self.addSubview(container)
		self.addSubview(arrow)
	}
	
	private func runSpinAnimationOnView(view: UIView!, from:Double, to:Double, spin:Double, duration:Double) {
		CATransaction.begin()
			let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
			rotation.fromValue = from;
			rotation.toValue = (to + (M_PI * 2.0) * spin)
			rotation.duration = duration
			rotation.cumulative = true
			rotation.repeatCount = 1
			rotation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			CATransaction.setCompletionBlock { () -> Void in
				view.layer.removeAnimationForKey("rotationAnimation")
				view.transform = CGAffineTransformMakeRotation(CGFloat(to))
				self.on(to)
			}
		
			view.layer.addAnimation(rotation, forKey: "rotationAnimation")
		CATransaction.commit()
	}
	
	private func rad2Deg(radians: Double) -> Double {
		return radians * (180.0 / M_PI)
	}
}
