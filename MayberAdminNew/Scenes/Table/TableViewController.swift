
//
//  MainViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import Alamofire
import AVKit
import AVFoundation

final class  TableViewController: BaseViewController
{
    var addMenu: TableMenuCollection?
    private lazy var tableOrderItemCellIdentifier = "tableOrderItemCell"
    
    private lazy var availableToDropCellIdentifier = "availableToDropCell"
    
    private lazy var tableOrderHeaderIdentifier = "tableOrderHeader"
    
    private lazy var data: [TableOrderModel] = [TableOrderModel]()
    
    private lazy var hiddenOrderItems: [NSNumber : [TableOrderItemModel]] = [NSNumber : [TableOrderItemModel]]()

    var topPanel: TableTopPanel = {
        var p = TableTopPanel()
        return p
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.itemSize = CGSize(width: ScreenSize.SCREEN_WIDTH / 2, height: 140)
        collectionViewFlowLayout.headerReferenceSize = CGSize(width: 0, height: 74)
                
        var cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        cv.backgroundColor = UIColor.black
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.reorderingCadence = .immediate
        cv.layoutMargins = UIEdgeInsets.zero
        
        cv.dragInteractionEnabled = true
        cv.reorderingCadence = .immediate
        return cv
    }()

    
    let buttonConfirm: UIButton = {
        var btnConfirm = UIButton()
        btnConfirm.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        btnConfirm.setTitle("CONFIRM", for: .normal)
        btnConfirm.backgroundColor = UIColor(red: 184/255, green: 161/255, blue: 94/255, alpha: 1)
        btnConfirm.layer.cornerRadius = 20.0
        btnConfirm.layer.masksToBounds = true
        btnConfirm.isHidden = true
        return btnConfirm
    }()
    
    let buttonSend: UIButton = {
        var btnSend = UIButton()
        btnSend.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        btnSend.setTitle("SEND", for: .normal)
        btnSend.backgroundColor = UIColor(red: 184/255, green: 161/255, blue: 94/255, alpha: 1)
        btnSend.layer.cornerRadius = 20.0
        btnSend.layer.masksToBounds = true
        btnSend.isHidden = true
        return btnSend
    }()
    
    // MARK: - Public properties -
    var presenter: TablePresenterProtocol!

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
        super.viewDidLoad()
                                   
        addObservers()
        setupData()
        setupView()
        
        
        print("*** TableViewController \(self.presenter.getTableUID())")
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupData()
    {
        data = [TableOrderModel]()
        
        
        for section in 0 ..< self.presenter.getOrdersCount()
        {
            let order: TableOrderModel = self.presenter.getOrderData(order: section)
            data.append(order)
        }
    }
    
    func updatePresenterData(sourceSection: Int, destinationSection: Int)
    {
        let sourceOrderModel: TableOrderModel = presenter.getOrderData(order: sourceSection)
        let destinationOrderModel: TableOrderModel = presenter.getOrderData(order: destinationSection)
        
        sourceOrderModel.Items.removeAll()
        destinationOrderModel.Items.removeAll()
        
        for item in  0..<data[sourceSection].Items.count
        {
            let orderItem:TableOrderItemModel = data[sourceSection].Items[item]
            
            if (orderItem.itemDraggableType == .simple)
            {
                sourceOrderModel.Items.append(orderItem)
            }
        }
        
        for item in  0..<data[destinationSection].Items.count
        {
            let orderItem:TableOrderItemModel = data[destinationSection].Items[item]
            
            if (orderItem.itemDraggableType == .simple)
            {
                destinationOrderModel.Items.append(orderItem)
            }
        }
    }
    
