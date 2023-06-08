//
//  LTC1_C07P01_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P01_Scene)
class LTC1_C07P01_Scene: SceneViewController {

    @IBOutlet weak var primaryTextLabel: UILabel!

    @IBOutlet weak var secondaryTextLabel: UILabel!
    @IBOutlet weak var secondaryTextTopConstraint: NSLayoutConstraint!

    @IBOutlet weak var leftHairline: UIView!
    @IBOutlet weak var leftHairlineTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var rightHairline: UIView!
    @IBOutlet weak var rightHairlineCenterXConstraint: NSLayoutConstraint!

    @IBOutlet weak var gpsMarker: UIImageView!
    @IBOutlet weak var gpsMarkerCenterYConstraint: NSLayoutConstraint!
    @IBOutlet weak var gpsMarkerCenterXConstraint: NSLayoutConstraint!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryTextLabel.text = NSLocalizedString("Algorithms", comment: "heading; title of the chapter")

        secondaryTextLabel.text = NSLocalizedString("One step at a time", comment: "sub-heading; describes an algorithm")

        gpsMarker.rotate(degrees: -90)

        viewsToFadeIn = [ leftHairline,
                          rightHairline,
                          primaryTextLabel,
                          secondaryTextLabel,
                          gpsMarker ]

        // Prepare to fade in the elements above.
        for e in viewsToFadeIn {
            e.alpha = 0.0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.layoutIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // The distance to move the hairlines to make room for the gps marker.
        let xOffset: CGFloat = 50.0

        // The distance that the gps marker and sub heading will move.
        let yOffset: CGFloat = gpsMarkerCenterYConstraint.constant - leftHairlineTopConstraint.constant

        UIView.animateKeyframes(withDuration: 1.5, delay: 0.40, options: [],
                       animations: {
                        // Fade in the content.
                        UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.3333) {
                            for v in self.viewsToFadeIn {
                                v.alpha = 1.0
                            }
                        }
                        // Move the gps marker into position.
                        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                            self.gpsMarkerCenterXConstraint.constant = 512.0
                            self.view.layoutIfNeeded()
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.3) {
                            self.gpsMarker.rotate(degrees: 90)
                        }
                        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                            self.leftHairlineCenterXConstraint.constant += xOffset
                            self.rightHairlineCenterXConstraint.constant -= xOffset
                            self.secondaryTextTopConstraint.constant -= yOffset
                            self.gpsMarkerCenterYConstraint.constant -= yOffset
                            self.view.layoutIfNeeded()
                        }
        },
                       completion: { _ in
                        self.animationsDidComplete()
        })

        UIAccessibility.post(notification: .screenChanged, argument: primaryTextLabel)
    }

    // MARK:- Private
    
    private var viewsToFadeIn: [UIView] = []
}
