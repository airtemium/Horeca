//
//  MainViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import UIKit

enum SeatsViewControllerCarouselState
{
    case Up
    case Down
    case Moving
}

enum SeatsViewControllerState
{
    case New
    case Inited
}

final class SeatsViewController: BaseViewController
{
    private var _state = SeatsViewControllerState.New
    
    private var carouselMinPos: CGFloat = 98
    
    private var carouselMaxPos: CGFloat = 98 + ScreenSize.SCREEN_HEIGHT / 2 - 98 - 98
    
    private var carouselState = SeatsViewControllerCarouselState.Down
    
    private var isKeyboard = false
    
    private var keyboardHeight: CGFloat = 0
    
    private var menuIsAbove = false
    
    var topPanel: SeatsTopPanel = {
        var p = SeatsTopPanel()
        return p
    }()
    
    var carousel: SeatsCarousel!
    
    var layoutSeats: SeatsTableLayoutView = {
        var v = SeatsTableLayoutView()
        return v
    }()
    
    var layoutMenu: SeatsMenuCollection = {
        var v = SeatsMenuCollection()        
        return v
    }()
    
    var search: SeatsSearchPanel = {
        var v = SeatsSearchPanel()
        return v
    }()
    
    var presenter: SeatsPresenterProtocol!

    private var currentSeat: Int = -1
    
    private var buttonUndo: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "seats_undo"), for: .normal)
        return b
    }()
    
    private var buttonAdd: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "seats_add_seat"), for: .normal)
        return b
    }()
    
    private var currentCheckinUID = ""
    {
        didSet {
            print("currentCheckinUID *** Old  \(oldValue) ***  new is \(currentCheckinUID)")
        }
    }
    
    var currentSeatPoints: CGPoint?
    
    private var infoHint: InfoHint!
    
    private var _unconfirmedCheckins = [CheckinModel]()
