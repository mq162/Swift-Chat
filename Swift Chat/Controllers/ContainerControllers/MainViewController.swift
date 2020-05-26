//
//  HomeViewController.swift
//  Swift Chat
//
//  Created by apple on 5/9/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class DarkCoverView: UIView {}

class MainViewController: UIViewController {

    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var contentViewContainer: UIView!
    @IBOutlet weak var sideMenuContainer: UIView!
    @IBOutlet weak var contentViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    
    //let dimmingView = UIView()
    let dimmingView: DarkCoverView = {
        let v = DarkCoverView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // if side menu is visible
    var menuVisible = false
    fileprivate let velocityThreshold: CGFloat = 500
    fileprivate let menuWidth = UIScreen.main.bounds.width * 0.8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenuLeadingConstraint.constant = 0 - UIScreen.main.bounds.width
        setupTapGestureRecognizer()
        setupGestureRecognizer()
        setupViewController()
    }
    
    
    func setupViewController() {
        contentViewContainer.addSubview(dimmingView)
        NSLayoutConstraint.activate([
        dimmingView.topAnchor.constraint(equalTo: contentViewContainer.topAnchor),
        dimmingView.leadingAnchor.constraint(equalTo: contentViewContainer.leadingAnchor),
        dimmingView.bottomAnchor.constraint(equalTo: contentViewContainer.bottomAnchor),
        dimmingView.trailingAnchor.constraint(equalTo: contentViewContainer.trailingAnchor),
        ])
    }
    
   //MARK: - Gesture Setup
    fileprivate func setupGestureRecognizer() {
        let panGestureRecognizser = UIPanGestureRecognizer(target: self, action: #selector(handlePan) )
        view.addGestureRecognizer(panGestureRecognizser)
    }
    
    fileprivate func setupTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        let menuWidth = sideMenuContainer.frame.size.width
        
        // how much distance have user finger moved since touch start (in X and Y)
        let translation = gesture.translation(in: view)
        var x = translation.x
        x = menuVisible ? x + menuWidth : x
        
        x = min(menuWidth, x)
        x = max(0, x)
        
        sideMenuLeadingConstraint.constant = x - menuWidth
        contentViewLeadingConstraint.constant = x
        dimmingView.alpha = x / menuWidth
        
        if (gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled){
            //handleEnded(gesture: gesture)
            if menuVisible {
                // user finger moved to left before ending drag
                if translation.x < (0 - menuWidth/3){
                    // toggle side menu (to fully hide it)
                    closeMenu()
                } else {
                    openMenu()
                }
            } else {
                // user finger moved to right and more than 100pt
                if(translation.x > menuWidth/3){
                    // toggle side menu (to fully show it)
                    openMenu()
                } else {
                    closeMenu()
                }
            }
            
            // early return so code below won't get executed
            return
        }
        
    }
    
    @objc func handleTap(gesture: UIPanGestureRecognizer){
        closeMenu()
    }
    
    //MARK: - Menu operation [open/close]
    func openMenu() {
        menuVisible = true
        sideMenuLeadingConstraint.constant = 0
        contentViewLeadingConstraint.constant = self.sideMenuContainer.frame.size.width
        performAnimations()
    }
    
    func closeMenu() {
        sideMenuLeadingConstraint.constant = 0 - self.sideMenuContainer.frame.size.width
        self.contentViewLeadingConstraint.constant = 0
        menuVisible = false
        performAnimations()
    }
    
    fileprivate func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.dimmingView.alpha = self.menuVisible ? 1 : 0
        })
    }

}
