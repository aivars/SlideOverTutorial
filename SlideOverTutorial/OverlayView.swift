//
//  OverlayView.swift
//  SlideOverTutorial
//
//  Created by Aivars Meijers on 09/09/2020.
//

import UIKit

class OverlayView: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    @IBOutlet weak var slideIdicator: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subscribeButton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        slideIdicator.roundCorners(.allCorners, radius: 10)
        subscribeButton.roundCorners(.allCorners, radius: 10)
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let draggedToDismiss = (translation.y > view.frame.size.height/3.0)
            let dragVelocity = sender.velocity(in: view)
            if (dragVelocity.y >= 1300) || draggedToDismiss {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
