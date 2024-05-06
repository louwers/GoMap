//
//  GpxTrackAttributes.swift
//  Go Map!!
//
//  Created by Bryce Cogswell on 5/5/24.
//  Copyright © 2024 Bryce Cogswell. All rights reserved.
//

import ActivityKit
import AppIntents
import SwiftUI

struct GpxTrackAttributes: ActivityAttributes {
	public typealias GpxTrackStatus = ContentState
	public struct ContentState: Codable, Hashable {
		var startTime: Date
		var endTime: Date?
		var pointCount: Int
		var showButton: Bool

		var durationHMS: String {
			let formatter = DateComponentsFormatter()
			formatter.allowedUnits = [.minute, .second]
			formatter.zeroFormattingBehavior = .pad
			return formatter.string(from: (endTime ?? Date()).timeIntervalSince(startTime))!
		}

		init(startTime: Date, endTime: Date? = nil, pointCount: Int = 0, showButton: Bool = true) {
			self.startTime = startTime
			self.endTime = endTime
			self.pointCount = pointCount
			self.showButton = showButton
		}
	}
}

@available(iOS 16.1, *)
struct EnableGpxTrackIntent: LiveActivityIntent {
	static var title: LocalizedStringResource = "Enable GPX"
	static var description = IntentDescription("Start/Stop recording GPX tracks.")

	public init() {}

	func perform() async throws -> some IntentResult & ReturnsValue<Bool> {
		print("Perform()")
		let enabled = await MainActor.run {
			let enabled = toggleGPS()
			return enabled
		}
		return .result(value: enabled)
	}
}
