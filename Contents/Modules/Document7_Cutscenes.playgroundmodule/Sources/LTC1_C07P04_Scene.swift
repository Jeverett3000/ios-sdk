//
//  LTC1_C07P04_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P04_Scene)
class LTC1_C07P04_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var primaryTextBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var school: UIImageView!
    @IBOutlet weak var whiteCar: UIImageView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeOut = false

        primaryTextLabel.text = NSLocalizedString("Now, suppose you need to direct a car around a building to find a parking space.", comment: "primary text")

        secondaryTextLabel.text = NSLocalizedString("What instructions and rules can you use to move the car around the building?", comment: "secondary text")

        whiteCar.rotate(degrees: 180.0)

        // Both labels are invisible at the start of the scene.

        // Capture the position of the primary text from the storyboard.
        primaryTextYOffset = primaryTextBottomConstraint.constant

        // The first sentence will drop down, with bounce.
        primaryTextBottomConstraint.constant = -20.0

        // The second will fade in, after a delay.
        secondaryTextLabel.alpha = 0.0

        school.makeAccessible(label: NSLocalizedString("Overhead view of a building with a road going around it", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        animateChange(to: primaryTextBottomConstraint, value: primaryTextYOffset, duration: 0.7, delay: 0.3)

        UIView.animate(withDuration: 0.5, delay: 1.0, options: [],
                       animations: {
                        self.secondaryTextLabel.alpha = 1.0
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

    // MARK:- Private

    private var primaryTextYOffset: CGFloat = 0.0

}
