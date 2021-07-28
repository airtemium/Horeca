
//  Created by Airtemium

import Foundation
import UIKit
import SnapKit

open class BaseViewController: UIViewController {
    
    var didSetupConstraints = false
    
    var activityIndicator: UIActivityIndicatorView?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    deinit {
//        Logger.log("\(type(of: self))")
    }

    func UpdateParams(params: [String: Any])
    {
        
    }
}

// MARK: life cycle

extension BaseViewController
{
    open override func viewDidLoad() {
        let desc = "\(type(of: superclass ?? UIViewController.self))".split(separator: ".").first ?? "\(type(of: self))"
//        Logger.log("\(desc)")
        super.viewDidLoad()
        
//        setupDefaultActivityIndicator()
    }

    open override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    open override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}

// MARK: public

public extension BaseViewController {

    /**
     Pops the top view controller from the navigation stack .
     */
    @objc func popViewController() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

// MARK: refresh control

extension BaseViewController {
    
    func setupRefreshControl(_ scrollView: UITableView) {
        refreshControl.addTarget(self, action: #selector(BaseViewController.triggerRefreshControl), for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }
    
    @objc func triggerRefreshControl() {
        refreshControl.beginRefreshing()
        refreshControl.endRefreshing()
        handleRefreshContent()
    }
    
    @objc func handleRefreshContent() {}

}

// MARK: setup navigation

extension BaseViewController {
    
    func setupNavigationBackButton() {

    }
}

// MARK: setup activity inidicator

extension BaseViewController {
    
//    func setupDefaultActivityIndicator() {
//        activityIndicator = UIActivityIndicatorView(style: .medium)
//        view.addSubview(activityIndicator!)
//    }
    
    func showIndicator() {
        if let activityIndicator = self.activityIndicator {
            activityIndicator.startAnimating()
        }
    }
    
    func hideIndicator() {
        if let activityIndicator = self.activityIndicator {
            activityIndicator.stopAnimating()
        }
    }
    
}