//    {
////        didSet
////        {
////            self.topPanelReload()
////        }
//    }
    
    private var _unconfirmedOrderItems = [OrderItemModel]()
    {
        didSet
        {
            topPanel.SetBadgeCount(count: _unconfirmedOrderItems.filter({ $0.isNew }).count)
            
            topPanelReloadAmount()
        }
    }

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
        print("*** SeatsViewController UID \(self.presenter.getTableUID())")
        
        super.viewDidLoad()
        
        addObservers()
                        
        setupView()
        
        navigationController?.navigationBar.isHidden = true        
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if(_state == .Inited)
        {
            return
        }
        
        _state = .Inited
        
        topPanelReload()
            
        menuRootReload()

        layoutSeats.Init()

        _unconfirmedCheckins = self.presenter.getTableCheckins()
        
        for i in _unconfirmedCheckins
        {
            let items = self.presenter.getOrderItemsByCheckin(checkinUID: i.checkinUid)
            
            for i2 in items
            {
                _unconfirmedOrderItems.append(i2)
            }
        }
                
        self.layoutSeats.Reload(checkins: _unconfirmedCheckins)
    }

    // MARK: - Constraints -
    override func updateViewConstraints()
    {
        if (!didSetupConstraints)
        {

            
//            search.snp.makeConstraints { make in
//                make.top.equalTo(self.layoutSeats.snp.bottom)
//                make.left.right.equalToSuperview()
//                make.height.equalTo(49)
//            }
//
//            layoutMenu.snp.makeConstraints { make in
//                make.top.equalTo(self.search.snp.bottom)
//                make.left.right.bottom.equalToSuperview()
//            }
//
//            carousel.snp.makeConstraints { make in
//                make.left.right.equalToSuperview()
//                make.height.equalTo(98)
//                make.top.equalTo(topPanel.snp.bottom)
//            }
                        
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func addObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerMenuReload(_:)), name: Constants.Notify.Menu, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerCheckinsReload(_:)), name: Constants.Notify.Checkins, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerOrderItemsReload(_:)), name: Constants.Notify.OrderItem, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerOrderItemsAddExternal(_:)), name: Constants.Notify.DetailsAddMenuItem, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification)
    {
//        print("*** keyboardWillShow isKeyboard \(isKeyboard)")

        if(isKeyboard)
        {
            return
        }

        if(self.carouselState == .Up)
        {
            return
        }
        
        DispatchQueue.main.async(execute: {

            if let userInfo = (sender as NSNotification).userInfo
            {
                self.isKeyboard = true

                self.keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).size.height

                let offset: CGFloat = self.keyboardHeight * -1

                UIView.animate(withDuration: 0.3) {
                    self.view.setY(offset)
                }

            }
        })
    }

    @objc func keyboardWillHide(_ sender: NSNotification)
    {
        DispatchQueue.main.async(execute: {
            self.isKeyboard = false
            
            self.view.setY(0)
        })
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func observerOrderItemsAddExternal(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
            guard
                let userInfo = notification.userInfo,                
                let menuItemUID = userInfo["menu_item_uid"] as? String
            else
            {
                return
            }
            
            //---
            
            
            if(!self!.currentCheckinUID.isEmpty)
            {
                self!.addMenuItemToCheckin(checkin: self!.currentCheckinUID, menuItemUID: menuItemUID)
            }
            else
            {
                self!.createCheckinForGuestNumberAndAddMenuItem(number: self!.currentSeat, menuItemUID: menuItemUID)
            }
        }
    }

    @objc func observerMenuReload(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
//            Logger.log("*** observerMenuReload")

            self?.menuRootReload()
        }
    }
    
    func _reloadCheckins()
    {
        self.topPanelReload()
        
        self.layoutSeats.Reload(checkins: _unconfirmedCheckins, force: false)
    }
    
    @objc func observerCheckinsReload(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
            guard
                let userInfo = notification.userInfo,
                let tableUid = userInfo["tableUid"] as? String,
                let checkinUid = userInfo["checkinUid"] as? String
            else
            {
                return
            }
            
//            print("*** observerCheckinsReload 1 ")
            
            if(self?.presenter.getTableUID() == tableUid)
            {
                if(self!._unconfirmedCheckins.filter({  $0.checkinUid == checkinUid }).count == 0)
                {
                    let checkins = self?.presenter.getTableCheckins()
                    
                    guard let nCheckin = checkins?.filter({ $0.checkinUid == checkinUid }).first else { return }
                    
                    self!._unconfirmedCheckins.append(nCheckin)
                    
                    self!.layoutSeats.NewCheckin(checkin: nCheckin)
                    
                    self!.topPanelReload()
                    
                    self!.showHintCheckinsUpdated()
                }
                
////                print("*** observerCheckinsReload 2 *** \(self?.presenter.getTableUID()) *** \(tableUid)")
//
//                self?.presenter.ReloadData()
//
//                self!.topPanelReload()
//
//                let checkins = self?.presenter.getTableCheckins()
//
//                self!.layoutSeats.Reload(checkins: checkins!)
//
//                self!.showHintCheckinsUpdated()
            }
        }
    }
    
    @objc func observerOrderItemsReload(_ notification: NSNotification)
    {
//        print("*** observerOrderItemsReload 1")
        
        DispatchQueue.main.async { [weak self] in
//            Logger.log("*** observerOrderItemsReload 1")
            
//            print("*** observerOrderItemsReload 2")
            
            guard
                let userInfo = notification.userInfo,
                let order_item_uid = userInfo["uid"] as? String,
                let checkin_uid = userInfo["checkin_uid"] as? String
            else
            {
                return
            }
            
            if(self!._unconfirmedCheckins.filter({  $0.checkinUid == checkin_uid }).count > 0)
            {
                if(self!._unconfirmedOrderItems.filter({ $0.UID == order_item_uid }).count == 0)
                {
                    
                    guard let items = self!.presenter.getOrderItemsByCheckin(checkinUID: checkin_uid).filter({ $0.UID == order_item_uid }).first else { return }
                        
                    self!._unconfirmedOrderItems.append(items)
                    
                    self!.topPanelReload()
                    
                    self!.showHintCheckinsUpdated()
                }
            }
        }
    }

    // MARK: - Methods -
    func setupView()
    {
        view.setNeedsUpdateConstraints()

        view.backgroundColor = UIColor.black
        
        view.addSubview(topPanel)
        
        view.addSubview(layoutSeats)
        
        view.addSubview(search)
        
        view.addSubview(layoutMenu)
        
        view.addSubview(buttonAdd)
        
        view.addSubview(buttonUndo)
        
        
        topPanel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(98)
        }
        
        layoutSeats.snp.makeConstraints { make in
            make.top.equalTo(self.topPanel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(ScreenSize.SCREEN_HEIGHT / 2 - 98)
        }
        
        buttonUndo.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        buttonAdd.snp.makeConstraints { make in
            make.width.height.equalTo(48)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-40)
        }
        
        view.layoutIfNeeded()
        
        topPanel.delegate = self
        
        layoutMenu.delegate = self
        layoutMenu.manipulationDelegate = self
        
        //--
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.menuSwipeUp(_:)))
        swipeUp.direction = .up
        layoutMenu.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.menuSwipeDown(_:)))
        swipeDown.direction = .down
        layoutMenu.addGestureRecognizer(swipeDown)
        
        //---
        
        
        
        search.delegate = self
        
        layoutSeats.delegate = self
        
        carousel = SeatsCarousel()
        carousel.delegate = self
        carousel.isHidden = true
        view.addSubview(carousel)
        
