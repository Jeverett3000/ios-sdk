//
//  LTC1_C07P09_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P09_Scene)
class LTC1_C07P09_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var hairline: UIView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("A lot of the code you’ve written so far has been instructions to solve problems. In this sense, you’ve been writing algorithms the whole time.", comment: "primary text")

        secondaryTextLabel.text = NSLocalizedString("The skill you’re adding now is the process of writing and tweaking code so you can use it in different situations.", comment: "primary text")

        // None of the content is visible at the start of the scene.
        primaryTextLabel.alpha = 0.0
        hairline.alpha = 0.0
        secondaryTextLabel.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Fade in the first paragraph.
        UIView.animate(withDuration: 0.5) {
            self.primaryTextLabel.alpha = 1.0
        }

        // Fade in the hairline.
        UIView.animate(withDuration: 0.5, delay: 1.0, options: [],
                       animations: {
                        self.hairline.alpha = 1.0
        })

        // Fade in the second paragraph.
        UIView.animate(withDuration: 0.5, delay: 1.25, options: [],
                       animations: {
                        self.secondaryTextLabel.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }
    
}
