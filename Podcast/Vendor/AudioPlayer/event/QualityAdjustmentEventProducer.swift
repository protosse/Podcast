//
//  QualityAdjustmentEventProducer.swift
//  AudioPlayer
//
//  Created by Kevin DELANNOY on 11/03/16.
//  Copyright © 2016 Kevin Delannoy. All rights reserved.
//

import Foundation

private extension Selector {
    /// The selector to call when the timer ticks.
    static let timerTicked = #selector(QualityAdjustmentEventProducer.timerTicked(_:))
}

/// A `QualityAdjustmentEventProducer` generates `QualityAdjustmentEvent`s when there should be a change of quality
/// based on some information about interruptions.
class QualityAdjustmentEventProducer: NSObject, EventProducer {
    /// `QualityAdjustmentEvent` is a list of event that can be generated by `QualityAdjustmentEventProducer`.
    ///
    /// - goDown: The quality should go down if possible.
    /// - goUp: The quality should go up if possible.
    enum QualityAdjustmentEvent: Event {
        case goDown
        case goUp
    }

    /// The timer used to adjust quality
    private var timer: Timer?

    /// The listener that will be alerted a new event occured.
    weak var eventListener: EventListener?

    /// A boolean value indicating whether we're currently producing events or not.
    private var listening = false

    /// Interruption counter. It will be used to determine whether the quality should change.
    var interruptionCount = 0 {
        didSet {
            checkInterruptionCount()
        }
    }

    /// Defines the delay within which the player wait for an interruption before upgrading the quality. Default value
    /// is 10 minutes.
    var adjustQualityTimeInternal = TimeInterval(10 * 60) {
        didSet {
            if let timer = timer, listening {
                //We don't want to reset state in here because we want to keep the interruption
                //count and we also have to change the timer fire date.
                let delta = adjustQualityTimeInternal - oldValue
                let newFireDate = timer.fireDate.addingTimeInterval(delta)
                let timeInterval = newFireDate.timeIntervalSinceNow

                timer.invalidate()

                if timeInterval < 1 {
                    //In this case, the timer should have been fired based on the last
                    //fire date and the new `adjustQualityTimeInternal`. So we fire now.
                    timerTicked(timer)
                } else {
                    //In this case, the timer fire date just needs to be adjusted.
                    self.timer = Timer.scheduledTimer(
                        timeInterval: timeInterval,
                        target: self,
                        selector: .timerTicked,
                        userInfo: nil,
                        repeats: false)
                }
            }
        }
    }

    /// Defines the maximum number of interruption to have within the `adjustQualityTimeInterval` delay before
    /// downgrading the quality. Default value is 5.
    var adjustQualityAfterInterruptionCount = 5 {
        didSet {
            checkInterruptionCount()
        }
    }

    /// Stops producing events on deinitialization.
    deinit {
        stopProducingEvents()
    }

    /// Starts listening to the player events.
    func startProducingEvents() {
        guard !listening else {
            return
        }

        //Reset state
        resetState()

        //Saving that we're currently listening
        listening = true
    }

    /// Stops listening to the player events.
    func stopProducingEvents() {
        guard listening else {
            return
        }

        timer?.invalidate()
        timer = nil

        //Saving that we're not listening anymore
        listening = false
    }

    /// Resets the state.
    private func resetState() {
        interruptionCount = 0

        timer?.invalidate()
        timer = Timer.scheduledTimer(
            timeInterval: adjustQualityTimeInternal,
            target: self,
            selector: .timerTicked,
            userInfo: nil,
            repeats: false)
    }

    /// Checks that the interruption count is lower than `adjustQualityAfterInterruptionCount`. If it isn't, the
    /// function generates an event and reset its state.
    private func checkInterruptionCount() {
        if interruptionCount >= adjustQualityAfterInterruptionCount && listening {
            //Now we need to stop the timer
            timer?.invalidate()

            //Calls the listener
            eventListener?.onEvent(QualityAdjustmentEvent.goDown, generetedBy: self)

            //Reset state
            resetState()
        }
    }

    /// The quality adjuster ticked.
    ///
    /// - Parameter _: The timer.
    @objc fileprivate func timerTicked(_: AnyObject) {
        if interruptionCount == 0 {
            eventListener?.onEvent(QualityAdjustmentEvent.goUp, generetedBy: self)
        }

        //Reset state
        resetState()
    }
}
