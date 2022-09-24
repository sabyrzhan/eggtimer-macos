//
//  ViewController.swift
//  EggTimer
//
//  Created by Sabyrzhan Tynybayev on 21.09.2022.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {
    @IBOutlet weak var timeLeftField: NSTextField!
    @IBOutlet weak var eggImageView: NSImageView!

    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    var eggTimer = EggTimer()
    var selectedTime: TimeInterval = Preferences().selectedTime
    
    var soundPlayer: AVAudioPlayer?
    
    let notificationName = Notification.Name(rawValue: "PrefsChanged")
    var observerToken: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eggTimer.delegate = self
        setupPrefs()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func startButtonClicked(_ sender: Any) {
        if eggTimer.isPaused {
            eggTimer.resumeTimer()
        } else {
            resetSelectedTime()
            eggTimer.duration = selectedTime
            eggTimer.startTimer()
        }
        
        configureButtonsAndMenus()
        prepareSound()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        resetSelectedTime()
        eggTimer.stopTimer()
        configureButtonsAndMenus()
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        resetSelectedTime()
        eggTimer.resetTimer()
        updateDisplay(for: selectedTime)
        configureButtonsAndMenus()
    }
    
    
    @IBAction func startMenuItemSelected(_ sender: Any) {
        startButtonClicked(sender)
    }
    
    @IBAction func stopMenuItemSelected(_ sender: Any) {
        stopButtonClicked(sender)
    }
    
    @IBAction func resetMenuItemSelected(_ sender: Any) {
        resetButtonClicked(sender)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(observerToken!, name: notificationName, object: nil)
    }
}

extension ViewController: EggTimerProtocol {
    // MARK: - EggTimerProtocol
    
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval) {
        updateDisplay(for: timeRemaining)
    }
    
    func timerHasFinihsed(_ timer: EggTimer) {
        updateDisplay(for: 0)
        configureButtonsAndMenus()
        playSound()
    }
}

extension ViewController {
    func updateDisplay(for timerReminaing: TimeInterval) {
        timeLeftField.stringValue = textToDisplay(for: timerReminaing)
        eggImageView.image = imageToDisplay(for: timerReminaing)
    }
    
    private func textToDisplay(for timeRemaining: TimeInterval) -> String {
        if timeRemaining == 0 {
            return "Done!"
        }
        
        let minutesRemaining = floor(timeRemaining / 60)
        let secondsRemaining = timeRemaining - (minutesRemaining * 60)
        
        let secondsDisplay = String(format: "%02d", Int(secondsRemaining))
        let timeRemainingDisplay = "\(Int(minutesRemaining)):\(secondsDisplay)"
        
        return timeRemainingDisplay
    }
    
    private func imageToDisplay(for timeRemaining: TimeInterval) -> NSImage? {
        let percentageComplete = 100 - (timeRemaining / selectedTime * 100)
        
        if eggTimer.isStopped {
            let stoppedImageName = (timeRemaining == 0) ? "100" : "stopped"
            return NSImage(named: stoppedImageName)
        }
        
        let imageName: String
        switch percentageComplete {
        case 0 ..< 25:
            imageName = "0"
        case 25 ..< 50:
            imageName = "25"
        case 50 ..< 75:
            imageName = "50"
        case 75 ..< 100:
            imageName = "75"
        default:
            imageName = "100"
            
        }
        
        return NSImage(named: imageName)
    }
    
    func configureButtonsAndMenus() {
        let enableStart: Bool
        let enableStop: Bool
        let enableReset: Bool
        
        if eggTimer.isStopped {
            enableStart = true
            enableStop = false
            enableReset = false
        } else if eggTimer.isPaused {
            enableStart = true
            enableStop = false
            enableReset = true
        } else {
            enableStart = false
            enableStop = true
            enableReset = false
        }
        
        startButton.isEnabled = enableStart
        stopButton.isEnabled = enableStop
        resetButton.isEnabled = enableReset
        
        if let appDel = NSApplication.shared.delegate as? AppDelegate {
            appDel.enableMenus(start: enableStart, stop: enableStop, reset: enableReset)
        }
    }
}

extension ViewController {
    // MARK: - Prefernces
    
    func setupPrefs() {
        resetSelectedTime()
        updateDisplay(for: selectedTime)
        
        observerToken = NotificationCenter.default.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
            self.checkForResetAferPrefsChange()
        }
    }
    
    func resetSelectedTime() {
        self.selectedTime = Preferences().selectedTime
    }
    
    func updateFromPrefs() {
        self.selectedTime = Preferences().selectedTime
        self.eggTimer.duration = self.selectedTime
        self.resetButtonClicked(self)
    }
    
    func checkForResetAferPrefsChange() {
        if eggTimer.isStopped || eggTimer.isPaused {
            updateFromPrefs()
        } else {
            let alert = NSAlert()
            alert.messageText = "Reset timer with the new settings?"
            alert.informativeText = "This will stop your current timer!"
            alert.alertStyle = .warning
            
            alert.addButton(withTitle: "Reset")
            alert.addButton(withTitle: "Cance")
            
            let response = alert.runModal()
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                self.updateFromPrefs()
            }
        }
    }
}

extension ViewController {
    // MARK: - Sound player functions
    
    func prepareSound() {
        guard let audioFileURL = Bundle.main.url(forResource: "ding", withExtension: "mp3") else {
            return
        }
        
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: audioFileURL)
            soundPlayer?.prepareToPlay()
        } catch {
            print("Sound player not available: \(error)")
        }
    }
    
    func playSound() {
        soundPlayer?.play()
    }
}
