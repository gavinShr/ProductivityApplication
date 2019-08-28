//
//  HapticGenerator.swift
//  ProductivityApplication
//
//  Created by Gavin Shrader on 8/27/19.
//  Copyright © 2019 Gavin Shrader. All rights reserved.
//

import UIKit

class HapticGenerator {

    @available(iOS 10.0, *) static let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
    @available(iOS 10.0, *) static let errorGenerator = UINotificationFeedbackGenerator()
    
    @available(iOS 10.0, *)
    static func applyHaptics() {
        HapticGenerator.hapticGenerator.impactOccurred()
        HapticGenerator.hapticGenerator.prepare()
    }

    @available(iOS 10.0, *)
    static func applyHapticsFancy(_ style: UINotificationFeedbackGenerator.FeedbackType) {
        HapticGenerator.errorGenerator.notificationOccurred(style)
        HapticGenerator.errorGenerator.prepare()
    }
    
}
