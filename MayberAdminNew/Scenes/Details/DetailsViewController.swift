//
//  MainViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class DetailsViewController: BaseViewController
{
    var tableView: UITableView = {
        var t = UITableView()
        t.backgroundColor = .clear
        t.separatorColor = UIColor.clear
        t.separatorStyle = .none
        return t
    }()
    
    var buttonAdd: UIButton = {
        var b = UIButton()
        b.setImage(UIImage(named: "detais_add"), for: .normal)
        return  b
    }()
    
    
    // MARK: - Public properties -
    var presenter: DetailsPresenterProtocol!

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
//        Logger.log("\(type(of: self))")
        
        super.viewDidLoad()
        
        setupView()
        
//        var a = DetailsCoverCell.self
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true

//        print("*** CURRENT MENU ITEM \(self.presenter.getCurrentMenuItemUID())")
        
        self.presenter.reloadData()
        self.tableView.reloadData()
    }

    // MARK: - Constraints -
    override func updateViewConstraints()
    {
        if (!didSetupConstraints)
        {       
            tableView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            buttonAdd.snp.makeConstraints { make in
                make.width.height.equalTo(48)
                make.left.equalToSuperview().offset(18)
                make.bottom.equalToSuperview().offset(-46)
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

        self.view.addSubview(tableView)
        
        self.view.addSubview(buttonAdd)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(DetailsCoverCell.self, forCellReuseIdentifier: "coverCell")
        tableView.register(DetailsInfoCell.self, forCellReuseIdentifier: "infoCell")
        tableView.register(DetailsRecipeCell.self, forCellReuseIdentifier: "recipeCell")
        tableView.register(DetailsModifiersCell.self, forCellReuseIdentifier: "modifiersCell")
        tableView.register(DetailsCookingTimeCell.self, forCellReuseIdentifier: "cookingCell")
        tableView.register(DetailsCaloriesCell.self, forCellReuseIdentifier: "caloriesCell")
        tableView.register(DetailsEmptyCell.self, forCellReuseIdentifier: "emptyCell")

        buttonAdd.addAction {
            self.addMenuItem()
        }
    }

    func addMenuItem()
    {
        print("*** addMenuItem")
        
        let uid = self.presenter.getCurrentMenuItemUID()
        
        NotificationCenter.default.post(name: Constants.Notify.DetailsAddMenuItem, object: nil, userInfo: ["menu_item_uid": uid])
        
        self.presenter.GoBack()
    }
}

// MARK: - Extensions -
extension DetailsViewController: DetailsViewProtocol, UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        print("*** DetailsViewController numberOfRowsInSection \(self.presenter.getItemsCount())")
        
        return self.presenter.getItemsCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let data = self.presenter.getDataItem(idx: indexPath.row)
        
//        print("*** DetailsViewController heightForRowAt \(data.getHeight())")
        
        return data.getHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let data = self.presenter.getDataItem(idx: indexPath.row)
        
        switch(data.getType())
        {
        case "cover":
            let cell = tableView.dequeueReusableCell(withIdentifier: "coverCell", for: indexPath) as! DetailsCoverCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.delegate = self
            cell.Configure(data: data)
            return cell
        case "info":
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! DetailsInfoCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.Configure(data: data)
            return cell
        case "recipe":
            let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as! DetailsRecipeCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.Configure(data: data)
            return cell
        case "modifiers":
            let cell = tableView.dequeueReusableCell(withIdentifier: "modifiersCell", for: indexPath) as! DetailsModifiersCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)            
            cell.Configure(data: data)
            return cell
        case "cooking":
            let cell = tableView.dequeueReusableCell(withIdentifier: "cookingCell", for: indexPath) as! DetailsCookingTimeCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.Configure(data: data)
            return cell
        case "calories":
            let cell = tableView.dequeueReusableCell(withIdentifier: "caloriesCell", for: indexPath) as! DetailsCaloriesCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.Configure(data: data)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as! DetailsEmptyCell
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {

    }
}

extension DetailsViewController: DetailsCoverCellDelegate
{
    func DetailsCoverCellDelegateGetNextItem()
    {
//        print("*** DetailsCoverCellDelegateGetNextItem")
        
        let next = self.presenter.GetNextItem()
        
        if(!next.isEmpty)
        {
            self.presenter.setCurrentMenuItemUID(uid: next)
            self.presenter.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func DetailsCoverCellDelegateGetPrevItem()
    {
//        print("*** DetailsCoverCellDelegateGetPrevItem")
        
        let prev = self.presenter.GetPrevItem()
        
        if(!prev.isEmpty)
        {
            self.presenter.setCurrentMenuItemUID(uid: prev)
            self.presenter.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func DetailsCoverCellDelegateGetPrevCategory()
    {
        
    }
    
    func DetailsCoverCellDelegateGetNextCategory()
    {
        
    }
    
    func DetailsCoverCellDelegateBack()
    {
        print("*** DetailsCoverCellDelegateBack")
        
        self.presenter.GoBack()
    }
    
    func DetailsCoverCellDelegateGetCountInTheCategory() -> [Int]
    {
        let itemsCount = self.presenter.getItemsInCategory()
        
        let currentPosition = self.presenter.getCurrentItemPositionInCategory()
        
        return [itemsCount, currentPosition]
    }
}
