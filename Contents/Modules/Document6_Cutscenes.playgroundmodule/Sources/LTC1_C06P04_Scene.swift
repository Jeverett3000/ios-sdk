//
//  LTC1_C06P04_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C06P04_Scene)
class LTC1_C06P04_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    
    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: UIView!

    @IBOutlet weak var whileExprLabel: UILabel!
    @IBOutlet weak var commandLabel: UILabel!
    
    @IBOutlet weak var hammer: UIImageView!
    @IBOutlet weak var nailBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var boardBottomConstraint: NSLayoutConstraint!
    
    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        // Capture the unstyled font of the labels that use attributed text.
        primaryTextFont = primaryTextLabel.font

        hammer.rotate(degrees: -60.0)

        primaryTextLabel.attributedText = attributedTextForPrimaryText()

        calloutTextLabel.attributedText = attributedTextForCalloutText()
        calloutPointer.rotate(degrees: 45.0)
        calloutElements = [ calloutTextLabel,
                            calloutBubble,
                            calloutPointer ]

        hammer.makeAccessible(label: NSLocalizedString("Hammer hitting nail all the way into board", comment: "accessibility label"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Ensure that we fit all of the localized text into the label.
        primaryTextLabel.resizeAttributedText(unstyledFont: primaryTextFont)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate the hammer striking the nail.
        let animateFrames = UIView.keyframeAnimator(totalFrames: 54)
        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)
        UIView.animateKeyframes(withDuration: 1.8, delay: 0.5, options: [curveLinear, .calculationModeLinear],
                                animations: {
                                    animateFrames(0,15) {
                                        self.hammer.rotate(degrees: 55.0)
                                    }
                                    animateFrames(15,24) {
                                        self.hammer.rotate(degrees: -85.0)
                                    }
                                    animateFrames(19,21) {
                                        self.nailBottomConstraint.constant -= 20.0
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
                                        self.hammer.rotate(degrees: -87.0)
                                    }
                                    animateFrames(39,41) {
                                        self.nailBottomConstraint.constant -= 20.0
                                        self.boardBottomConstraint.constant -= 5.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(41,43) {
                                        self.boardBottomConstraint.constant += 5.0
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(40,44) {
                                        self.hammer.rotate(degrees: 17.0)
                                    }
                                    animateFrames(44,54) {
                                        self.hammer.rotate(degrees: 20.0)
                                    }
        })

        // Change the message in the callout.
        UIView.animate(withDuration: 0.4, delay: 2.3, options: [],
                       animations: {
                        // Fade out the callout.
                        for e in self.calloutElements {
                            e.alpha = 0.0
                        }
        },
                       completion: { _ in
                        // Change the text.
                        self.calloutTextLabel.attributedText = self.attributedTextForUpdatedCallout()

                        // Fade in the callout with the new text.
                        UIView.animate(withDuration: 0.4, delay: 0.0, options: [],
                                       animations: {
                                        for e in self.calloutElements {
                                            e.alpha = 1.0
                                        }
                        },
                                       completion: { _ in
                                        UIAccessibility.post(notification: .screenChanged,
                                                             argument: self.calloutTextLabel)
                                        self.animationsDidComplete()
                        })
        })
    }

    // MARK:- Private

    private var calloutElements: [UIView] = []

    private let variableName = "nailIsStickingOut"
    private let commandName = "hammerNail"

    private var primaryTextFont: UIFont!
    private func attributedTextForPrimaryText() -> NSAttributedString {

        let text = NSLocalizedString("You can use a <b>while loop</b> to repeat a command, or set of commands, while a condition is true.", comment: "secondary text; describes the concept of running a command until a condition changes")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = primaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attributedTextForCalloutText() -> NSAttributedString {

        let template = NSLocalizedString("The condition <cv>%@</cv> is true, so <cv>%@()</cv> runs.", comment: "callout text; the inserted words are a variable name and a function name")
        let text = String(format: template, variableName, commandName)

        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attributedTextForUpdatedCallout() -> NSAttributedString {

        let template = NSLocalizedString("When <cv>%@</cv> is false, <cv>%@()</cv> stops running.", comment: "callout text; the inserted words are a variable name and a function name")
        let text = String(format: template, variableName, commandName)

        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