//        carousel.setX(0)
//        carousel.setY(carouselMaxPos)
//        carousel.setSize(ScreenSize.SCREEN_WIDTH, 98)
        
        carousel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(98)
            make.width.equalTo(ScreenSize.SCREEN_WIDTH)
            make.top.equalTo(carouselMinPos)
        }
//
        self.view.layoutIfNeeded()
//
        carousel.Setup()
        
        //
        search.setX(0)
        search.setY(carouselMaxPos + 98)
        search.setSize(ScreenSize.SCREEN_WIDTH, 49)
        
        layoutMenu.setX(0)
        layoutMenu.setY(0, relative: search)
        layoutMenu.setSize(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT - 49 - 98 - 98)

        buttonAdd.addTarget(self, action: #selector(self.addNewSeat(_:)), for: .touchUpInside)
        buttonUndo.addTarget(self, action: #selector(self.undoInHistory(_:)), for: .touchUpInside)
    }
    
    @objc func addNewSeat(_ sender: AnyObject)
    {
        layoutSeats.AddNewSeat()
    }
    
    @objc func undoInHistory(_ sender: AnyObject)
    {
        
    }
    
    func menuRootReload()
    {
        self.presenter.ReloadCategories()
        
        self.layoutMenu.ReloadData()
    }
    
    func _getTotalAmount() -> Double
    {
//        var total =  _unconfirmedOrderItems.reduce(0) { $0 + $1.Price }
        
        var total: Double = 0
        
        for i in _unconfirmedOrderItems
        {
            total = total + i.Price
        }
        
        return total
    }
    
    func topPanelReloadAmount()
    {
        let currency = presenter.getPlaceCurrency()
        
        let amount: Double = _getTotalAmount()
        
        self.topPanel.UpdateAmount(amount: amount, currency: currency)
    }
    
    func topPanelReload()
    {
        let tableName = presenter.getTableName()
        let amount: Double = _getTotalAmount()
        let currency = presenter.getPlaceCurrency()
        
        let code = presenter.getTableCode()
        
        topPanel.Update(tableName: tableName, amount: amount, currency: currency, code: code)
        
        self.presenter.getCode(table: self.presenter.getTableUID()) { code in
            self.topPanel.Update(tableName: tableName, amount: amount, currency: currency, code: String(code!))
        }
    }
}

extension SeatsViewController: SeatsTopPanelDelegate, SeatsTableLayoutViewDelegate, SeatsMenuCollectionManipulationDelegate
{
    func getCheckinColorByNumber(number: Int) -> UIColor
    {
        self.presenter.getCheckinColorByNumber(number: number)
    }
    
    @objc func menuSwipeUp(_ sender: AnyObject)
    {
        SeatsMenuCollectionDelegateOffsetUp()
    }
    
    @objc func menuSwipeDown(_ sender: AnyObject)
    {
        SeatsMenuCollectionDelegateOffsetDown()
    }
    
    func SeatsMenuCollectionDelegateOffsetUp()
    {
//        if(currentCheckinUID.isEmpty)
//        {
//            return
//        }
        
        //carousel.setY(carouserMaxPos)
        
        if(carouselState == .Down)
        {
            print("*** SeatsMenuCollectionDelegateOffsetUp")

            carouselState = .Moving

            UIView.animate(withDuration: 0.15) {
                self.search.setY(self.carouselMinPos + 98)
                self.layoutMenu.setY(0, relative: self.search)
            } completion: { success in
                self.carouselState = .Up

                if(self.currentSeat < 0)
                {
                    self.carousel.isHidden = true
                }
                else
                {
                    self.carousel.isHidden = false
                }
                
                
            }
        }
    }
    
