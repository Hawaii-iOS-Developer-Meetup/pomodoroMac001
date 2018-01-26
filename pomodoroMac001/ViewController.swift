//
//  ViewController.swift
//  pomodoroMac001
//
//  Created by David on 1/24/18.
//  Copyright © 2018 Vision Runner. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var countDown: NSTextField!
    
    var imageView: NSImageView = NSImageView()
    var blackTomato: NSImage = NSImage()
    var redTomato: NSImage = NSImage()
    var greenTomato: NSImage = NSImage()
    
    var startedWorkingSound: NSSound = NSSound()
    var finishedWorkingSound: NSSound = NSSound()
    var stoppedWorkingSound: NSSound = NSSound()

    var currentCountDown: Int = 0
    var WORKING_MINUTES = 2
    var RESTING_MINUTES = 1
    var computedTotalWorkingSeconds = 0
    var computedTotalRestingSeconds = 0
    var isStarted: Bool = false
    var isWorking: Bool = true
    var timer: Timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        isStarted = false
        initImages()
        initImageView()
        initSounds()
        initWindowTitle()
        initCountDown()
    }
    
    func initCountDown() {
        countDown.stringValue = "press start"
        let timeFactor = 10
        computedTotalWorkingSeconds = WORKING_MINUTES * timeFactor
        computedTotalRestingSeconds = RESTING_MINUTES * timeFactor
    }
    
    override func viewWillAppear() {
        initWindowTitle()
    }
    
    func initWindowTitle() {
        self.view.window?.title = "dave's pomodoro - v.0.1"
    }
    
    func initSounds() {
        startedWorkingSound = (NSSound(named: NSSound.Name(rawValue: "Pop")))!
        finishedWorkingSound = (NSSound(named: NSSound.Name(rawValue: "Purr")))!
        stoppedWorkingSound = (NSSound(named: NSSound.Name(rawValue: "Morse")))!
    }
    
    func initImages() {
        blackTomato = NSImage(named:NSImage.Name(rawValue: "blackTomato"))!
        redTomato = NSImage(named:NSImage.Name(rawValue: "redTomato"))!
        greenTomato = NSImage(named:NSImage.Name(rawValue: "greenTomato"))!
    }
    
    func initImageView() {
        
        let width = 100
        imageView = NSImageView(frame:NSRect(x: (self.view.frame.width)/2 - CGFloat.init(width/2), y: (self.view.frame.height)/2 + CGFloat.init(width/4), width: CGFloat.init(width), height: CGFloat.init(width)))
        imageView.image = blackTomato
        self.view.addSubview(imageView)
    }
    
    func startTimer(withTimer inputTimer: inout Timer, withSeconds inputSeconds: Int) {
        currentCountDown = inputSeconds
        inputTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func stopTimer(withTimer inputTimer: Timer) {
        inputTimer.invalidate()
        countDown.stringValue = "press start"
    }

    @IBAction func buttonPressed(_ sender: Any) {
        if isStarted {
            timer.invalidate()
            countDown.stringValue = "stopping..."
            button.title = "Start"
            isStarted = false
            stopTimer(withTimer: timer)
            changeTomatoImageTo(withTomato: "blackTomato", withImageView: imageView)
            timer.invalidate()
            stoppedWorkingSound.play()
        } else {
            timer.invalidate()
            countDown.stringValue = "starting..."
            button.title = "Stop"
            isStarted = true
            startTimer(withTimer: &timer, withSeconds: computedTotalWorkingSeconds)
            changeTomatoImageTo(withTomato: "redTomato", withImageView: imageView)
            startedWorkingSound.play()
        }
    }
    
    func changeTomatoImageTo(withTomato inputTomato: String, withImageView inputImageView: NSImageView) {
        switch inputTomato {
        case "redTomato":
            inputImageView.image = redTomato
            break
        case "greenTomato":
            inputImageView.image = greenTomato
            break
        case "blackTomato":
            inputImageView.image = blackTomato
            break
        default:
            inputImageView.image = blackTomato
            break
        }
    }
    
    // method called every second when timer has been activated
    @objc func update() {
        if currentCountDown >= 1 {
            currentCountDown = currentCountDown - 1
            let hoursMinutesSeconds: (Int,Int,Int) = secondsToHoursMinutesSeconds(seconds: currentCountDown)
            let hours = String(format: "%02d", hoursMinutesSeconds.0)
            let minutes = String(format: "%02d", hoursMinutesSeconds.1)
            let seconds = String(format: "%02d", hoursMinutesSeconds.2)
            countDown.stringValue = "\(hours):\(minutes):\(seconds)"
        } else {
            finishedWorkingSound.play()
            if isWorking {
                isWorking = false
                countDown.stringValue = "resting..."
                timer.invalidate()
                startTimer(withTimer: &timer, withSeconds: computedTotalRestingSeconds)
                imageView.image = greenTomato
            } else {
                isWorking = true
                countDown.stringValue = "working..."
                timer.invalidate()
                startTimer(withTimer: &timer, withSeconds: computedTotalWorkingSeconds)
                imageView.image = redTomato
            }
        }
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}

