//
//  GpxWidgetLiveActivity.swift
//  GpxWidget
//
//  Created by Bryce Cogswell on 5/5/24.
//  Copyright © 2024 Bryce Cogswell. All rights reserved.
//

import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

func toggleGPS() -> Bool {
	// This is a dummy function that doesn't get called inside the widget. The app has its own implementation.
	return true
}

struct GpxWidgetLiveActivity: Widget {
	@State var showButton = true
	var body: some WidgetConfiguration {
		ActivityConfiguration(for: GpxTrackAttributes.self) { context in
			// Lock screen/banner UI goes here
			HStack {
				Spacer()
				VStack(alignment: .leading) {
					Text(context.state.startTime.formatted(date: .numeric, time: .shortened))
					Text("Duration: \(context.state.durationHMS)")
						.contentTransition(.numericText())
					Text("\(context.state.pointCount) points")
						.contentTransition(.numericText())
				}
				.foregroundStyle(.white)
				Spacer()
				Image("AppIcon")
					.cornerRadius(8)

				if showButton {
					Spacer()
					Button(intent: EnableGpxTrackIntent()) {
						Text(context.state.endTime == nil ? "Stop" : "Start")
					}
					.background(context.state.endTime == nil ? Color.blue : Color.green)
					.foregroundStyle(.white)
					.clipShape(Capsule())
					.simultaneousGesture(
						DragGesture(minimumDistance: 0)
							.onChanged({ _ in
								showButton = false
							})
							.onEnded({ _ in
								showButton = false
							}))
				}
				/*
				 Spacer()
				 if showButton {
				 Button(intent: EnableGpxTrackIntent()) {
				 Text(context.state.endTime == nil ? "Stop" : "Start")
				 }
				 .simultaneousGesture(
				 DragGesture(minimumDistance: 0)
				 .onChanged({ _ in
				 })
				 .onEnded({ _ in
				 showButton = false
				 })
				 )
				 }
				 */
			}
			.activityBackgroundTint(Color.green)
			.activitySystemActionForegroundColor(Color.black)
		} dynamicIsland: { context in
			DynamicIsland {
				// Expanded UI goes here.  Compose the expanded UI through
				// various regions, like leading/trailing/center/bottom
				DynamicIslandExpandedRegion(.leading) {
					Text("\(context.state.pointCount) GPX points")
				}
				DynamicIslandExpandedRegion(.trailing) {
					Text("\(context.state.durationHMS)")
				}
				DynamicIslandExpandedRegion(.center) {
					Image("AppIcon")
				}
			} compactLeading: {
				Image("AppIcon")
					.resizable()
					.aspectRatio(contentMode: .fill)
			} compactTrailing: {
				Text("\(context.state.durationHMS)")
			} minimal: {
				Image("AppIcon")
					.resizable()
					.aspectRatio(contentMode: .fill)
			}
			// .widgetURL(URL(string: "http://www.gomaposm.com"))
			// .keylineTint(Color.red)
		}
	}
}

private extension GpxTrackAttributes {
	static var preview: GpxTrackAttributes {
		GpxTrackAttributes()
	}
}

private extension GpxTrackAttributes.ContentState {
	static var smiley: GpxTrackAttributes.ContentState {
		GpxTrackAttributes.ContentState(startTime: Date())
	}
}

#Preview("Notification", as: .content, using: GpxTrackAttributes.preview) {
	GpxWidgetLiveActivity()
} contentStates: {
	GpxTrackAttributes.ContentState.smiley
}
