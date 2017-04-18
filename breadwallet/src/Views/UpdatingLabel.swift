//
//  UpdatingLabel.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-04-15.
//  Copyright © 2017 breadwallet LLC. All rights reserved.
//

import UIKit

class UpdatingLabel : UILabel {

    var formatter: NumberFormatter

    init(formatter: NumberFormatter) {
        self.formatter = formatter
        super.init(frame: .zero)
        text = self.formatter.string(from: 0 as NSNumber)
    }

    func setValue(_ endingValue: Double) {
        guard let currentText = text else { return }
        guard let startingValue = formatter.number(from: currentText)?.doubleValue else { return }
        self.startingValue = startingValue
        self.endingValue = endingValue

        timer?.invalidate()
        lastUpdate = CACurrentMediaTime()
        progress = 0.0

        startTimer()
    }

    private let duration = 0.6
    private var easingRate: Double = 3.0
    private var timer: CADisplayLink?
    private var startingValue: Double = 0.0
    private var endingValue: Double = 0.0
    private var progress: Double = 0.0
    private var lastUpdate: CFTimeInterval = 0.0

    private func startTimer() {
        timer = CADisplayLink(target: self, selector: #selector(UpdatingLabel.update))
        timer?.frameInterval = 2
        timer?.add(to: .main, forMode: .defaultRunLoopMode)
        timer?.add(to: .main, forMode: .UITrackingRunLoopMode)
    }

    @objc private func update() {
        let now = CACurrentMediaTime()
        progress = progress + (now - lastUpdate)
        lastUpdate = now
        if progress >= duration {
            timer?.invalidate()
            timer = nil
            setFormattedText(forValue: endingValue)
        } else {
            let percentProgress = progress/duration
            let easedVal = 1.0-pow((1.0-percentProgress), easingRate)
            setFormattedText(forValue: startingValue + (easedVal * (endingValue - startingValue)))
        }
    }

    private func setFormattedText(forValue: Double) {
        text = formatter.string(from: forValue as NSNumber)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}