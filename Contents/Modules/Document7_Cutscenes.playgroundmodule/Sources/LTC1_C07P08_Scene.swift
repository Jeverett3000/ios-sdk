//
//  LTC1_C07P08_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P08_Scene)
class LTC1_C07P08_Scene: SceneViewController {

    @IBOutlet weak var orangeCar: UIImageView!
    @IBOutlet weak var orangeCarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var orangeCarBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var carShadow: UIImageView!
    @IBOutlet weak var sensorWaves: UIView!

    @IBOutlet weak var prevWhileExprLabel: UILabel!
    @IBOutlet weak var prevIfExprLabel: UILabel!
    @IBOutlet weak var prevIfOpeningBraceLabel: UILabel!
    @IBOutlet weak var prevIfBlockLabel: UILabel!
    @IBOutlet weak var prevTurnCommandLabel: UILabel!
    @IBOutlet weak var prevTurnCommandBubble: UIView!
    @IBOutlet weak var prevClosingBraceLabel: UILabel!
    @IBOutlet weak var prevClosingBraceTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var prevCalloutTextLabel: UILabel!
    @IBOutlet weak var prevCalloutBubble: UIView!
    @IBOutlet weak var prevCalloutPointer: UIView!

    @IBOutlet weak var prevNoteTextLabel: UILabel!
    @IBOutlet weak var prevNoteBubble: UIView!

    @IBOutlet weak var beginIfExprLabel: UILabel!
    @IBOutlet weak var endIfExprLabel: UILabel!
    @IBOutlet weak var driveCommandLabel: UILabel!
    @IBOutlet weak var driveCodeBubble: UIView!

    @IBOutlet weak var driveCalloutTextLabel: UILabel!
    @IBOutlet weak var driveCalloutBubble: UIView!
    @IBOutlet weak var driveCalloutPointer: UIView!

    @IBOutlet weak var whiteCar: UIImageView!
    @IBOutlet weak var school: UIImageView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        // Continue from the state of the previous scene.
        shouldFadeIn = false

        // Setup the callout.
        prevCalloutTextLabel.text = NSLocalizedString("If the car is not blocked on the right, it has reached the end of the building and should turn right.", comment: "callout text; explains a change to the algorithm")
        prevCalloutPointer.rotate(degrees: 45)

        // Setup the note.
        prevNoteTextLabel.text = NSLocalizedString("Oops. We still need to tweak the algorithm.", comment: "callout text; explains that more changes are needed")

        // Setup the car (and its shadow).
        orangeCar.rotate(degrees: 90)
        carShadow.rotate(degrees: 90)
        sensorWaves.rotate(degrees: 90)

        prevElements = [ prevWhileExprLabel,
                         prevIfExprLabel,
                         prevIfOpeningBraceLabel,
                         prevIfBlockLabel,
                         prevTurnCommandLabel,
                         prevTurnCommandBubble,
                         prevClosingBraceLabel,
                         prevCalloutTextLabel,
                         prevCalloutBubble,
                         prevCalloutPointer,
                         prevNoteTextLabel,
                         prevNoteBubble ]

        codeElements = [ beginIfExprLabel,
                         driveCommandLabel,
                         endIfExprLabel ]

        // Hide the new code elements until they fade in.
        for e in codeElements {
            e.alpha = 0.0
        }

        // Setup the new callout.
        driveCalloutTextLabel.text = NSLocalizedString("After turning right, the car should drive forward to go around the building.", comment: "callout text; explaining the change to the algorigthm")
        driveCalloutPointer.rotate(degrees: 45)

        calloutElements = [ driveCalloutTextLabel,
                            driveCalloutBubble,
                            driveCalloutPointer,
                            driveCodeBubble ]

        // The callout elements are invisible at the start of the scene.
        for e in calloutElements {
            e.alpha = 0.0
        }

        // The sensor waves emitted from the orange car are not visible at the start of the scene.
        sensorWaves.alpha = 0.0

        // The white car (parked) in this scene needs to point down.
        whiteCar.rotate(degrees: 180)

