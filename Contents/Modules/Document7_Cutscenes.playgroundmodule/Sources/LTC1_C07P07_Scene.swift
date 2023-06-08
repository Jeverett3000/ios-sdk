//
//  LTC1_C07P07_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P07_Scene)
class LTC1_C07P07_Scene: SceneViewController {

    @IBOutlet weak var school: UIImageView!
    @IBOutlet weak var whiteCar: UIImageView!
    @IBOutlet weak var orangeCar: UIImageView!
    @IBOutlet weak var carShadow: UIImageView!
    @IBOutlet weak var sensorWaves: UIImageView!

    @IBOutlet weak var orangeCarBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var whileExprLabel: UILabel!
    @IBOutlet weak var ifExprLabel: UILabel!
    @IBOutlet weak var ifOpeningBraceLabel: UILabel!
    @IBOutlet weak var ifBlockLabel: UILabel!
    @IBOutlet weak var turnCommandLabel: UILabel!
    @IBOutlet weak var whileClosingBraceLabel: UILabel!

    @IBOutlet weak var ifExprBubble: UIView!
    @IBOutlet weak var ifExprCalloutTextLabel: UILabel!
    @IBOutlet weak var ifExprCalloutBubble: UIView!
    @IBOutlet weak var ifExprCalloutPointer: UIView!

    @IBOutlet weak var turnBubble: UIView!
    @IBOutlet weak var turnCalloutTextLabel: UILabel!
    @IBOutlet weak var turnCalloutBubble: UIView!
    @IBOutlet weak var turnCalloutPointer: UIView!

    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteBubble: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        ifExprCalloutTextLabel.text = NSLocalizedString("To move the car around the building, create a rule to repeatedly check whether it is blocked on the right.", comment: "callout text; explains a change to the algorithm")
        ifExprCalloutPointer.rotate(degrees: 45)

        prevCalloutElements = [ ifExprBubble,
                                ifExprCalloutTextLabel,
                                ifExprCalloutBubble,
                                ifExprCalloutPointer ]

        turnCalloutTextLabel.text = NSLocalizedString("If the car is not blocked on the right, it has reached the end of the building and should turn right.", comment: "callout text; explains a change to the algorithm")
        turnCalloutPointer.rotate(degrees: 45)

        calloutElements = [ turnCalloutTextLabel,
                            turnCalloutBubble,
                            turnCalloutPointer,
                            turnBubble ]

        // The turn callout is not visible at the start of the scene.
        for e in calloutElements {
            e.alpha = 0.0
        }

        noteTextLabel.text = NSLocalizedString("Oops. We still need to tweak the algorithm.", comment: "callout text; explains that more changes are needed")

        noteElements = [ noteTextLabel,
                         noteBubble ]

        // The note is not visible at the start of the scene.
        for e in noteElements {
            e.alpha = 0.0
        }

        // The sensor waves emitted from the orange car are not visible at the start of the scene.
        sensorWaves.alpha = 0.0

        // The white car in the scene should point down.
        whiteCar.rotate(degrees: 180)

        school.makeAccessible(label: NSLocalizedString("Car drives to the corner and spins to the right several times, but does not drive around the building.", comment: "accessibility label"))

        view.accessibilityElements = [ turnCalloutTextLabel!,
                                       whileExprLabel!,
                                       ifExprLabel!,
                                       ifOpeningBraceLabel!,
                                       ifBlockLabel!,
                                       whileClosingBraceLabel!,
                                       school!,
                                       noteTextLabel! ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out the exising callout elements.
        UIView.animate(withDuration: 0.4) {
            for p in self.prevCalloutElements {
                p.alpha = 0.0
            }
        }

        // Fade in the new callout.
        UIView.animate(withDuration: 0.4, delay: 0.5, options: [],
                       animations: {
                        for c in self.calloutElements {
                            c.alpha = 1.0
                        }
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged, argument: self.turnCalloutTextLabel)
        })

        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)
        UIView.animateKeyframes(withDuration: 2.3, delay: 1.5, options: [curveLinear],
                                animations: {
                                    // Move the orange car to the corner.
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                                        self.orangeCarBottomConstraint.constant = 218.0
                                        self.view.layoutIfNeeded()
                                    }
                                    // Pulse the sensor waves from the orange car.
                                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.2) {
                                        self.sensorWaves.alpha = 1.0
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.2) {
                                        self.sensorWaves.alpha = 0.0
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.2) {
                                        self.sensorWaves.alpha = 1.0
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.2) {
                                        self.sensorWaves.alpha = 0.0
                                    }
        })

        // Rotate the orange car (and its shadow).
        UIView.animateKeyframes(withDuration: 2.5, delay: 4.2, options: [curveLinear],
                                animations: {
                                    let pause: Double = 0.1333
                                    let spin: Double = 0.0667
                                    for i in 0...4 {
                                        UIView.addKeyframe(withRelativeStartTime: pause + (Double(i) * (pause + spin)),
                                                           relativeDuration: spin) {
                                            self.orangeCar.rotate(degrees: 90)
                                            self.carShadow.rotate(degrees: 90)
                                        }
                                    }
        })

        // Fade in the new note.
        UIView.animate(withDuration: 0.4, delay: 6.5, options: [],
                       animations: {
                        for n in self.noteElements {
                            n.alpha = 1.0
                        }
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })
    }

    // MARK:- Private

    private var prevCalloutElements: [UIView] = []
    private var calloutElements: [UIView] = []
    private var noteElements: [UIView] = []

}