    func addObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerCheckinsReload(_:)), name: Constants.Notify.Checkins, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerOrderItemsReload(_:)), name: Constants.Notify.OrderItem, object: nil)
    }
    
    @objc func observerCheckinsReload(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
                        
            print("*** observerCheckinsReload")
            
            guard
                let userInfo = notification.userInfo,
                let tableUid = userInfo["tableUid"] as? String,
                let checkinUid = userInfo["checkinUid"] as? String
            else
            {
                return
            }
            
            if(self!.presenter.IfTableUID(tableUid))
            {
                self!.reloadData()
                
                guard let addMenu = self!.addMenu else {
                    return
                }

                if(addMenu.getCurrentCheckin() == checkinUid)
                {
                    let order = self!.presenter.getOrderDataByCheckinUID(checkinUID: checkinUid)
                    
                    addMenu.reloadAmount(amount: order.TotalAmount, currency: self!.presenter.getPlaceCurrency())
                }
            }
        }
    }
    
    @objc func observerOrderItemsReload(_ notification: NSNotification)
    {
        DispatchQueue.main.async { [weak self] in
            print("*** observerOrderItemsReload 1")
            
            guard
                let userInfo = notification.userInfo,
                let order_item_uid = userInfo["uid"] as? String,
                let checkin_uid = userInfo["checkin_uid"] as? String
            else
            {
                return
            }

            if(self!.presenter.IfInCheckinUID(checkin_uid))
            {
                print("*** observerOrderItemsReload 2")
                self!.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        
        reloadData()
    }
    
    func setVisibilityActionButtons()
    {
        buttonSend.isHidden = true
        buttonConfirm.isHidden = true
        
        if(self.presenter.IsNewOrderItems())
        {
            buttonConfirm.isHidden = false
        }
        else if(self.presenter.IsOnlyConfirmedOrderItems())
        {
            buttonSend.isHidden = false
        }
    }
    
    func reloadData()
    {
        self.presenter.ReloadData()
        
        topPanel.Update(tableName: self.presenter.GetTableName(), amount: self.presenter.GetTotalOrdersAmount(), currency: self.presenter.getPlaceCurrency())
        
        setVisibilityActionButtons()
        
        setupData()
        
        self.collectionView.reloadData()
    }

    // MARK: - Constraints -
    override func updateViewConstraints()
    {
        if (!didSetupConstraints)
        {
            topPanel.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(98)
            }
            
            collectionView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalTo(self.topPanel.snp.bottom)
                make.bottom.equalToSuperview()
            }
                                    
            buttonConfirm.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-48)
                make.height.equalTo(40)
                make.width.equalTo(148)
                make.centerX.equalToSuperview()
            }
                                                            
            buttonSend.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-48)
                make.height.equalTo(40)
                make.width.equalTo(148)
                make.centerX.equalToSuperview()
            }
                        
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    // MARK: - Methdos -
    func setupView()
    {
        view.setNeedsUpdateConstraints()

        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(topPanel)
        
        self.view.addSubview(collectionView)
        
        self.view.addSubview(buttonConfirm)
        
        self.view.addSubview(buttonSend)
        
        buttonSend.addTarget(self, action: #selector(sendOrders), for: .touchUpInside)
        
        buttonConfirm.addTarget(self, action: #selector(confirmOrders), for: .touchUpInside)
        
        self.topPanel.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        collectionView.register(TableOrderItemCell.self, forCellWithReuseIdentifier: tableOrderItemCellIdentifier)
        collectionView.register(AvailableToDropCell.self, forCellWithReuseIdentifier: availableToDropCellIdentifier)
        collectionView.register(TableOrderHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: tableOrderHeaderIdentifier)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func sendOrders(_ sender: AnyObject)
    {
        prepareToSend()
    }
    
    @objc func confirmOrders(_ sender: AnyObject)
    {
//        NotificationCenter.default.post(name: Constants.Notify.OrderConfirmItems, object: self)
//
//        self.buttonConfirm.isHidden = true
//
//        self.buttonSend.isHidden = false
        
        let loader = MayberLoader(title: "Confirming orders...")
        self.view.addSubview(loader)

        loader.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.presenter.sendOrderItemsToConfirm {
            loader.snp.removeConstraints()
            loader.removeFromSuperview()
        } failure: { error in
            loader.snp.removeConstraints()
            loader.removeFromSuperview()
        }
    }

    private func prepareToSend()
    {
//
        let actionSheet = UIAlertController(title: nil, message: "Send to kitchen", preferredStyle: .actionSheet)

        if #available(iOS 13.0, *) {
            actionSheet.overrideUserInterfaceStyle = .dark
        }

        //--
        
        
        let sendBarAction = UIAlertAction(title: "Send bar", style: .default, handler: { (UIAlertAction) in

        })
        sendBarAction.isEnabled = false

        actionSheet.addAction(sendBarAction)
        
        //---

        let sendSelectedAction = UIAlertAction(title: "Send selected", style: .default, handler: { (UIAlertAction) in

        })
        sendSelectedAction.isEnabled = false

        actionSheet.addAction(sendSelectedAction)
        
        //---

        let sendBarSelectedAction = UIAlertAction(title: "Send bar and selected", style: .default, handler: { (UIAlertAction) in

        })

        actionSheet.addAction(sendBarSelectedAction)
        
        //----

        let sendAllAction = UIAlertAction(title: "SEND ALL", style: .default, handler: { (UIAlertAction) in
//            actionSheet.dismiss(animated: true, completion: nil)

//            self.sendAllToConfirm()
        })

        actionSheet.addAction(sendAllAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelAction)

        self.present(actionSheet, animated: true)
    }
    
    func sendAllToConfirm()
    {
        print("*** sendAllToConfirm 1")
        
        
        let bg = MayberLoader(title: "Waiting for a while...")
        self.view.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.left.right.bottom.equalToSuperview()
        }
        
        //----
        
        self.presenter.sendOrderItemsToConfirm {
            print("*** sendAllToConfirm 2")
            
            bg.snp.removeConstraints()
            bg.removeFromSuperview()
        } failure: { error in
            print("*** sendAllToConfirm 3")
            
            bg.snp.removeConstraints()
            bg.removeFromSuperview()
        }
    }
}