        school.makeAccessible(label: NSLocalizedString("Car drives forward around the building, stops in parking space.", comment: "accessibility label"))

        view.accessibilityElements = [ driveCalloutTextLabel!,
                                       prevWhileExprLabel!,
                                       beginIfExprLabel!,
                                       driveCommandLabel!,
                                       endIfExprLabel!,
                                       prevClosingBraceLabel!,
                                       school! ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out previously shown callout, note, and code sample.
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [],
                       animations: {
                        for e in self.prevElements {
                            e.alpha = 0.0
                        }
        },
                       completion: { _ in
                        // We're re-using some previous elements,
                        // so we need to execute the rest of these animations in a completion block.

                        let reusedElements: [UIView] = [ self.prevWhileExprLabel, self.prevClosingBraceLabel ]
                        self.codeElements.append(contentsOf: reusedElements)

                        // Reposition the closing brace for the while block.
                        self.view.removeConstraint(self.prevClosingBraceTopConstraint)
                        self.prevClosingBraceLabel.topAnchor.constraint(equalTo: self.endIfExprLabel.bottomAnchor).isActive = true
                        self.view.layoutIfNeeded()

                        // Fade in the modified code.
                        UIView.animate(withDuration: 0.4, delay: 0.2, options: [],
                                       animations: {
                                        for e in self.codeElements {
                                            e.alpha = 1.0
                                        }
                        })

                        // Fade in the callout on the drive command.
                        UIView.animate(withDuration: 0.4, delay: 0.8, options: [],
                                       animations: {
                                        for e in self.calloutElements {
                                            e.alpha = 1.0
                                        }
                        },
                                       completion: { _ in
                                        UIAccessibility.post(notification: .screenChanged, argument: self.driveCalloutTextLabel)
                        })

                        // Move the car using the new algorithm.
                        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)
                        UIView.animateKeyframes(withDuration: 4.0, delay: 2.2, options: [curveLinear],
                                                animations: {
                                                    // Move the car to the next corner
                                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.4) {
                                                        self.orangeCarLeadingConstraint.constant += 264.0
                                                        self.view.layoutIfNeeded()
                                                    }
                                                    // Pulse the sensor waves from the orange car.
                                                    UIView.addKeyframe(withRelativeStartTime: 0.05, relativeDuration: 0.1) {
                                                        self.sensorWaves.alpha = 1.0
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.1) {
                                                        self.sensorWaves.alpha = 0.0
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.1) {
                                                        self.sensorWaves.alpha = 1.0
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.1) {
                                                        self.sensorWaves.alpha = 0.0
                                                    }
                                                    // Turn the car.
                                                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.25) {
                                                        self.orangeCar.rotate(degrees: 90)
                                                        self.carShadow.rotate(degrees: 90)
                                                        self.sensorWaves.rotate(degrees: 90)
                                                        self.orangeCarLeadingConstraint.constant += 26.0
                                                        self.orangeCarBottomConstraint.constant -= 44.0
                                                        self.view.layoutIfNeeded()
                                                    }
                                                    // Move into the parking space.
                                                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                                                        self.orangeCarBottomConstraint.constant -= 140.0
                                                        self.view.layoutIfNeeded()
                                                    }
                                                    // Pulse the sensor waves from the orange car.
                                                    UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.1) {
                                                        self.sensorWaves.alpha = 1.0
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.65, relativeDuration: 0.1) {
                                                        self.sensorWaves.alpha = 0.0
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.1) {
                                                        self.sensorWaves.alpha = 1.0
                                                    }
                                                    UIView.addKeyframe(withRelativeStartTime: 0.85, relativeDuration: 0.1) {
                                                        self.sensorWaves.alpha = 0.0
                                                    }

                        },
                                                completion: { _ in
                                                    self.animationsDidComplete()
                        })
        })
    }

    // MARK:- Private

    private var prevElements: [UIView] = []
    private var codeElements: [UIView] = []
    private var calloutElements: [UIView] = []

}
