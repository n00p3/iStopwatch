//
//  AppDelegate.swift
//  iStopwatch
//
//  Created by Mateusz Głowski on 03/06/2020.
//  Copyright © 2020 Mateusz Głowski. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem!
    var time = 0.0
    var isRunning = false
    var timer: Timer?
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        statusItem.button?.image = NSImage(named: NSImage.Name("baseline_timer_black_18dp"))
        statusItem.button?.imagePosition = .imageLeft
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        statusItem.button?.action = #selector(itemClicked(_:))
        statusItem.button?.title = ""
        statusItem.button?.imagePosition = .imageOverlaps
    
        self.statusItem = statusItem
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func itemClicked(_ sender: Any?) {
        if NSApp.currentEvent!.type == .rightMouseUp {
            print("right")
            self.statusItem.button?.title = ""
            statusItem.button?.imagePosition = .imageOverlaps
            timer?.invalidate()
            self.time = 0.0
            self.isRunning = false
            return
        } else if NSApp.currentEvent!.type == .leftMouseUp {
            print("left")
        } else {
            print("Unknown key clicked.")
        }
        
        isRunning = !isRunning

        statusItem.button?.title = secondsToHoursMinutesSeconds(seconds: time)
        
        timer?.invalidate()
        self.statusItem.button?.imagePosition = .imageLeft
        time = 0.0
        if isRunning {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (timer) in
                self.time += timer.timeInterval
                self.statusItem.button?.title = self.secondsToHoursMinutesSeconds(seconds: self.time)
                
            }
        }
    }
    
    func secondsToHoursMinutesSeconds(seconds : Double) -> String {
        let (hr,  minf) = modf (seconds / 3600)
        let (min, secf) = modf (60 * minf)
        return "\(String(format: "%02.0f", hr)):\(String(format: "%02.0f", min)):\(String(format: "%04.1f", 60 * secf))"
    }
}