// MARK: - Extensions -
extension TableViewController: TableViewProtocol
{
    func showNotifyMoveOrderItem()
    {
        let infoHint = InfoHint(title: "Order item move to other checkin")
        infoHint.toCenterX(self.view)
        infoHint.setY(10, relative: topPanel)
        self.view.addSubview(infoHint)
        
        infoHint.Show()
    }
}

extension TableViewController: TableTopPanelDelegate
{
    func TableTopPanelDelegateBackAction()
    {
//        print("*** TableViewController TableTopPanelDelegateBackAction")
        self.presenter.GoBack()
    }
    
    func TableTopPanelDelegateMapAction()
    {
//        print("*** TableViewController TableTopPanelDelegateMapAction")
        self.presenter.GoToMap()
    }
}

extension TableViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate
{
    // MARK: -
    // MARK: - UICollectionViewDragDelegate
    
    func fakeOrderItemModel() -> TableOrderItemModel
    {
        let tableOrderItemModel: TableOrderItemModel = TableOrderItemModel.init()
        tableOrderItemModel.itemDraggableType = .availableToDrop
        return tableOrderItemModel
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = data[indexPath.section].Items[indexPath.row]
        
        if (data[indexPath.section].Items.count == 1)
        {
            var itemsToInsert = [IndexPath]()
            itemsToInsert.append(IndexPath(item: 1, section: indexPath.section))
            data[indexPath.section].Items.append(fakeOrderItemModel())
            collectionView.insertItems(at: itemsToInsert)
        }
        
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
    {
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = data[indexPath.section].Items[indexPath.row]
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession)
    {
        var itemsToInsert = [IndexPath]()
        
        for section in 0 ..< data.count
        {
            if (data[section].Items.isEmpty == true)
            {
                itemsToInsert.append(IndexPath(item: 0, section: section))
                data[section].Items.append(fakeOrderItemModel())
            }
            else if (data[section].Items.count % 2 != 0)
            {
                itemsToInsert.append(IndexPath(item: data[section].Items.count, section: section))
                data[section].Items.append(fakeOrderItemModel())
            }
        }
        collectionView.insertItems(at: itemsToInsert)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession)
    {
        var removeItems = [IndexPath]()
        
        for section in 0 ..< data.count
        {
            for item in  0..<data[section].Items.count
            {
                switch data[section].Items[item].itemDraggableType
                {
                case .availableToDrop: removeItems.append(IndexPath(item: item, section: section))
                case .simple: break
                }
            }
        }
        
        removeItems.forEach { data[$0.section].Items.remove(at: $0.item) }
        collectionView.deleteItems(at: removeItems)
   }
    
    // MARK: -
    // MARK: - UICollectionViewDropDelegate
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
    {
        print("*** canHandle")
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
    {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath
        {
            destinationIndexPath = indexPath
        }
        else
        {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .move:
            reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
        case .copy:
            copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        default: return
        }
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        
        if  items.count == 1, let item = items.first,
            let sourceIndexPath = item.sourceIndexPath,
            let localObject = item.dragItem.localObject as? TableOrderItemModel {
            
            collectionView.performBatchUpdates ({ [weak self] in
                guard let strSelf = self else {return}
                strSelf.data[sourceIndexPath.section].Items.remove(at: sourceIndexPath.item)
                strSelf.data[destinationIndexPath.section].Items.insert(localObject, at: destinationIndexPath.item)
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
            
            self.showNotifyMoveOrderItem()
            
            updatePresenterData(sourceSection: sourceIndexPath.section, destinationSection: destinationIndexPath.section)
        }
    }
    
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        collectionView.performBatchUpdates({
            
            var indexPaths = [IndexPath]()
            
            for (index, item) in coordinator.items.enumerated()
            {
                if let localObject = item.dragItem.localObject as? TableOrderItemModel
                {
                    let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                    data[indexPath.section].Items.insert(localObject, at: indexPath.row)
                    indexPaths.append(indexPath)
                }
            }
            
            collectionView.insertItems(at: indexPaths)
        })
    }
    
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
    {
        if collectionView.hasActiveDrag, let destinationIndexPath = destinationIndexPath
        {
            switch data[destinationIndexPath.section].Items[destinationIndexPath.row].itemDraggableType
            {
            case .simple:
                return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            case .availableToDrop:
                return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
            }
        }
        else
        {
            return UICollectionViewDropProposal(operation: .forbidden)
            
        }
    }
}

extension TableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
//        print("*** TableViewController numberOfSections \(self.presenter.getOrdersCount())")
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        print("*** TableViewController numberOfItemsInSection \(self.presenter.getOrderItemsCount(order: section))")
        return data[section].Items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch data[indexPath.section].Items[indexPath.item].itemDraggableType
        {
        case .simple:
            let item = data[indexPath.section].Items[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tableOrderItemCellIdentifier, for: indexPath) as? TableOrderItemCell
            cell?.delegate = self
            cell?.Configure(item: item)
            return cell!
        case .availableToDrop:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: availableToDropCellIdentifier, for: indexPath) as! AvailableToDropCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if(kind == UICollectionView.elementKindSectionHeader)
        {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: tableOrderHeaderIdentifier, for: indexPath) as? TableOrderHeader
                        
            let order = self.presenter.getOrderData(order: indexPath.section)

            header?.delegate = self
            header?.indexPath = indexPath
            header?.isVisible = order.isVisible
            header?.animateArrow()
            header?.Configure(title: order.Name, amount: order.TotalAmount, currency: self.presenter.getPlaceCurrency(), checkinUID: order.CheckinUID, leftToPay: order.LeftToPay, status: order.Status)
                        
            return header!
        }
        else
        {
            return UICollectionReusableView()
        }
    }
}

