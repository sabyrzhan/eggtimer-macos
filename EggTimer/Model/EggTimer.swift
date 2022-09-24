//
//  EggTimer.swift
//  EggTimer
//
//  Created by Sabyrzhan Tynybayev on 24.09.2022.
//

import Cocoa

protocol EggTimerProtocol {
    func timeRemainingOnTimer(_ timer: EggTimer, timeRemaining: TimeInterval)
    func timerHasFinihsed(_ timer: EggTimer)
}

class EggTimer: NSObject {
    
    var delegate: EggTimerProtocol?
    
    var timer: Timer?
    var startTime: Date?
    var duration: TimeInterval = 360 // default = 6 minutes
    var elapsedTime: TimeInterval = 0
    var isStopped: Bool {
        return timer == nil && elapsedTime == 0
    }
    
    var isPaused: Bool {
        return timer == nil && elapsedTime > 0
    }
    
    func timerAction() {
        guard let startTime = startTime else {
            return
        }
        
        elapsedTime = -startTime.timeIntervalSinceNow
        
        let secondsRemaining = (duration - elapsedTime).rounded()
        
        if secondsRemaining <= 0 {
            resetTimer()
            delegate?.timerHasFinihsed(self)
        } else {
            delegate?.timeRemainingOnTimer(self, timeRemaining: secondsRemaining)
        }
    }
    
    func startTimer() {
        startTime = Date()
        elapsedTime = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerAction()
        }
    }
    
    func resumeTimer() {
        startTime = Date(timeIntervalSinceNow: -elapsedTime)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerAction()
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerAction()
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        
        startTime = nil
        duration = 360
        elapsedTime = 0
        
        timerAction()
    }
}