    func SeatsMenuCollectionDelegateOffsetDown()
    {
//        if(currentCheckinUID.isEmpty)
//        {
//            return
//        }
        
        if(carouselState == .Up)
        {
            print("*** SeatsMenuCollectionDelegateOffsetDown")
            carouselState = .Moving
            
//            UIView.animate(withDuration: 0.5) {
            self.carousel.isHidden = true

            UIView.animate(withDuration: 0.15) {
                self.search.setY(self.carouselMaxPos + 98)
                self.layoutMenu.setY(0, relative: self.search)
            } completion: { success in
                self.carouselState = .Down
            }
        }
    }
    
    func getOrderItemsByCheckin(checkinUID: String) -> Int
    {
//        return self.presenter.getOrderItemsByCheckin(checkinUID: checkinUID).count
        
        return _unconfirmedOrderItems.filter( { $0.CheckinUID == checkinUID }).count
    }
    
    func chooseSeat(_ number: Int, points: CGPoint)
    {
        print("*** chooseSeat \(number)")
        
        currentSeat = number
        
        currentSeatPoints = points
                        
        guard let checkin = _unconfirmedCheckins.first(where: { $0.guestNumber == number } ) else
        {
            currentCheckinUID = ""
            
            carousel.SetChoosed(seatNumber: number, checkinUID: "")
            return            
        }
        
        carousel.SetChoosed(seatNumber: number, checkinUID: checkin.checkinUid)
                        
        currentCheckinUID = checkin.checkinUid
    }

//    func toggleSeat(_ number: Int)
//    {
//        layoutSeats.disactiveSeat(number)
//    }
    
    func getTableConfig() -> TableModel?
    {
        print("*** getTableConfig 1")
        guard let table = presenter.getTable() else { return nil }
        
        print("*** getTableConfig 2")
        
        return table
    }
    
    func getTableCheckins() -> [CheckinModel]
    {
        print("*** SeatsViewController getTableCheckins")
        
        return _unconfirmedCheckins
    }
    
    func SeatsSearchPanelBackAction(endEditing: Bool = true)
    {
        print("*** SeatsSearchPanelBackAction")
        
        if endEditing
        {
            self.view.endEditing(true)
        }
                        
        menuRootReload()
    }
        
    func SeatsTopPanelDelegateOrdersAction()
    {
        print("*** SeatsTopPanelDelegateOrdersAction")
        
        self.view.endEditing(true)
        
        if(_unconfirmedOrderItems.count > 0 || self._unconfirmedCheckins.count > 0)
        {
            if(_unconfirmedOrderItems.filter({ $0.isNew }).count > 0 || _unconfirmedCheckins.filter({ $0.isNew }).count > 0)
            {
                let loader = MayberLoader(title: "Waiting for a while...")
                self.view.addSubview(loader)
        
                loader.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                                                
                self.presenter.getCode(table: self.presenter.getTableUID()) { code in
                    let dg = DispatchGroup()
                    let dg2 = DispatchGroup()
                    
                    if(self._unconfirmedCheckins.filter({ $0.isNew }).count > 0)
                    {
                        for i in self._unconfirmedCheckins.filter({ $0.isNew })
                        {
                            dg.enter()
                            self.presenter.createCheckin(guest_number: i.guestNumber, table_code: code!) { checkin in
                                for i in self._unconfirmedOrderItems.filter({ $0.CheckinUID == i.checkinUid })
                                {
                                    i.CheckinUID = checkin
                                }
                                                            
                                if let chekinData = self._unconfirmedCheckins.filter({ $0.checkinUid == i.checkinUid }).first
                                {
                                    chekinData.isNew = false
                                    chekinData.checkinUid = checkin

                                    dg.leave()
                                }
                                else
                                {
                                    dg.leave()
                                }
                            } failure: { error in
                                dg.leave()
                            }
                        }
                    }
                    else
                    {
                        dg.enter()
                        dg.leave()
                    }
                                                            
                    dg.notify(queue: DispatchQueue.main)
                    {
                        if(self._unconfirmedOrderItems.filter({ $0.isNew }).count > 0)
                        {
                            for i in self._unconfirmedOrderItems.filter({ $0.isNew })
                            {
                                
                                dg2.enter()
                                
                                i.isNew = false
        
                                self.presenter.addMenuItemToCheckin(checkinUID: i.CheckinUID, menuItemUID: i.MenuItemUID) {
                                    dg2.leave()
                                } failure: {
                                    
                                    dg2.leave()
                                }
                            }
                        }
                        else
                        {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                            {
                                loader.snp.removeConstraints()
                                loader.removeFromSuperview()

                                self._state = .New
                                
                                self.presenter.switchToTable()
                            }
                        }                            
                    }
                    
                    dg2.notify(queue: DispatchQueue.main)
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                        {
                            loader.snp.removeConstraints()
                            loader.removeFromSuperview()

                            self._state = .New
                            
                            self.presenter.switchToTable()
                        }
                    }
                }
            }
            else
            {
                self._state = .New
                
                self.presenter.switchToTable()
            }
        }
    }
}

