//
//  LTC1_C07P03_Scene.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit
import SPCCutsceneSupport

@objc(LTC1_C07P03_Scene)
class LTC1_C07P03_Scene: SceneViewController {

    @IBOutlet weak var listHeadingLabel: UILabel!
    @IBOutlet weak var firstTaskLabel: UILabel!
    @IBOutlet weak var secondTaskLabel: UILabel!
    @IBOutlet weak var thirdTaskLabel: UILabel!

    @IBOutlet weak var listHeadingLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstTaskLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondTaskLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdTaskLeadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var minimap: UIView!
    @IBOutlet weak var minimapBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var firstRoute: UIView!
    @IBOutlet weak var secondRoute: UIView!
    @IBOutlet weak var thirdRoute: UIView!

    @IBOutlet weak var routeHighlight: UIImageView!

    // MARK:-

    override func viewDidLoad() {
        super.viewDidLoad()

        shouldFadeIn = false

        listHeadingLabel.text = NSLocalizedString("To avoid traffic:", comment: "heading of a list of tasks")

        firstTaskLabel.text = NSLocalizedString("Compare distances and average speeds.", comment: "task related to determining the fastest driving route")

        secondTaskLabel.text = NSLocalizedString("Compare current traffic conditions.", comment: "task related to determining the fastest driving route")

        thirdTaskLabel.text = NSLocalizedString("Select route with shortest travel time.", comment: "decision criteria for finding the best driving route")

        listElementConstraints = [ listHeadingLeadingConstraint,
                                   firstTaskLeadingConstraint,
                                   secondTaskLeadingConstraint,
                                   thirdTaskLeadingConstraint ]

        // Capture measurements from the storyboard.
        listElementXOffset = listHeadingLeadingConstraint.constant
        minimapBottomYOffset = minimapBottomConstraint.constant

        // Position the list elements offscreen for the start of the scene.
        for e in listElementConstraints {
            e.constant = 20.0
        }

        // Position the minimap offscreen for the start of the scene.
        minimapBottomConstraint.constant = -20.0

        allRouteElements = [ firstRoute,
                             secondRoute,
                             thirdRoute,
                             routeHighlight ]

        // The routes are not visible when the minimap is first shown.
        for r in allRouteElements {
            r.alpha = 0.0
        }

        minimap.makeAccessible(label: NSLocalizedString("Map displaying 3 routes. The shortest route is selected.", comment: "accessibility label"))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Animate the list heading in from offscreen.
        animateChange(to: listHeadingLeadingConstraint, value: listElementXOffset, duration: 0.7, delay: 0.0)

        // Animate the first line of text into view.
        animateChange(to: firstTaskLeadingConstraint, value: listElementXOffset, duration: 1.0, delay: 0.5)

        // Drop the minimap in, with bounce.
        animateChange(to: minimapBottomConstraint, value: minimapBottomYOffset, duration: 0.8, delay: 0.5)

        // Animate the first route into view.
        UIView.animate(withDuration: 0.4, delay: 1.3, options: [],
                       animations: {
                        self.firstRoute.alpha = 1.0
        })

        // Animate in the second line of text.
        animateChange(to: secondTaskLeadingConstraint, value: listElementXOffset, duration: 1.0, delay: 2.4)

        // Animate the second route into view.
        UIView.animate(withDuration: 0.4, delay: 3.2, options: [],
                       animations: {
                        self.secondRoute.alpha = 1.0
        })

        // Bring in the last line of text.
        animateChange(to: thirdTaskLeadingConstraint, value: listElementXOffset, duration: 1.0, delay: 4.1)

        // Animate the shortest route into view.
        UIView.animate(withDuration: 0.4, delay: 4.9, options: [],
                       animations: {
                        self.thirdRoute.alpha = 1.0
        },
                       completion: { _ in
                        UIAccessibility.post(notification: .screenChanged, argument: self.minimap)
        })

        // Animate a bright flash on the shortest route.
        let curveLinear = UIView.KeyframeAnimationOptions(rawValue: UIView.AnimationOptions.curveLinear.rawValue)
        UIView.animateKeyframes(withDuration: 2.0, delay: 6.0, options: [curveLinear, .calculationModeLinear],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
                                        self.routeHighlight.alpha = 1.0
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                                        self.routeHighlight.alpha = 0.0
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2) {
                                        self.routeHighlight.alpha = 1.0
                                    }
                                    UIView.addKeyframe(withRelativeStartTime: 0.8, relativeDuration: 0.2) {
                                        self.routeHighlight.alpha = 0.0
                                    }
        },
                                completion: { _ in
                                    self.animationsDidComplete()
        })
    }

    // MARK:- Private

    private var listElementXOffset: CGFloat = 0.0
    private var listElementConstraints: [NSLayoutConstraint] = []

    private var minimapBottomYOffset: CGFloat = 0.0
    private var allRouteElements: [UIView] = []
}
