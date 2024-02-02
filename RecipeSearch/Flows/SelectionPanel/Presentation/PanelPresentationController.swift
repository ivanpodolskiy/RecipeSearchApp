//
//  SelectionFavoriteSectionController.swift
//  RecipeSearch
//
//  Created by user on 06.06.2023.
//

import UIKit

class PanelPresentationController: UIPresentationController {
    private lazy var  dimmView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(tapRecognizer)
        view.backgroundColor = UIColor.black
        view.alpha = 0
        return view
    }()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTapHandle(recognizer: )))
        return recognizer
    }()
    
    @objc func dismissTapHandle(recognizer: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        presentedView?.translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        animateDimmView(withFinalAlpha: 0.75)
    }
    
    override func containerViewDidLayoutSubviews() {
        ativeLayoutConstraint()
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        animateDimmView(withFinalAlpha: 0)
    }
    
    private func addSubviews() {
        guard let containerView = containerView,
              let presentedView = presentedView else { return }
        containerView.addSubview(presentedView)
        containerView.insertSubview(dimmView, at: 0)
    }
 
    private func ativeLayoutConstraint() {
        guard let containerView = containerView,
              let presentedView = presentedView else { return }
        
        NSLayoutConstraint.activate([
            presentedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            presentedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            presentedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            presentedView.heightAnchor.constraint(lessThanOrEqualTo: containerView.heightAnchor , constant: -containerView.frame.height / 2),

            dimmView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            dimmView.topAnchor.constraint(equalTo: containerView.topAnchor),
            dimmView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dimmView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    private func animateDimmView(withFinalAlpha finalAlpha: CGFloat) {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmView.alpha = finalAlpha
            return
        }
        coordinator.animate { _ in
            self.dimmView.alpha = finalAlpha
        }
    }
}