extension SeatsViewController: SeatsMenuCollectionDelegate, SeatsSearchPanelDelegate
{
    func showDrinksCategory()
    {
        self.presenter.ReloadDrinksCategory()
        
        self.layoutMenu.ReloadData()
    }
    
    func showActionForMenuItem(uid: String)
    {
        print("** showActionForMenuItem")
        
        self.view.endEditing(true)
        
        self.presenter.GoToMenuItemDetails(uid: uid)
    }
    
    func SeatsSearchPanelAnyFind(_ text: String)
    {
        self.presenter.ReloadMenuByKeyword(keyword: text)
        
        self.layoutMenu.ReloadData()
    }
    
    func SeatsTopPanelDelegateBackAction()
    {
        print("*** SeatsTopPanelDelegateBackAction")
        
        self.view.endEditing(true)
        
        if(_unconfirmedCheckins.filter({ $0.isNew }).count > 0 || _unconfirmedOrderItems.filter({ $0.isNew }).count > 0)
        {
            let alert = SeatsConfirmAlert {

            } actionContinue: {
                self._state = .New
                
                self.presenter.BackToMap()
            }

            self.view.addSubview(alert)

            alert.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        else
        {
            self._state = .New
            
            self.presenter.BackToMap()
        }
    }
    
    func showCategoryItemsBy(categoryUID: String)
    {
        print("*** showCategoryItemsBy *** \(categoryUID)")
        
        self.view.endEditing(true)
        
        self.presenter.ReloadCategoryItems(categoryUID: categoryUID)
        
        self.layoutMenu.ReloadData()
    }
    
    func showHintCheckinsUpdated()
    {
        if(infoHint != nil)
        {
            infoHint.removeFromSuperview()
        }
        
        infoHint = InfoHint(title: "Checkins has been updated")

        infoHint.toCenterX(self.view)
        infoHint.setY(10, relative: topPanel)
        self.view.addSubview(infoHint)

        infoHint.Show()
    }
    
    func anyActionForMenuItem(uid: String, location: CGPoint, size: CGSize)
    {
        //----
        print("** anyActionForMenuItem")
        
        self.view.endEditing(true)
        
        if(currentSeat < 0)
        {
            if(infoHint != nil)
            {
                infoHint.removeFromSuperview()
            }
            
            infoHint = InfoHint(title: "You have to choose a seat...")

            infoHint.toCenterX(self.view)
            infoHint.setY(10, relative: topPanel)
            self.view.addSubview(infoHint)

            infoHint.Show()
            
            return
        }
        
        guard let getMenuItem = self.presenter.getMenuItem(menuItemUID: uid) else { return }
        
        var previewLayer = UIView()
        previewLayer.alpha = 0
        previewLayer.clipsToBounds = true
        previewLayer.setSize(size.width, size.height)
        previewLayer.center = location
        
        let url = URL(string: getMenuItem.PhotoURI)
        let preview = UIImageView()
        preview.alpha = 1
        preview.clipsToBounds = true
        preview.kf.setImage(with: url, placeholder: UIImage(named: "dishThumb"))
        
        preview.setSize(size.width, size.height)
//        preview.toCenterX(self.view)
//        preview.toCenterY(self.view)
        preview.contentMode = .scaleAspectFill
//        preview.layer.cornerRadius = preview.getWidth() / 2
        preview.layer.borderWidth = 1
        preview.layer.borderColor = UIColor.white.cgColor
        
        preview.setX(0)
        preview.setY(0)
        self.view.addSubview(previewLayer)
        previewLayer.addSubview(preview)
        
//        UIView.animate(withDuration: 0.25) {
//
//        } completion: { success in
//
//        }
        
        var finitePoints = CGPoint.zero
        
        if(carouselState == .Up)
        {
            finitePoints = carousel.center
        }
        else if(currentSeat > 0 && currentSeatPoints != CGPoint.zero)
        {
            finitePoints = self.currentSeatPoints!
        }
        else if(currentSeat == 0)
        {
            finitePoints = layoutSeats.center
        }
        
        if(finitePoints != CGPoint.zero)
        {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions.curveEaseIn)
            {
//                preview.setSize(100, 100)
                previewLayer.center = location
                previewLayer.alpha = 1
//                preview.layer.cornerRadius = preview.getWidth() / 2
            } completion: { success in
                UIView.animate(withDuration: 0.45, delay: 0.5, options: UIView.AnimationOptions.curveEaseIn)
                {
                    previewLayer.setSize(35, 35)
                    previewLayer.center = finitePoints
                    previewLayer.alpha = 1
                    previewLayer.layer.cornerRadius = previewLayer.getWidth() / 2
                } completion: { success in
                    previewLayer.alpha = 0
                    previewLayer.removeFromSuperview()
                    
                    if(!self.currentCheckinUID.isEmpty)
                    {
                        self.addMenuItemToCheckin(checkin: self.currentCheckinUID, menuItemUID: uid)
                        
                        self.carousel.ReloadCarousel(seatNumber: self.currentSeat, checkinUID: self.currentCheckinUID)
                    }
                    else
                    {
                        self.createCheckinForGuestNumberAndAddMenuItem(number: self.currentSeat, menuItemUID: uid)
                    }
                }
            }
        }
    }
    
