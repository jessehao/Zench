//
//  StandardTimer.swift
//  Zench
//
//  Created by Jesse Hao on 2018/10/23.
//  Copyright © 2018 Snoware. All rights reserved.
//

class StandardTimer: NSObject {
	private var timer:Timer?
	
	// MARK: - Properties
	private(set) var isCountingDown:Bool = false
	private(set) var seconds:UInt = 60
	var initialSeconds:UInt = 60
	// Event Handlers
	var countingDownEventHandlers:[(UInt) -> Void] = []
	var countDownDidEndEventHandlers:[() -> Void] = []
	
	// MARK: - Lifecycle
	convenience init(seconds:UInt) {
		self.init()
		self.initialSeconds = seconds
	}
	
	// MARK: - Actions
	@objc private func timerCountingDown() {
		let interval:UInt = UInt(self.timer!.timeInterval)
		self.seconds -= interval
		if self.seconds == 0 {
			self.timer?.invalidate()
			self.isCountingDown = false
			self.triggerCountDownDidEndEventHandlers()
		}
		self.triggerCountingDownEventHandlers()
	}
	
	// MARK: - Operations
	func start() {
		self.timer?.invalidate()
		self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCountingDown), userInfo: nil, repeats: true)
		self.isCountingDown = true
		self.seconds = self.initialSeconds
		self.timer?.fire()
	}
	
	func start(withCountDownEventHandler eventHandler:@escaping (UInt) -> Void) {
		self.countingDownEventHandlers.append(eventHandler)
		self.start()
	}
	
	private func triggerCountingDownEventHandlers() {
		self.countingDownEventHandlers.forEach { $0(self.seconds) }
	}
	
	private func triggerCountDownDidEndEventHandlers() {
		self.countDownDidEndEventHandlers.forEach { $0() }
	}
}