extension TableViewController: TableMenuCollectionDelegate
{
    func showActionForMenuItem(uid: String)
    {
        self.presenter.GoToMenuItemDetails(uid: uid)
    }
        
    func TableMenuCollectionHide()
    {
        self.presenter.ReloadMenuCategories()
    }
    
    func anyMenuActionForMenuItem(uid: String, checkinUID: String, location: CGPoint, size: CGSize)
    {
        print("*** anyMenuActionForMenuItem 1")
        
        self.presenter.AddNewOrderItemToCheckin(menuItemUID: uid, checkinUID: checkinUID) {
            
            print("*** anyMenuActionForMenuItem 2")
        } failure: { error in
            print("*** anyMenuActionForMenuItem 3")
        }
    }
    
    func MenuReloadCategories(menu: SeatsMenuCollection)
    {
        self.presenter.ReloadMenuCategories()
        menu.ReloadData()
    }
    
    func getMenuItemsCount() -> Int
    {
        return self.presenter.getMenuItemsCount()
    }
    
    func getMenuItemByIdx(idx: Int) -> SeatsMenuItemModel
    {
        return self.presenter.getMenuDataItem(idx: idx)
    }
    
    func showMenuCategoryItemsBy(categoryUID: String, menu: SeatsMenuCollection)
    {
        self.presenter.ReloadMenuCategoryItems(categoryUID: categoryUID)
        
        menu.ReloadData()
    }
    
    func searchPanelAnyFind(_ text: String, menu: SeatsMenuCollection)
    {
        self.presenter.ReloadMenuByKeyword(keyword: text)
        
        menu.ReloadData()
    }
}