    func addMenuItemToCheckin(checkin: String, menuItemUID: String)
    {
//        self.presenter.addMenuItemToCheckin(checkinUID: checkin, menuItemUID: menuItemUID) {
//            print("**** ADD MENU ITEM TO CHECKIN 1")
//
//        } failure: {
//            print("**** ADD MENU ITEM TO CHECKIN 2")
//        }
        
        let item = OrderItemModel()
        item.Title = self.presenter.getMenuItemTitle(uid: menuItemUID)
        item.UID = UUID().uuidString
        item.isNew = true
        item.CheckinUID = checkin
        item.MenuItemUID = menuItemUID
        item.Price = self.presenter.getMenuItemPrice(uid: menuItemUID)
                
        _unconfirmedOrderItems.append(item)
        
        _reloadCheckins()
        
        
    }
    
    func createCheckinForGuestNumberAndAddMenuItem(number: Int, menuItemUID: String)
    {
        let newCheckin = CheckinModel()
        newCheckin.checkinUid = UUID().uuidString
        newCheckin.tableUid = self.presenter.getTableUID()
        newCheckin.isNew = true
        newCheckin.guestNumber = number
        
        currentCheckinUID = newCheckin.checkinUid
                        
        _unconfirmedCheckins.append(newCheckin)
        
        //---
        
        self.layoutSeats.NewCheckin(checkin: newCheckin)
        
        //---
        
        let item = OrderItemModel()
        item.UID = UUID().uuidString
        item.isNew = true
        item.CheckinUID = newCheckin.checkinUid
        item.MenuItemUID = menuItemUID
        item.Title = self.presenter.getMenuItemTitle(uid: menuItemUID)
        item.Price = self.presenter.getMenuItemPrice(uid: menuItemUID)
        
        _unconfirmedOrderItems.append(item)
        
        layoutSeats.UpdateSeatOrdersItems(number: number)
        
        //---
        
        self.carousel.ReloadCarousel(seatNumber: number, checkinUID: newCheckin.checkinUid)
    }
    
    func getItemByIdx(idx: Int) -> SeatsMenuItemModel
    {
        return self.presenter.getDataItem(idx: idx)
    }
    
    func getItemsCount() -> Int
    {
        return self.presenter.getMenuItemsCount()
    }
}

// MARK: - Extensions -
extension SeatsViewController: SeatsViewProtocol
{

}

extension SeatsViewController: SeatsCarouselDelegate
{
    func getPlaceCurrency() -> String
    {
        return self.presenter.getPlaceCurrency()
    }
    
    func getOrdersData(checkinUID: String, seatNumber: Int) -> [OrderItemModel]
    {
        return _unconfirmedOrderItems.filter({ $0.CheckinUID == checkinUID })
    }
    
    func getSeatColor(number: Int) -> UIColor
    {
        return self.presenter.getCheckinColorByNumber(number: number)
    }
    
    
}

