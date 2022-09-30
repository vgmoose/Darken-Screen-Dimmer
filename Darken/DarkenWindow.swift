import AppKit
import SwiftUI

class DarkenWindow : NSWindow
{
	static var defaultFullScreenHeight = 800*2
	static var defaultFullScreenWidth = 1280*2

	static var fullScreenHeight = defaultFullScreenHeight
	static var fullScreenWidth = defaultFullScreenWidth
	
	static var singleton: DarkenWindow? = nil
	
	static var allowMoving = false
	static var showOnAllSpaces = true
	static var showInDock = false
	
    static var darkness = 0.3
	
	override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool)
	{
		super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)

		let window = self
		DarkenWindow.singleton = window

		window.showsToolbarButton = false
		window.isOpaque = false
		window.hasShadow = false

		window.backgroundColor = NSColor.clear
		
		window.titleVisibility = .hidden
		window.level = .screenSaver
		window.styleMask = .borderless
					
		window.standardWindowButton(.zoomButton)?.isHidden = true
		window.standardWindowButton(.miniaturizeButton)?.isHidden = true
		window.standardWindowButton(.closeButton)?.isHidden = true
			
        refreshDimensions()
	}
	
	func refreshDimensions() {
		
		// update how it can be interacted with
		self.ignoresMouseEvents = !DarkenWindow.allowMoving
		self.isMovableByWindowBackground = DarkenWindow.allowMoving
		self.collectionBehavior = DarkenWindow.allowMoving ? .managed : .stationary

		if DarkenWindow.showOnAllSpaces {
			self.collectionBehavior = [ self.collectionBehavior, .canJoinAllSpaces ]
		}
		
		// default 13-inch resolution (is used if some display change events being nil)
		var screenWidth = 1440*2
		var screenHeight = 900*2
		
		// update the size to the latest scaling info from the config
		DarkenWindow.fullScreenHeight = DarkenWindow.defaultFullScreenHeight
		DarkenWindow.fullScreenWidth = DarkenWindow.defaultFullScreenWidth
                                           
		let fullScreenWidth = DarkenWindow.fullScreenWidth
		let menuOffset = 10
		
		NSApp.setActivationPolicy(DarkenWindow.showInDock ? .regular : .accessory)
    
		// get window's screen dimensions, or default if they aren't available for some reason
		// TODO: default to main display?
		let frame = self.screen?.frame ?? NSRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

        // get the current window's screen and its width and heights
		screenWidth = Int(frame.width)
		screenHeight = Int(frame.height)
		
		// update default notch sizes based on display, so other screen sizes don't get anything unexpected
		DarkenWindow.defaultFullScreenWidth = screenWidth
		DarkenWindow.defaultFullScreenHeight = screenHeight

		self.contentView = NSHostingView(rootView: DarkenView())
		
		if !DarkenWindow.allowMoving {
			let pos = NSPoint(x: 0, y: screenHeight)
			self.setFrameTopLeftPoint(pos)
		}
	}
}
