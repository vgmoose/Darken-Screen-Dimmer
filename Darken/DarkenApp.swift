import SwiftUI
import Cocoa

@NSApplicationMain
class DarkenApp: NSApplication, NSApplicationDelegate {

    var window: NSWindow?
    static var singleton: DarkenApp?
    
    var statusBar: NSStatusBar?
    var statusItem: NSStatusItem?

    override init() {
        super.init()
        delegate = self
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        window?.makeKeyAndOrderFront(sender)
        return true
    }
    
    func setupMenuBar()
    {
        statusBar = .system
        statusItem = statusBar!.statusItem(withLength: -1)
        statusItem!.button!.title = "🌙"

        let appMenu = NSMenu()
        let mainView = NSMenuItem(title: "Darken", action: nil, keyEquivalent: "")
        let configView = ConfigView().padding(20).frame(width: 150, height: 80)
        let viewWrapper = NSHostingView(rootView: configView)
        viewWrapper.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
        mainView.view = viewWrapper
        appMenu.addItem(mainView)
        
        // https://stackoverflow.com/a/46348417
        NSApp.setActivationPolicy(.accessory)
        
        let appName = ProcessInfo.processInfo.processName
        let quitTitle = "Quit " + appName
        let quitMenuItem = NSMenuItem.init(title:quitTitle,
          action:#selector(NSApplication.terminate),keyEquivalent:"q")
        appMenu.addItem(quitMenuItem);
        
        statusItem!.menu = appMenu;
    }
    
    
    func applicationDidFinishLaunching(_ notification: Notification) {

        DarkenWindow().makeKeyAndOrderFront(self)
        DarkenApp.singleton = self
        
        setupMenuBar()
        
        // react to resolution changes too
        // https://stackoverflow.com/a/52071507
        NotificationCenter.default.addObserver(
        forName: NSApplication.didChangeScreenParametersNotification,
           object: NSApplication.shared,
           queue: OperationQueue.main
        ) {
            notification -> Void in
            DarkenWindow.singleton?.refreshDimensions()
            print("screen parameters changed", DarkenWindow.singleton)
        }
    }
}
