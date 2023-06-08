//
//  LTC1_C06P01_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C06P01_Scene)
class LTC1_C06P01_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextLabel: UILabel!

    @IBOutlet weak var leftHairline: UIView!
    @IBOutlet weak var leftHairlineCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftHairlineTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var rightHairline: UIView!
    @IBOutlet weak var rightHairlineCenterXConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightHairlineTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var hammer: UIImageView!
    @IBOutlet weak var hammerCenterYConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("While Loops", comment: "headline text; title of this chapter")

        secondaryTextLabel.text = NSLocalizedString("Are we there yet?", comment: "sub-head; question")

        // The hammer is not visible at the start of the scene.
        hammer.scale(by: 0.125)
        hammer.alpha = 0.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Compute the y offset that will give the illusion of the hammer striking the hairline.
        let hammerYOffset = leftHairlineTopConstraint.constant - (hammer.bounds.width / 2.0)

        // Get an animation helper.
        let animateFrames = UIView.keyframeAnimator(totalFrames: 75)

        // We need to have a linear animation curve, not the normal ease in ease out curve.
        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)

        UIView.animateKeyframes(withDuration: 2.0, delay: 0.5, options: [curveLinear, .calculationModeLinear],
                                animations: {
                                    // Bring the hammer into the scene.
                                    animateFrames(0,9) {
                                        self.hammer.alpha = 1.0
                                        self.hammer.scale(by: 8.0)
                                    }
                                    // Animate the hammer striking the hairline.
                                    animateFrames(42,54) {
                                        self.hammerCenterYConstraint.constant = hammerYOffset
                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(42,48) {
                                        self.hammer.rotate(degrees: 35.0)
                                    }
                                    animateFrames(48,54) {
                                        self.hammer.rotate(degrees: -125.0)
                                    }
                                    animateFrames(54,57) {
                                        self.hammer.rotate(degrees: -15.0)
                                    }
                                    // Animate the hairlines reacting to being hit.
                                    animateFrames(54,75) {
                                        self.leftHairlineTopConstraint.constant = self.hammerCenterYConstraint.constant
                                        self.leftHairlineCenterXConstraint.constant -= 28.0

                                        self.rightHairlineTopConstraint.constant = self.hammerCenterYConstraint.constant
                                        self.rightHairlineCenterXConstraint.constant += 28.0

                                        self.view.layoutIfNeeded()
                                    }
                                    animateFrames(54,57) {
                                        self.leftHairline.rotate(degrees: 24.0)
                                        self.rightHairline.rotate(degrees: -24.0)
                                    }
                                    animateFrames(57,75) {
                                        self.leftHairline.rotate(degrees: 156.0)
                                        self.rightHairline.rotate(degrees: -156.0)
                                    }
                                    // Animate the hammer returning to upright.
                                    animateFrames(57,66) {
                                        self.hammer.rotate(degrees: 105.0)
                                    }
        },
                                completion: { _ in
                                    self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

}
