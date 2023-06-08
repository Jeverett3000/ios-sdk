//
//  LTC1_C07P02_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P02_Scene)
class LTC1_C07P02_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.attributedText = attributedTextForPrimaryText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
        animationsDidComplete()
    }
    
    // MARK:- Private

    private func attributedTextForPrimaryText() -> NSAttributedString {

        let text = NSLocalizedString("An <b>algorithm</b> is a set of rules and instructions you use to solve a problem.\n\nFor example, a navigation app uses an algorithm to figure out the fastest path to where you want to go.", comment: "primary text")

        var style = CutsceneAttributedStringStyle()
        style.fontSize = primaryTextLabel.font.pointSize

        return NSAttributedString(textXML: text, style: style)
    }

}
