//
//  Sector.swift
//  Story Wheel
//
//  Created by Vijay Sharma on 2016-02-13.
//  Copyright © 2016 Vijay Sharma. All rights reserved.
//

import UIKit

class Sector: NSObject {
	let midValue: Double
	let maxValue: Double
	let minValue: Double
	let index: Int
	
	init(index:Int, mid midValue: Double, max maxValue: Double, min minValue: Double) {
		self.index = index
		self.midValue = midValue
		self.maxValue = maxValue
		self.minValue = minValue
	}
}
