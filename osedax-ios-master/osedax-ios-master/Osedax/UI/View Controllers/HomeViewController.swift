//
//  HomeViewController.swift
//  Osedax
//
//  Created by Gustavo Rago on 3/24/21.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController { // , UIScrollViewDelegate
    
//    @IBOutlet weak var scrollView: UIScrollView!
        
    let hamburgerView = HamburgerView()
    let profileIconView = ProfileIconView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(Self.onProfileNavigationNotification(notification:)), name: RightMenuViewController.profileNavigationEvent, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(Self.onClippingsNavigationNotification(notification:)), name: RightMenuViewController.clippingsNavigationEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onPurchasesNavigationNotification(notification:)), name: RightMenuViewController.purchasesNavigationEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onCloseMenuNotification(notification:)), name: MenuViewController.closeMenuEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onCloseRightMenuNotification(notification:)), name: RightMenuViewController.closeRightMenuEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onOpenMenuNotification(notification:)), name: MenuViewController.openMenuEvent, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(Self.onOpenRightMenuNotification(notification:)), name: RightMenuViewController.openRightMenuEvent, object: nil)

        definesPresentationContext = true
    }
    
    private func setupUI(){
        
//        scrollView.isDirectionalLockEnabled = true
        
//        let button = UIBarButtonItem(image: UIImage(named: "ic_drawer")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(Self.openLeftDrawer))
        
//        let button = UIBarButtonItem(customView: hamburgerView)
        let button = UIButton(frame: hamburgerView.bounds)
        button.addTarget(self, action: #selector(Self.openLeftDrawer), for: .touchUpInside)
        button.addSubview(hamburgerView)
        let leftBarButtonItem = UIBarButtonItem(customView: button)
        leftBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftBarButtonItem

        let buttonRight = UIButton(frame: profileIconView.bounds)
        buttonRight.addTarget(self, action: #selector(Self.openRightDrawer), for: .touchUpInside)
        buttonRight.addSubview(profileIconView)

        let rightBarButtonItem = UIBarButtonItem(customView: buttonRight)
        rightBarButtonItem.tintColor = .white
        navigationItem.rightBarButtonItem = rightBarButtonItem

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SideMenuNavigationController {
            vc.modalPresentationStyle = .overCurrentContext
            vc.presentationStyle = .menuSlideIn
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
        
        
                

    }
    
    @objc private func onProfileNavigationNotification(notification: Notification){
        
                
        performSegue(withIdentifier: "profile", sender: nil)
        
    }
    
    @objc private func onClippingsNavigationNotification(notification: Notification){
        
                
        performSegue(withIdentifier: "clippings", sender: nil)
        
    }

    @objc private func onPurchasesNavigationNotification(notification: Notification){
        
                
        performSegue(withIdentifier: "purchases", sender: nil)
        
    }

    @objc private func onOpenMenuNotification(notification: Notification){
        
                
        hamburgerView.startAnimation()
        
        
    }

    @objc private func onCloseMenuNotification(notification: Notification){
        
        
        hamburgerView.startCloseAnimation()
                
        
        
    }
    
    @objc private func onOpenRightMenuNotification(notification: Notification){
        
                
        profileIconView.startAnimation()
        
    }
    
    @objc private func onCloseRightMenuNotification(notification: Notification){
        
                
        profileIconView.startCloseAnimation()
        
    }



    @objc func openLeftDrawer(){
        
        if let vc = presentedViewController as? SideMenuNavigationController {
            presentedViewController?.dismiss(animated: true, completion: { [weak self] in
                
                if vc.viewControllers.first is RightMenuViewController {
                    self?.performSegue(withIdentifier: "left", sender: nil)
                }
                
            })
        } else {
            performSegue(withIdentifier: "left", sender: nil)
        }
        
    }

    @objc func openRightDrawer(){
        
        
        if let vc = presentedViewController as? SideMenuNavigationController {
            presentedViewController?.dismiss(animated: true, completion: { [weak self] in
                
                if vc.viewControllers.first is MenuViewController {
                    self?.performSegue(withIdentifier: "right", sender: nil)
                }
                
            })
        } else {
            performSegue(withIdentifier: "right", sender: nil)
        }
        
                
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIDevice.current.setValue(UIDeviceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()


    }

    override var shouldAutorotate: Bool {
        return true
    }
        
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
//    var currentPage = 0
//    var previousPage = 0
//
//    func updatePage(scrollView: UIScrollView) {
//           let pageWidth:CGFloat = scrollView.frame.height
//           let current:CGFloat = floor((scrollView.contentOffset.y-pageWidth/2)/pageWidth)+1
//           currentPage = Int(current)
//
//       }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        updatePage(scrollView: scrollView)
//
//        if previousPage != currentPage {
//             previousPage = currentPage
//             debugPrint("GGR: \(currentPage)")
//        }
//    }
    
}
