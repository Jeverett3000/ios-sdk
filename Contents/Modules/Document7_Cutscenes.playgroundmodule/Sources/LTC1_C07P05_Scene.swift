//
//  LTC1_C07P05_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P05_Scene)
class LTC1_C07P05_Scene: SceneViewController {

    @IBOutlet weak var school: UIImageView!
    @IBOutlet weak var whiteCar: UIImageView!

    @IBOutlet weak var whileExprLabel: UILabel!
    @IBOutlet weak var forwardCommandLabel: UILabel!
    @IBOutlet weak var closingBraceLabel: UILabel!
    @IBOutlet weak var whileExprTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var codeBubble: UIView!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutTextBubble: UIView!
    @IBOutlet weak var calloutPointer: UIView!

    @IBOutlet weak var orangeCar: UIImageView!
    @IBOutlet weak var orangeCarBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var noteTextLabel: UILabel!
    @IBOutlet weak var noteBubble: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        // Capture the position of the code from the storyboard.
        codeVerticalPosition = whileExprTopConstraint.constant

        codeElements = [ whileExprLabel,
                         forwardCommandLabel,
                         closingBraceLabel ]

        // The code is positioned lower and invisible at the start of the scene.
        whileExprTopConstraint.constant += 200.0
        for e in codeElements {
            e.alpha = 0.0
        }

        calloutTextLabel.text = NSLocalizedString("To start, write an algorithm that moves the car forward until it reaches the parking space.", comment: "callout text; explains a block of code")
        calloutPointer.rotate(degrees: 45)
        calloutElements = [ codeBubble,
                            calloutTextLabel,
                            calloutTextBubble,
                            calloutPointer ]

        // The callout is not visible at the start of the scene.
        for e in calloutElements {
            e.alpha = 0.0
        }

        noteTextLabel.text = NSLocalizedString("Oops. The algorithm doesn’t tell the car to turn at the end of the building.", comment: "callout text; explains why the algorithm didn't work as expected")
        noteElements = [ noteTextLabel,
                         noteBubble ]

        // The note is not visible at the start of the scene.
        for e in noteElements {
            e.alpha = 0.0
        }

        whiteCar.rotate(degrees: 180)

        school.makeAccessible(label: NSLocalizedString("Overhead view of a building with a road going around it", comment: "accessibility label"))

        view.accessibilityElements = [ calloutTextLabel!,
                                       whileExprLabel!,
                                       forwardCommandLabel!,
                                       closingBraceLabel!,
                                       noteTextLabel!,
                                       school! ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade in the code block.
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [],
                       animations: {
                        for e in self.codeElements {
                            e.alpha = 1.0
                        }
        })

        // Bring the code into position, with bounce.
        animateChange(to: whileExprTopConstraint, value: codeVerticalPosition, duration: 0.6, delay: 0.0)

        // Fade in the callout block.
        UIView.animate(withDuration: 0.6, delay: 1.0, options: [],
                       animations: {
                        for e in self.calloutElements {
                            e.alpha = 1.0
                        }
        })

        // Animate the orange car through the scene.
        if let parentView = orangeCar.superview {
            UIView.animate(withDuration: 3.0, delay: 3.0, options: [.curveLinear],
                           animations: {
                            // Attach the orange car to the top of the scene, instead of the bottom.
                            // Animate the change in position.
                            parentView.removeConstraint(self.orangeCarBottomConstraint)
                            self.orangeCar.bottomAnchor.constraint(equalTo: parentView.topAnchor, constant: -100.0).isActive = true
                            parentView.layoutIfNeeded()
            })
        }

        // Fade in the note bubble.
        UIView.animate(withDuration: 0.6, delay: 6.0, options: [],
                       animations: {
                        for e in self.noteElements {
                            e.alpha = 1.0
                        }
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged, argument: self.calloutTextLabel)
                        self.animationsDidComplete()
        })
    }
    
    // MARK:- Private

    private var codeVerticalPosition: CGFloat = 0.0

    private var codeElements: [UIView] = []
    private var calloutElements: [UIView] = []
    private var noteElements: [UIView] = []

}
