//
//  Countdown.swift
//  Countdown
//
//  Created by Joseph Rogers on 10/17/19.
//  Copyright © 2019 Moka Apps. All rights reserved.
//

import Foundation


protocol CountdownDelegate: AnyObject {
    func countdownDidUpdate(timeRemaining: TimeInterval)
    func countdownDidFinish()
}

// Enum to track state of countdown
enum CountdownState{
    case started // countdown is active and counting down
    case finished // countdown has reached 0 and is not active
    case reset // countdown is at initial time value and not active
}

struct CountdownCodableValues: Codable, Equatable {
    var name: String?
    var countdownExistingNotes: String?
}

class Countdown {
    
    var name: String?
    var countdownExistingNotes: String?
    
  
    // used to inform delegate of countdown's current state
    // and when countdown has finished
    weak var delegate: CountdownDelegate?
    
    // number of seconds; countdown's starting value
    var duration: TimeInterval = 0.0
    
    // derived number of seconds remaining when the countdown is active
    var timeRemaining: TimeInterval {
        if let stopDate = stopDate {
            let timeRemaining = stopDate.timeIntervalSinceNow
            return timeRemaining
        } else {
            return 0
        }
    }
    
    var countdownStruct: CountdownCodableValues {
        let CodableValue = CountdownCodableValues(name: name, countdownExistingNotes: countdownExistingNotes)
        return CodableValue
      }
    
    // has value only when countdown is active
    // waits a specific period and fires a method on an recurring interval
    private var timer: Timer?
    
    // has value only when countdown is active
    // future date; determines when timer should stop
    private var stopDate: Date?
    
    // current state of countdown
    private(set) var state: CountdownState
    
    init(name: String?, countdownExistingNotes: String?) {
        self.timer = nil
        self.stopDate = nil
        self.duration = 0
        self.state = .reset
        self.name = name
        self.countdownExistingNotes = countdownExistingNotes
    }
    
    func start() {
        // Cancel timer before starting new timer
        cancelTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: updateTimer(timer:))
        stopDate = Date(timeIntervalSinceNow: duration)
        state = .started
    }
    
    func reset() {
        stopDate = nil
        cancelTimer()
        state = .reset
    }
    
    func cancelTimer() {
        // We must invalidate a timer, or it will continue to run even if we
        // start a new timer
        timer?.invalidate()
        timer = nil
    }
    
    // called each time the timer object fires
    private func updateTimer(timer: Timer) {
        
        if let stopDate = stopDate {
            let currentTime = Date()
            if currentTime <= stopDate {
                // Timer is active, keep counting down
                delegate?.countdownDidUpdate(timeRemaining: timeRemaining)
            } else {
                // Timer is finished, reset and stop counting down
                state = .finished
                cancelTimer()
                self.stopDate = nil
                delegate?.countdownDidFinish()
            }
        }
    }
}