extension TableViewController: TableOrderItemCellDelegate, TableOrderHeaderDelegate
{
    func tableToggleAction(header:TableOrderHeader, indexPath: IndexPath) {
        let order: TableOrderModel = self.presenter.getOrderData(order: indexPath.section)
        if (order.Items.isEmpty == true) {
            return
        }
        // Переключаем флаг в ордере
        order.isVisible = header.isVisible == true ? false : true
        header.isVisible = order.isVisible

        if (header.isVisible == true) {
            hiddenOrderItems.removeValue(forKey: NSNumber.init(value: indexPath.section))
            data[indexPath.section].Items += order.Items
            collectionView.reloadSections(IndexSet.init(integer: indexPath.section))
        }
        else {
            hiddenOrderItems[NSNumber.init(value: indexPath.section)] = data[indexPath.section].Items
            data[indexPath.section].Items.removeAll()
            collectionView.reloadSections(IndexSet.init(integer: indexPath.section))
        }
    }
    

    func TableOrderItemActionFire(orderItemUID: String, checkinUID: String)
    {
        print("*** TableOrderItemActionFire 1 \(orderItemUID) checkinUID \(checkinUID)")
        
        self.presenter.fireOrderItems(orderItemUID: orderItemUID, checkinUID: checkinUID) {
            
        } failure: { error in
            
        }

    }
    
    func TableOrderHeaderResetAction()
    {
        NotificationCenter.default.post(name: Constants.Notify.OrderResetConfirmItems, object: self)
        
        self.buttonConfirm.isHidden = false
        
        self.buttonSend.isHidden = true
    }
    
    func TableOrderHeaderAddAction(checkinUID: String)
    {
        let order = self.presenter.getOrderDataByCheckinUID(checkinUID: checkinUID)

        addMenu = TableMenuCollection(table: order.TableNumber, guest: order.GuestNumber, amount: order.TotalAmount, currency: self.presenter.getPlaceCurrency(), numberOfDishes: order.Items.count, tableUID: order.TableUID, checkinUID: order.CheckinUID, delegate: self)
        self.view.addSubview(addMenu!)
        
        addMenu!.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.left.right.bottom.equalToSuperview()
        }
                        
        addMenu!.Show()
    }
    
    func TableOrderItemActionDouble(orderItemUID: String, checkinUID: String)
    {
        let bg =  MayberLoader(title: "Waiting for a while...")
        self.view.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.top.left.right.bottom.equalToSuperview()
        }
        
        //----
        
        var data = self.presenter.getOrderItemDataByUID(orderItemUID: orderItemUID, checkinUID: checkinUID)
        
        self.presenter.AddNewOrderItemToCheckin(menuItemUID: data.MenuItemUID, checkinUID: checkinUID) {
            
            print("*** anyMenuActionForMenuItem 2")
            
            bg.snp.removeConstraints()
            bg.removeFromSuperview()
        } failure: { error in
            print("*** anyMenuActionForMenuItem 3")
            
            bg.snp.removeConstraints()
            bg.removeFromSuperview()
        }
    }
    
    func TableOrderItemActionRemove(orderItemUID: String, checkinUID: String)
    {
        print("*** TableOrderItemActionRemove")
        
        
//        self.presenter.RemoveOrderItem(orderItemUID: orderItemUID, checkinUID: checkinUID, beforeExternelRemove: {
//            self.reloadData()
//        })
        
        self.presenter.RemoveOrderItem(orderItemUID: orderItemUID, checkinUID: checkinUID) {
            print("*** TableOrderItemActionRemove 1")
            self.reloadData()
        } success: {
            print("*** TableOrderItemActionRemove 2")
        } failure: { error in
            print("*** TableOrderItemActionRemove 3")
        }

    }
    
    func TableOrderItemActionRestore(orderItemUID: String, checkinUID: String)
    {
        print("*** TableOrderItemActionRestore")
        
        self.presenter.RestoreOrderItem(orderItemUID: orderItemUID, checkinUID: checkinUID, beforeExternelRemove: {
            self.reloadData()
        })
    }
    
    func TableOrderItemActionConfirm(orderItemUID: String, checkinUID: String)
    {
        print("*** TableOrderItemActionConfirm orderItemUID: \(orderItemUID) checkinUID: \(checkinUID)")
        
        self.presenter.addOrderItemToReadyToConfirm(orderItemUID: orderItemUID, checkinUID: checkinUID)
    }
    
    func TableOrderItemActionUnconfirm(orderItemUID: String, checkinUID: String)
    {
        print("*** TableOrderItemActionUnconfirm \(orderItemUID) \(checkinUID)")
        
        self.presenter.removeOrderItemToReadyToConfirm(orderItemUID: orderItemUID, checkinUID: checkinUID)
    }
}


class AvailableToDropCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: ScreenSize.SCREEN_WIDTH / 2, height: 140))
        clipsToBounds = true
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
    }
}


