//
//  LTC1_C06P03_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C06P03_Scene)
class LTC1_C06P03_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var primaryTextBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var prevPrimaryTextLabel: UILabel!
    @IBOutlet weak var prevSecondaryTextLabel: UILabel!

    @IBOutlet weak var whileExprLabel: UILabel!
    @IBOutlet weak var openingBraceLabel: UILabel!
    @IBOutlet weak var closingBraceLabel: UILabel!
    @IBOutlet weak var commandLabel: UILabel!

    @IBOutlet weak var calloutTextLabel: UILabel!
    @IBOutlet weak var calloutBubble: UIView!
    @IBOutlet weak var calloutPointer: UIView!
    @IBOutlet weak var codeCalloutBubble: UIView!

    @IBOutlet weak var hammer: UIImageView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false
        shouldFadeOut = false

        // Capture the unstyled font of the labels that use attributed text.
        primaryTextFont = primaryTextLabel.font

        hammer.rotate(degrees: -60.0)

        prevPrimaryTextLabel.text = NSLocalizedString("When you’re hammering a nail, you can’t just hit it a certain number of times and expect it to go all the way in.", comment: "primary text")

        prevSecondaryTextLabel.attributedText = attributedTextForSecondaryText()
        primaryTextLabel.attributedText = attributedTextForPrimaryText()

        // Capture y position from storyboard.
        primaryTextYPosition = primaryTextBottomConstraint.constant

        // Position the primary text out of view.
        primaryTextBottomConstraint.constant = -20.0

        codeElements = [ whileExprLabel,
                         openingBraceLabel,
                         closingBraceLabel,
                         commandLabel ]

        // The code is not visible at the start of the scene.
        for e in codeElements {
            e.alpha = 0.0
        }

        calloutTextLabel.attributedText = attributedTextForCalloutText()
        calloutPointer.rotate(degrees:45)
        calloutElements = [ calloutTextLabel,
                            calloutBubble,
                            calloutPointer,
                            codeCalloutBubble ]

        // The callouts are not visible at the start of the scene.
        for e in calloutElements {
            e.alpha = 0.0
        }

        hammer.makeAccessible(label: NSLocalizedString("a hammer and a board with a nail hammered halfway in", comment: "accessibility label"))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Ensure that we fit all of the localized text into the label.
        primaryTextLabel.resizeAttributedText(unstyledFont: primaryTextFont)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.3, animations: {
            self.prevPrimaryTextLabel.alpha = 0.0
            self.prevSecondaryTextLabel.alpha = 0.0
        })

        animateChange(to: primaryTextBottomConstraint, value: primaryTextYPosition, duration: 0.7, delay: 0.3)

        UIView.animate(withDuration: 0.5, delay: 2.0, options: [],
                       animations: {
                        for e in self.codeElements {
                            e.alpha = 1.0
                        }
        })

        UIView.animate(withDuration: 0.5, delay: 4.0, options: [],
                       animations: {
                        for e in self.calloutElements {
                            e.alpha = 1.0
                        }
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

    // MARK:- Private

    private var primaryTextYPosition: CGFloat = 0.0

    private var codeElements: [UIView] = []
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

    private func attributedTextForSecondaryText() -> NSAttributedString {

        let text = NSLocalizedString("Instead, you continue hitting the nail <b>while</b> the nail is sticking out.", comment: "secondary text; describes the concept of running a command until a condition changes")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = prevSecondaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

    private func attributedTextForCalloutText() -> NSAttributedString {

        let template = NSLocalizedString("The condition <cv>%@</cv> is true, so <cv>%@()</cv> runs.", comment: "callout text; the inserted words are a variable name and a function name")
        let text = String(format: template, variableName, commandName)

        var style = CutsceneAttributedStringStyle()
        style.fontSize = calloutTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }
}
