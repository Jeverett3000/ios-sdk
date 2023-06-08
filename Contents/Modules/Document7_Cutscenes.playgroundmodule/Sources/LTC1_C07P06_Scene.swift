//
//  LTC1_C07P06_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P06_Scene)
class LTC1_C07P06_Scene: SceneViewController {


    @IBOutlet weak var school: UIImageView!
    @IBOutlet weak var whiteCar: UIImageView!

    @IBOutlet weak var prevWhileExprLabel: UILabel!
    @IBOutlet weak var prevCommandLabel: UILabel!
    @IBOutlet weak var prevClosingBraceLabel: UILabel!

    @IBOutlet weak var prevCodeBubble: UIView!

    @IBOutlet weak var prevCalloutTextLabel: UILabel!
    @IBOutlet weak var prevCalloutTextBubble: UIView!
    @IBOutlet weak var prevCalloutPointer: UIView!

    @IBOutlet weak var prevNoteTextLabel: UILabel!
    @IBOutlet weak var prevNoteBubble: UIView!

    @IBOutlet weak var whileExprLabel: UILabel!
    @IBOutlet weak var whileClosingBraceLabel: UILabel!

    @IBOutlet weak var ifExprLabel: UILabel!
    @IBOutlet weak var ifOpeningBraceLabel: UILabel!
    @IBOutlet weak var ifBlockLabel: UILabel!
    @IBOutlet weak var ifExprBubble: UIView!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutTextBubble: UIView!
    @IBOutlet weak var calloutPointer: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        prevCalloutTextLabel.text = NSLocalizedString("To start, write an algorithm that moves the car forward until it reaches the parking space.", comment: "callout text; explains a block of code")
        prevCalloutPointer.rotate(degrees: 45)

        prevNoteTextLabel.text = NSLocalizedString("Oops. The algorithm doesn’t tell the car to turn at the end of the building.", comment: "callout text; explains why the algorithm didn't work as expected")

        prevElements = [ prevWhileExprLabel,
                         prevCommandLabel,
                         prevClosingBraceLabel,
                         prevCodeBubble,
                         prevCalloutTextLabel,
                         prevCalloutTextBubble,
                         prevCalloutPointer,
                         prevNoteTextLabel,
                         prevNoteBubble ]

        codeElements = [ whileExprLabel,
                         ifExprLabel,
                         ifOpeningBraceLabel,
                         ifBlockLabel,
                         whileClosingBraceLabel ]

        // The code is invisible at the start of the scene.
        for e in codeElements {
            e.alpha = 0.0
        }

        // Setup a new callout.
        calloutTextLabel.text = NSLocalizedString("To move the car around the building, create a rule to repeatedly check whether it is blocked on the right.", comment: "callout text; explains a change to the algorithm")
        calloutPointer.rotate(degrees: 45)

        calloutElements = [ calloutTextLabel,
                            calloutTextBubble,
                            calloutPointer,
                            ifExprBubble ]

        // The new callout is not visible at the start of the scene.
        for e in calloutElements {
            e.alpha = 0.0
        }

        whiteCar.rotate(degrees: 180)

        school.makeAccessible(label: NSLocalizedString("Overhead view of a building with a road going around it", comment: "accessibility label"))

        view.accessibilityElements = [ calloutTextLabel!,
                                       whileExprLabel!,
                                       ifExprLabel!,
                                       ifOpeningBraceLabel!,
                                       ifBlockLabel!,
                                       whileClosingBraceLabel!,
                                       school! ]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade out the exising code block.
        UIView.animate(withDuration: 0.4) {
            for p in self.prevElements {
                p.alpha = 0.0
            }
        }

        // Fade in the better code block.
        UIView.animate(withDuration: 0.4, delay: 0.5, options: [],
                       animations: {
                        for e in self.codeElements {
                            e.alpha = 1.0
                        }
        })

        // Fade in the callout.
        UIView.animate(withDuration: 0.4, delay: 1.5, options: [],
                       animations: {
                        for c in self.calloutElements {
                            c.alpha = 1.0
                        }
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged, argument: self.calloutTextLabel)
                        self.animationsDidComplete()
        })
    }
    
    // MARK:- Private

    private var prevElements: [UIView] = []
    private var codeElements: [UIView] = []
    private var calloutElements: [UIView] = []
    
}
