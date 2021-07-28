//
//  MainViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Firebase
import Alamofire
import RealmSwift

final class  MainViewController: BaseViewController
{
    // MARK: - Public properties -
    var presenter: MainPresenterProtocol!
    
    private var _isLogged = false
    
    private var _controllers = [BaseWireframe]()

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
        print("*** MainViewController viewDidLoad")
//        Logger.log("\(type(of: self))")
        
        super.viewDidLoad()
        
        addObservers()
        
        setupView()
        
        presenter.switchToStartController()
        
//        loginTest()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Constraints -
    override func updateViewConstraints()
    {
        if (!didSetupConstraints)
        {
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    // MARK: - Methods -
    func setupView()
    {
        view.setNeedsUpdateConstraints()
        view.backgroundColor = .black
    }
    
    deinit {
        print("*** MainViewController DEINIT")
    }
}



// MARK: - Observers -
private extension MainViewController
{
    func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerUserUid(_:)), name: Constants.Notify.UserUid, object: nil)
//
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerUserUidRemove(_:)), name: Constants.Notify.UserUidRemove, object: nil)
//
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerUserPlace(_:)), name: Constants.Notify.UserPlace, object: nil)
//
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerTables(_:)), name: Constants.Notify.Tables, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerAppForeground(_:)), name: Constants.Notify.AppForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerAppBackground(_:)), name: Constants.Notify.AppBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerAppBackground(_:)), name: Constants.Notify.AppBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerAppBackground(_:)), name: Constants.Notify.AppBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerChangeController(_:)), name: Constants.Notify.ChangeController, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerRemoveController(_:)), name: Constants.Notify.RemoveController, object: nil)
        
    }
    
    @objc func observerRemoveController(_ notification: NSNotification)
    {
        DispatchQueue.main.async {
            guard let name = notification.userInfo?["name"] as? String else { return }
                        
            if(name.isEmpty)
            {
                return
            }

            let transition = notification.userInfo?["transition"] as? BaseWireframeControllerTransition ?? BaseWireframeControllerTransition.None
                    
            if let wf = self._controllers.filter({ $0.GetName == name }).first
            {
                if let idx = self._controllers.firstIndex(where: { $0.GetName == name })
                {
                    self._controllers.remove(at: idx)
                    
                    guard let c = wf.viewController else {
                        return
                    }
                    
                    if(transition != .None)
                    {
                        UIView.animate(withDuration: 0.25) {
                            c.view.setX((transition == .Right) ? ScreenSize.SCREEN_WIDTH : ScreenSize.SCREEN_WIDTH * -1)
                        } completion: { success in
                            c.view.removeFromSuperview()
                        }
                    }
                    else
                    {
                        c.view.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    @objc func observerChangeController(_ notification: NSNotification)
    {
        DispatchQueue.main.async {
            
//            print("*** observerChangeController")
            
            guard let name = notification.userInfo?["name"] as? String else { return }
                        
            if(name.isEmpty)
            {
                return
            }
            
            print("*** observerChangeController *** NAME \(name)")
            
            let params = notification.userInfo?["params"] as? [String: Any] ?? [String: Any]()
            
            let transition = notification.userInfo?["transition"] as? BaseWireframeControllerTransition ?? BaseWireframeControllerTransition.None
            
            if let wf = self._controllers.filter({ $0.GetName == name }).first
            {
                print("NC 2 COUNT \(self._controllers.count)")
//
                wf.ReloadParams(params: params)
                
                guard let c = wf.viewController else {
                    return
                }
                
                c.view.setX(0)
                c.view.setY(0)
                
                switch(transition)
                {
                case .Right:
                    c.view.setX(ScreenSize.SCREEN_WIDTH)
                    break
                case .Left:
                    c.view.setX(ScreenSize.SCREEN_WIDTH * -1)
                    break
                case .None:
                    break
                }

                (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!.view.bringSubviewToFront(c.view)
                
                if(transition != .None)
                {
                    UIView.animate(withDuration: 0.25) {
                        c.view.setX(0)
                    } completion: { success in
                        
                    }
                }
            }
            else
            {
                let wf = self.getWF(name: name, params: params)
                
                guard let c = wf.viewController else {
                    return
                }
                
                self._controllers.append(wf)
                
                c.view.setX(0)
                c.view.setY(0)
                
                switch(transition)
                {
                case .Right:
                    c.view.setX(ScreenSize.SCREEN_WIDTH)
                    break
                case .Left:
                    c.view.setX(ScreenSize.SCREEN_WIDTH * -1)
                    break
                case .None:
                    break
                }
                                
                (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!.view.addSubview(c.view)
                
                if(transition != .None)
                {
                    UIView.animate(withDuration: 0.25) {
                        c.view.setX(0)
                    } completion: { success in
                        
                    }
                }
            }
        }
    }
    
    func getWF(name: String, params: [String: Any]) -> BaseWireframe
    {
        switch name {
        case "login":
            return LoginWireframe()
        case "loader":
            return LoaderWireframe()
        case "map":
            return MapWireframe()
        case "profile":
            return ProfileWireframe()
        case "table":
            return TableWireframe(params: params)
        case "orders":
            return OrdersWireframe()
        case "details":
            return DetailsWireframe(params: params)
        case "seats":
            return SeatsWireframe(params: params)
        default:
            return LoginWireframe()
        }
    }
    
    @objc func observerAppBackground(_ notification: NSNotification)
    {
        DispatchQueue.main.async {
            self.presenter.removeObservers()
        }
    }
    
    @objc func observerAppForeground(_ notification: NSNotification)
    {
        DispatchQueue.main.async {
            if(!self._isLogged)
            {
                return
            }
            
            self.presenter.syncPlaces(finish: {
                NotificationCenter.default.post(name: Constants.Notify.UserPlace, object: nil)
                
                self.presenter.syncUserData()
            })
        }
    }
    
    @objc func observerUserUidRemove(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
            self?.presenter.removeObservers()
            
            self!.presenter.removeAllData()
            
            self?.presenter.switchToStartController()
        }
    }
    
    

    @objc func observerUserUid(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
            Logger.log("*** observerUserUid")
            
            self!._isLogged = true

            self?.presenter.syncPlaces(finish: {
                print("** PLACES SYNC END")
                
                NotificationCenter.default.post(name: Constants.Notify.UserPlace, object: nil)
                
                self?.presenter.syncUserData()
            })                        
        }
    }
    
    @objc func observerUserPlace(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
//            Logger.log("*** observerUserPlace")
 
            self?.presenter.syncTables(finish: { place_uid in
//                print("** TABLES SYNC END")
                
                NotificationCenter.default.post(name: Constants.Notify.Tables, object: nil, userInfo: ["placeUid": place_uid])
            }, updateTables: {
                NotificationCenter.default.post(name: Constants.Notify.Tables, object: nil)
            })
            
            self?.presenter.syncMenuAll {
//                print("** MENU SYNC END")
                
                NotificationCenter.default.post(name: Notification.Name("MBRNotification.MenuReload"), object: nil)
            }
        }
    }
    
    //observerTable
    @objc func observerTables(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
//            Logger.log("*** observerTables")
            
            guard
                let userInfo = notification.userInfo,
                let placeUid = userInfo["placeUid"] as? String
            else {
//                Logger.log("!!! No tableUid")
                return
            }
         
            // checkins & table
            
            self?.presenter.syncCheckins(placeUid: placeUid, finish: { tableUID, checkinUID in

//                print("** CHECKINS SYNC END")

                let userInfo = [
                    "tableUid":   tableUID,
                    "checkinUid": checkinUID
                ]

                NotificationCenter.default.post(name: Constants.Notify.Checkins, object: nil, userInfo: userInfo)
            }, finishAll: {
                NotificationCenter.default.post(name: Constants.Notify.CheckinsAll, object: nil)
            })
            
            self?.presenter.syncOrderItems(placeUid: placeUid, finish: { uid, checkin_uid in

//                print("** ORDER ITEM SYNC END")

                let userInfo = [
                    "uid": uid,
                    "checkin_uid": checkin_uid
                ]

                NotificationCenter.default.post(name: Constants.Notify.OrderItem, object: nil, userInfo: userInfo)
            })
        }
    }
}

// MARK: - Extensions -
private extension MainViewController
{

}

// MARK: - MainViewProtocol -
extension MainViewController: MainViewProtocol
{
    
}
