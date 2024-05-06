//
//  GpxTrackWidgetManager.swift
//  Go Map!!
//
//  Created by Bryce Cogswell on 5/5/24.
//  Copyright © 2024 Bryce Cogswell. All rights reserved.
//

import ActivityKit

// We use a protocol to get around the need to declare a property for a class
// that isn't available in all iOS versions.
protocol WidgetManagerProtocol {
	func start(start: Date)
	func update(points: Int)
	func stop(end: Date, pointCount: Int)
}

func toggleGPS() -> Bool {
	var enabled: Bool = AppDelegate.shared.mapView.gpsState != .NONE
	enabled = !enabled
	AppDelegate.shared.mapView.mainViewController.setGpsState(enabled ? .LOCATION : .NONE)
	return enabled
}

@available(iOS 16.2, *)
final class GpxTrackWidgetManager: WidgetManagerProtocol {
	var activity: Activity<GpxTrackAttributes>?

	init() {
		activity = nil
	}

	func start(start: Date) {
		guard activity == nil else { return }
		print("new activity @ \(start)")

		// create a new activity
		let attributes = GpxTrackAttributes()
		let state = GpxTrackAttributes.GpxTrackStatus(startTime: start,
		                                              pointCount: 0)
		let s2 = ActivityContent<GpxTrackAttributes.GpxTrackStatus>(state: state,
		                                                            staleDate: nil,
		                                                            relevanceScore: start.timeIntervalSince1970)
		activity = try? Activity<GpxTrackAttributes>.request(attributes: attributes,
		                                                     content: s2,
		                                                     pushType: nil)
	}

	func update(points: Int) {
		guard let activity = activity else { return }
		let state = GpxTrackAttributes.ContentState(startTime: activity.content.state.startTime,
		                                            pointCount: points)
		print("update \(state)")
		Task {
			await activity.update(using: state)
		}
	}

	func stop(end: Date, pointCount: Int) {
		print("stop")
		guard let activity = activity else { return }
		Task {
			var state = activity.content.state
			state.endTime = end
			state.pointCount = pointCount
			await activity.end(using: state, dismissalPolicy: .default)
		}
		self.activity = nil
	}
}
