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

final class OrdersViewController: BaseViewController
{
    var _isObserving = true
    
    var topPanel: OrdersTopPanel = {
        var p = OrdersTopPanel()
        return p
    }()
    
    var tablesView: UITableView = {
        var t = UITableView()
        t.backgroundColor = .clear
        t.separatorColor = UIColor.clear
        t.separatorStyle = .none
        return t
    }()
                
    // MARK: - Public properties -
    var presenter: OrdersPresenterProtocol!

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
//        print("*** OrdersViewController viewDidLoad")
        
        super.viewDidLoad()
        
        addObservers()
                        
        setupView()
        
        self.presenter.reloadOrders()
        
        self.tablesView.reloadData()
        
//        let showCode = TableShowCode()
//        showCode.Configure(code: "123", tableUID: UUID().uuidString)
//        self.view.addSubview(showCode)
//
//        showCode.snp.makeConstraints { make in
//            make.width.height.equalToSuperview()
//            make.top.left.right.bottom.equalToSuperview()
//        }
    }
    
    func addObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerCheckinsReload(_:)), name: Constants.Notify.Checkins, object: nil)
    }
    
    @objc func observerCheckinsReload(_ notification: NSNotification)
    {
        DispatchQueue.main.async {
//            Logger.log("*** observerCheckinsReload")
            
//            if(!self._isObserving)
//            {
//                return
//            }
            
            self._reloadData()
        }
    }
    
    func _reloadData()
    {
        self.presenter.reloadOrders()
        
        self.tablesView.reloadData()
        
        self.topPanel.Update(orderCount: self.presenter.getCheckinsCount(),
                             amount: self.presenter.getOorderAmount(),
                             currency: self.presenter.getPlaceCurrency())
        
        let info = InfoHint(title: "Tables has been reloaded")
        info.toCenterX(self.view)
        info.setY(10, relative: topPanel)
        self.view.addSubview(info)

        info.Show()
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
            topPanel.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.view.snp.top)
                make.height.equalTo(98)
            }
            
            tablesView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
                make.top.equalTo(self.topPanel.snp.bottom).offset(15)
                make.bottom.equalTo(self.view.snp.bottom)
            }
                        
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

    // MARK: - Methdos -
    func setupView()
    {
        view.setNeedsUpdateConstraints()

        self.view.backgroundColor = UIColor(red: 229/255, green: 230/255, blue: 234/255, alpha: 1)
        
        self.view.addSubview(topPanel)
        
        self.view.addSubview(tablesView)
        
        tablesView.dataSource = self
        tablesView.delegate = self
        
        tablesView.register(OrdersCell.self, forCellReuseIdentifier: "ordersCell")
        
        topPanel.Update(orderCount: self.presenter.getOrdersCount(),
                        amount: self.presenter.getOorderAmount(),
                        currency: self.presenter.getPlaceCurrency()
        )
        

        topPanel.delegate = self
    }
}

extension OrdersViewController:  UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        print("*** OrdersViewController numberOfRowsInSection \(self.presenter.getOrdersCount())")
        return self.presenter.getOrdersCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 158
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let data = self.presenter.getDataItem(idx: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ordersCell", for: indexPath) as! OrdersCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        cell.delegate = self
        cell.Configure(item: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        print("*** OrdersViewController didSelectItemAt")
        
        let data = self.presenter.getDataItem(idx: indexPath.row)
        
        self.presenter.OpenTable(tableUID: data.TableUID, prev: "orders")
    }
    
    func CloseOrderAsWithProblems(tableUID: String, comment: String)
    {
        var loader: MayberLoader!
        
        DispatchQueue.global(qos: .userInteractive).async {
            loader = MayberLoader(title: "Closing checkins with problems...")
            self.view.addSubview(loader)

            loader.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        
        self._isObserving = false
        
        self.presenter.CloseCheckinsAsPaidByTableUID(tableUID: tableUID, leftUnpaid: true, payedByCash: true, comment: comment)
        {
            self._isObserving = true
            self._reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                loader.snp.removeConstraints()
                loader.removeFromSuperview()
            }
        } finishWithError: {
            self._isObserving = true
            self._reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                loader.snp.removeConstraints()
                loader.removeFromSuperview()
            }
        }
    }
    
    func CloseOrderAsPaidClient(tableUID: String)
    {
        let loader = MayberLoader(title: "Closing checkins with client payment...")
        self.view.addSubview(loader)

        loader.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self._isObserving = false
        
        self.presenter.CloseCheckinsAsPaidByTableUID(tableUID: tableUID, leftUnpaid: false, payedByCash: false, comment: "Closing checkins with client payment")
        {
            self._isObserving = true
            self._reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                loader.snp.removeConstraints()
                loader.removeFromSuperview()
            }
        } finishWithError: {
            self._isObserving = true
            self._reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                loader.snp.removeConstraints()
                loader.removeFromSuperview()
            }
        }
    }
    
    func CloseOrderAsPaid(tableUID: String)
    {
        let loader = MayberLoader(title: "Closing checkins with cash payment...")
        self.view.addSubview(loader)

        loader.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self._isObserving = false
        
        self.presenter.CloseCheckinsAsPaidByTableUID(tableUID: tableUID, leftUnpaid: false, payedByCash: true, comment: "Closing checkins with cash payment")
        {
            self._isObserving = true
            self._reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                loader.snp.removeConstraints()
                loader.removeFromSuperview()
            }
        } finishWithError: {
            self._isObserving = true
            self._reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                loader.snp.removeConstraints()
                loader.removeFromSuperview()
            }
        }
    }
}

// MARK: - Extensions -
extension OrdersViewController: OrdersViewProtocol, OrdersCellDelegate, OrdersTopPanelDelegate
{
    func OrdersTopPanelDelegateSwitchToProfile()
    {
        self.presenter.SwitchToProfile()
    }
    
    func OrdersTopPanelDelegateSwitchToMap()
    {
        self.presenter.SwitchTomap()
    }
    
    func OrdersCellDelegateAction(item: TableOrders)
    {
        let actions = OrderActions(table: item.TableNumber, guests: item.GuestCount, amount: item.AmountTotal, currency: item.AmountTotalCurrency, partyName: item.PartyName, tableUID: item.TableUID)
        actions.delegate = self
        self.view.addSubview(actions)
        
        actions.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        actions.Show()
    }
}

extension OrdersViewController: OrderActionsDelegate
{
    func OrderActionsDelegateCancel()
    {
        
    }
    
    func OrderActionsDelegateProblems(tableUID: String)
    {
        let alert = UIAlertController(title: "Do you have problems?", message: "Describe a problem", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            
            if(textField!.text!.isEmpty)
            {
                self.CloseOrderAsWithProblems(tableUID: tableUID, comment: textField!.text!)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func OrderActionsDelegateOrderPaid(tableUID: String)
    {
        let alert = UIAlertController(title: "Close checkins as paid?", message: "Make sure all orders are paid", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes, i do", style: .default, handler: { (_) in
            self.CloseOrderAsPaid(tableUID: tableUID)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func OrderActionsDelegateCloseCheckIn(tableUID: String)
    {
        let alert = UIAlertController(title: "Close as paid by the client?", message: "Make sure all orders are paid", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes, i do", style: .default, handler: { (_) in
            self.CloseOrderAsPaidClient(tableUID: tableUID)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

