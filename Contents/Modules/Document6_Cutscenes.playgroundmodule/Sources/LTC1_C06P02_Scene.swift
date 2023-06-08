//
//  LTC1_C06P02_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C06P02_Scene)
class LTC1_C06P02_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var hammer: UIImageView!
    @IBOutlet weak var nailBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var boardBottomConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeOut = false

        hammer.rotate(degrees: -60.0)

        primaryTextLabel.text = NSLocalizedString("When you’re hammering a nail, you can’t just hit it a certain number of times and expect it to go all the way in.", comment: "primary text")

        secondaryTextLabel.attributedText = attributedTextForSecondaryText()

        // Capture the position of the text from the storyboard.
        primaryTextYPosition = primaryTextBottomConstraint.constant
        secondaryTextYPosition = secondaryTextTopConstraint.constant

        // Move the primary text above the visible area for the start of the scene.
        primaryTextBottomConstraint.constant = -20.0

        // Move and hide the secondary text for the start of the scene.
        secondaryTextTopConstraint.constant += 200.0
        secondaryTextLabel.alpha = 0.0

        hammer.makeAccessible(label: NSLocalizedString("Hammer hitting nail halfway into board", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate the primary text into view, with bounce.
        animateChange(to: primaryTextBottomConstraint, value: primaryTextYPosition, duration: 1.0, delay: 0.5)

        // Animate the secondary text into view, with bounce.
        animateChange(to: secondaryTextTopConstraint, value: secondaryTextYPosition, duration: 0.5, delay: 3.5)
        UIView.animate(withDuration: 0.3, delay: 3.5, options: [],
                       animations: {
                        self.secondaryTextLabel.alpha = 1.0
        })

        // Animate the hammer striking the nail.
        let animateFrames = UIView.keyframeAnimator(totalFrames: 54)
        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)
        UIView.animateKeyframes(withDuration: 1.8, delay: 1.5, options: [curveLinear, .calculationModeLinear],
                                animations: {
                                    animateFrames(0,15) {
                                        self.hammer.rotate(degrees: 55.0)
                                    }
                                    animateFrames(15,24) {
                                        self.hammer.rotate(degrees: -80.0)
                                    }
                                    animateFrames(19,21) {
                                        self.nailBottomConstraint.constant -= 15.0
                                        self.boardBottomConstraint.constant -= 5.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(21,23) {
                                        self.boardBottomConstraint.constant += 5.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(20,26) {
                                        self.hammer.rotate(degrees: 6.0)
                                    }
                                    animateFrames(26,35) {
                                        self.hammer.rotate(degrees: 74.0)
                                    }
                                    animateFrames(35,40) {
                                        self.hammer.rotate(degrees: -85.0)
                                    }
                                    animateFrames(39,41) {
                                        self.nailBottomConstraint.constant -= 18.0
                                        self.boardBottomConstraint.constant -= 5.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(41,43) {
                                        self.boardBottomConstraint.constant += 5.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(40,44) {
                                        self.hammer.rotate(degrees: 15.0)
                                    }
                                    animateFrames(44,54) {
                                        self.hammer.rotate(degrees: 15.0)
                                    }
        },
                                completion: { _ in
                                    self.animationsDidComplete()
        })
        
        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

    // MARK:- Private

    private var primaryTextYPosition: CGFloat = 0.0
    private var secondaryTextYPosition: CGFloat = 0.0

    private func attributedTextForSecondaryText() -> NSAttributedString {

        let text = NSLocalizedString("Instead, you continue hitting the nail <b>while</b> the nail is sticking out.", comment: "secondary text; describes the concept of running a command until a condition changes")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = secondaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

}
