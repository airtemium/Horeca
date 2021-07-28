//
//  MapViewController.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import Foundation
import UIKit

final class  MapViewController: BaseViewController, MapTopPanelDelegate
{
    var _isObserving = true
    
    var _debugEdit = false
    
    var wheelAction: UIView!
    
    var _lastClearTablePoint: CGPoint = .zero
    
    private var _selectedUID = ""
    
    // MARK: - Public properties -
    public var presenter: MapPresenterProtocol!
    
    // MARK: - Private properties -
    private let scrollView = UIScrollView()
    
    private let schemeView = UIView()
    
    private var tableViews = [TableView]()
    
    private var _unconfirmedTables = [TableView]()
    {
        didSet {
            setConfirmButtonStatus()
        }
    }
    
    private var _deletedTablesUIDs = [String]()
    {
        didSet
        {
            setConfirmButtonStatus()
            
            print("*** _deletedTablesUIDs COUNT \(_deletedTablesUIDs.count)")
        }
    }


    private let mapBackgroundColor = UIColor(patternImage: UIImage(named: "mapBackground") ?? UIImage())
    
    private var maxWidth: CGFloat = 428.0 * 2
    
    private var maxHeight: CGFloat = 926.0 * 2
    
    var currentAngle = CGFloat(0.0)
    
    var currentAngleDelta = CGFloat(0.0)
    
    var topPanel: MapTopPanel = {
        var p = MapTopPanel()
        return p
    }()
//
    var showWheelicon: UIImageView = {
        var i = UIImageView()
        i.tag = 5002
        i.isHidden = true
        i.image = UIImage(named: "map_icon_rotate")
        return i
    }()
    
    var buttonEdit: UIButton = {
        var b = UIButton()
        b.backgroundColor = UIColor.white.withAlphaComponent(0.75)
        b.setTitle("EDIT", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.layer.cornerRadius = 10
        return b
    }()
    
    var editPanel: MapEditPanel = {
        var e = MapEditPanel()
        e.isHidden = true
        return e
    }()
    
    var wheel: UIImageView!
        
    //---
    
    var buttonCancel: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.setImage(UIImage(named: "map_button_cancel"), for: .normal)
        return b
    }()
    
    var buttonDelete: MapDeleteView = {
        var b = MapDeleteView(originSize: 48)
        b.isHidden = true
//        b.setImage(UIImage(named: "map_button_delete"), for: .normal)
        return b
    }()

    var buttonConfirm: UIButton = {
        var b = UIButton()
        b.isHidden = true
        b.alpha = 0.5
        b.isEnabled = false
        b.setImage(UIImage(named: "map_button_confirm"), for: .normal)
        return b
    }()
    
    //---
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let id = self.presenter.GetID()
        
        print("*** MapViewController ID \(id) *** viewDidLoad *** \(ScreenSize.SCREEN_WIDTH) *** \(ScreenSize.SCREEN_HEIGHT)")
        
        setupView()
        
        addObservers()
        
        loadData(forced: false)

    }
    
    func setConfirmButtonStatus()
    {
        var isActive = false
        
        if(_unconfirmedTables.count > 0)
        {
            isActive = true
        }
        
        if(_deletedTablesUIDs.count > 0)
        {
            isActive = true
        }
        
        if(isActive)
        {
            buttonConfirm.isEnabled = true
            buttonConfirm.alpha = 1
        }
        else
        {
            buttonConfirm.isEnabled = false
            buttonConfirm.alpha = 0.5
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        print("*** MapViewController viewWillAppear")
        
        navigationController?.navigationBar.isHidden = true
        
        schemeView.layoutSubviews()

        topPanel.Update(orderCount: self.presenter.getOrdersCount(),
                        amount: self.presenter.getOorderAmount(),
                        currency: self.presenter.getPlaceCurrency()
        )
                
        if(_debugEdit)
        {
            _showEdit()
        }
        
//        setWheelRotation(angle: 15)
    }
    
    func addObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(observerTables(_:)), name: Constants.Notify.Tables, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(observerCheckinsAll(_:)), name:  Constants.Notify.CheckinsAll, object: nil)
    }

    @objc func observerTables(_ notification: NSNotification)
    {
        print("*** observerTables")
        
        DispatchQueue.main.async {

//            if(!self._isObserving)
//            {
//                return
//            }
            
            self._reloadData()
        }
    }
    
    private func _reloadData()
    {
        self.clearTableSelection()

        self.removeAllTables()

        self.loadData(forced: true)

        self.didReloadTables()
        
        self.topPanel.Update(orderCount: self.presenter.getOrdersCount(),
                             amount: self.presenter.getOorderAmount(),
                             currency: self.presenter.getPlaceCurrency()
        )
    }
    
    @objc func observerCheckinsAll(_ notification: NSNotification)
    {
        print("*** observerCheckinsAll")
        DispatchQueue.main.async {

//            if(!self._isObserving)
//            {
//                return
//            }
            
            self._reloadData()
        }
    }

    // MARK: - Constraints
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
            
            buttonEdit.snp.makeConstraints { make in
                make.width.equalTo(160)
                make.height.equalTo(45)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-40)
            }
            
            buttonCancel.snp.makeConstraints { make in
                make.width.height.equalTo(48)
                make.left.equalToSuperview().offset(16)
                make.top.equalToSuperview().offset(55)
            }
            
            buttonConfirm.snp.makeConstraints { make in
                make.width.height.equalTo(48)
                make.right.equalToSuperview().offset(-16)
                make.top.equalToSuperview().offset(55)
            }
            
//            buttonDelete.snp.makeConstraints { make in
//                make.width.height.equalTo(48)
//                make.centerX.equalTo(ScreenSize.SCREEN_WIDTH / 2)
//                make.top.equalToSuperview().offset(55)
//            }
//
//            buttonDeleteConfirm.snp.makeConstraints { make in
//                make.width.equalTo(155)
//                make.height.equalTo(45)
//                make.centerX.equalToSuperview()
//                make.top.equalToSuperview().offset(55)
//            }
                        
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func MapTopPanelDelegateGoToOrdersAction()
    {
        self.presenter.switchToOrdersController()
    }
    
    func MapTopPanelDelegateGoToProfile()
    {
        self.presenter.GoToProfile()
    }
    
    func rotationWheelDelegate(angle: CGFloat)
    {
        print("*** rotationWheelDelegate \(angle)")
        
        let n_angle: CGFloat = angle
        
        if(!self._selectedUID.isEmpty)
        {
            if let idx = _unconfirmedTables.firstIndex(where: { $0.table.uid ==  _selectedUID })
            {
                _unconfirmedTables.remove(at: idx)

            }
            
            if let table = tableViews.first(where: { $0.table.uid == _selectedUID })
            {
                table.RotateContainer(angle: n_angle)
                
                _unconfirmedTables.append(table)
            }
            
            
//            if let table = _unconfirmedTables.first(where: { $0.table.uid == _selectedUID })
//            {
//                table.RotateContainer(angle: n_angle)
//            }
            
            
//            self.editPanel.RotateTableByType(type: table.table.typeString, angle: n_angle)
            



//            _unconfirmedTables.append(table)
        }
        else
        {
            
        }
        
//        self.editPanel.RotateAllTables(angle: n_angle)
        
        self.editPanel.RotateCentralTable(angle: n_angle)
    }
}

extension MapViewController: MapEditPanelDelegate
{
    func setWheelRotation(angle: CGFloat)
    {
        print("*** setWheelRotation \(angle)")

        let n = 360 - angle

        let angle = CGFloat(.pi * n / 180.0)

        print("*** setWheelRotation2 \(angle)")

        UIView.animate(withDuration: 0.25) {

            self.wheel.transform = CGAffineTransform(rotationAngle: angle)
//        self.wheel.setSize(ScreenSize.SCREEN_WIDTH + 16, ScreenSize.SCREEN_WIDTH + 16)
        }
    }
    
//    func rotateWheelToCurrentAngle()
//    {
//        let angle = CGFloat(.pi * currentAngle / 180.0)
//        wheel.transform = CGAffineTransform(rotationAngle: angle)
//
//        //self.wheel.transform = CGAffineTransform(rotationAngle: angle)
//    }
    
//    func hideWheel()
//    {
//        self.wheel.setSize(ScreenSize.SCREEN_WIDTH + 16, ScreenSize.SCREEN_WIDTH + 16)
//
//
//        let x = self.wheel.center.x
//        let y = self.wheel.center.y
//
//        UIView.animate(withDuration: 0.2) {
//            self.wheel.alpha = 0
//            self.wheel.setSize(10, 10)
//            self.wheel.center.x = x
//            self.wheel.center.y = y
//        } completion: { success in
//            self.wheel.isHidden = true
//        }
//
//        self.wheel.isUserInteractionEnabled = false
//
//        let angle = CGFloat(.pi * 0 / 180.0)
//        wheel.transform = CGAffineTransform(rotationAngle: angle)
//
//        currentAngle = CGFloat(0.0)
//        currentAngleDelta = CGFloat(0.0)
//
//        for recognizer in wheel.gestureRecognizers ?? []
//        {
//            wheel.removeGestureRecognizer(recognizer)
//        }
//    }
        
    @objc func wheelRotate(gesture: KTOneFingerRotationGestureRecognizer)
    {
        let angleRad = gesture.rotation
//
//        print("*** KTOneFingerRotationGestureRecognizer ")
////        print(angleRad)
//
        if abs(angleRad) > 0.2
        {
//            self.hideWheel()
            return
        }

        let grad: CGFloat = round(angleRad * 180.0 / CGFloat(Double.pi))

        if (abs(currentAngleDelta) < 0.1) && (abs(currentAngle.truncatingRemainder(dividingBy: 5.0)) > 0.01)
        {
            // округляем до ближайшего угла, кратного 5, до первого поворота
            currentAngleDelta = currentAngle.truncatingRemainder(dividingBy: 5.0)
            currentAngleDelta += grad

            let newAngle = round(currentAngle / 5.0) * 5.0
            currentAngleDelta -= (newAngle > currentAngle) ? 5.0 : 0.0
            currentAngle = newAngle
            return
        }

        guard abs(currentAngleDelta) >= 5.0 else {
            currentAngleDelta += grad
            return
        }

        currentAngle += round(currentAngleDelta / 5.0) * 5.0

        currentAngleDelta = currentAngleDelta.truncatingRemainder(dividingBy: 5.0)   // % 5.0

        currentAngle = (currentAngle + 360.0).truncatingRemainder(dividingBy: 360.0) // % 360.0

        let angle = CGFloat(.pi * currentAngle / 180.0)

//        print("*** KTOneFingerRotationGestureRecognizer \(angle)")

        UIView.animate(withDuration: 0.1) {

            self.wheel.transform = CGAffineTransform(rotationAngle: angle)
            
//            self.setWheelRotation(angle: self.currentAngle)

            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
//
        rotationWheelDelegate(angle: currentAngle)
    }
    
    func hideWheel()
    {
//        if(!_selectedUID.isEmpty)
//        {
        self.showWheelicon.isHidden = false
//        }
        
        if(self.wheel != nil)
        {
            UIView.animate(withDuration: 0.2) {
    //            self.wheel.setY(ScreenSize.SCREEN_HEIGHT)
                self.wheel.isHidden = true
            } completion: { success in
    //            self.wheel.isHidden = true
                
                self.wheel.removeFromSuperview()
            }
        }
        

    }
    
    func showWheel(finish: @escaping () -> ())
    {
        if(self.wheel != nil)
        {
            self.wheel.removeFromSuperview()
        }
        
        let editPanelCenter = self.editPanel.getCenter()

        self.wheel = UIImageView()
        self.wheel.tag = 5002
        self.wheel.image = UIImage(named: "map_wheel")
        self.wheel.isUserInteractionEnabled = true
        
        self.wheel.setSize(ScreenSize.SCREEN_WIDTH + 16, ScreenSize.SCREEN_WIDTH + 16)
        self.wheel.toCenterX(self.view)
        self.wheel.setY(ScreenSize.SCREEN_HEIGHT)
        self.view.addSubview(wheel)

        let wheelGesture = KTOneFingerRotationGestureRecognizer(target: self, action: #selector(wheelRotate(gesture:)))
        self.wheel.addGestureRecognizer(wheelGesture)
                
        let tapWheel = UITapGestureRecognizer(target: self, action: #selector(self.wheelTap(_:)))
        tapWheel.numberOfTapsRequired = 1
        self.wheel.addGestureRecognizer(tapWheel)
        
        let y = self.editPanel.getY() + editPanelCenter.y - self.wheel.getHeight() / 2
        
        UIView.animate(withDuration: 0.5) {
            self.wheel.setY(y)
        } completion: { success in
            finish()
        }

    }
    
    @objc func wheelTap(_ sender: UITapGestureRecognizer)
    {
        print("*** wheelTap")
        
        self.hideWheel()
    }
    
    @objc func wheelIconAction(_ sender: UISwipeGestureRecognizer)
    {
//        print("*** wheelIconAction 1")
//        if(_selectedUID.isEmpty)
//        {
//            return
//        }
        
        showWheelicon.isHidden = true
        

        
        showWheel() {

            if(!self._selectedUID.isEmpty)
            {
                guard let table = self.tableViews.first(where: { $0.table.uid == self._selectedUID }) else {
                    return
                }
                
                let tableRotation = table.table.parameters.rotation
                
                self.setWheelRotation(angle: CGFloat(tableRotation))
                
                self.editPanel.RotateTableByType(type: table.table.typeString, angle: CGFloat(tableRotation))
//                self.editPanel.RotateAllTables(angle: CGFloat(tableRotation))
            }
            else
            {
                
            }

        }
//
//        print("*** wheelIconAction 2")
//
//        showWheel.isHidden = true
//
//        self.wheel.isHidden = false
//
//        self.wheel.setSize(ScreenSize.SCREEN_WIDTH + 16, ScreenSize.SCREEN_WIDTH + 16)
//
//        UIView.animate(withDuration: 0.25) {
//            self.wheel.center.y = self.editPanel.getY() + self.editPanel.getCenter().y
//
////            self.wheel.setY(0)
////        self.wheel.setX(0)
//            self.wheel.setSize(ScreenSize.SCREEN_WIDTH + 16, ScreenSize.SCREEN_WIDTH + 16)
//        }
    }
    
    func clearTableSelection()
    {
        print("*** clearTableSelection \(_selectedUID)")
        if(!_selectedUID.isEmpty)
        {
            if let oldSelected = self.tableViews.first(where: { $0.table.uid == _selectedUID })
            {
                oldSelected.setSelected(isOn: false)
            }
                        
            if let oldSelected = self._unconfirmedTables.first(where: { $0.table.uid == _selectedUID })
            {
                oldSelected.setSelected(isOn: false)
            }
        }
        
//        hideWheel()
        
        _selectedUID = ""
    }
    
    func getTableByType(type: String) -> TableModel
    {
        return self.presenter.getEmptyTableByType(type: type)
    }
    
    func MapEditPanelDelegateMoveNewtable(type: String, x: CGFloat, y: CGFloat)
    {
        
//        print("*** MapEditPanelDelegateMoveNewtable ")
        
        let newY = (self.editPanel.getY() - (y * -1))

        let newTable = self.presenter.getEmptyTableByType(type: type)
        
        let tableView = TableView(table: newTable, checkins: [], delegate: nil)
        
        let offsetX = tableView.table.parameters.width / 4 //+ self.scrollView.contentOffset.x
        let offsetY = tableView.table.parameters.height / 4 //+ self.scrollView.contentOffset.y
        
        let n_x = Float(x) - offsetX + Float(self.scrollView.contentOffset.x)
        let n_y = Float(newY) - offsetY + Float(self.scrollView.contentOffset.y)
        
        //----
        
        newTable.parameters.x = n_x
        newTable.parameters.y = n_y
        
        tableView.frame = tableView.table.parameters.frame
        
        let draggableFrame = CGRect(x: tableView.center.x - tableView.DragLayout.frame.width / 2,
                                    y: tableView.center.y - tableView.DragLayout.frame.height / 2,
                                    width: tableView.DragLayout.frame.width,
                                    height: tableView.DragLayout.frame.height)
        
        //-----
        
//        let frame = newTable.parameters.frame
        
//
        
        //-----
        
        var isIntersects = false
        
        for i in self.tableViews
        {
            let draggableFrameCompare = CGRect(x: i.center.x - i.DragLayout.frame.width / 2,
                                               y: i.center.y - i.DragLayout.frame.height / 2,
                                               width: i.DragLayout.frame.width,
                                               height: i.DragLayout.frame.height)
            
            if(draggableFrameCompare.intersects(draggableFrame))
            {
                isIntersects = true
            }
        }
        
        for i in self._unconfirmedTables
        {
            let draggableFrameCompare = CGRect(x: i.center.x - i.DragLayout.frame.width / 2 - 10,
                                               y: i.center.y - i.DragLayout.frame.height / 2 - 10,
                                               width: i.DragLayout.frame.width + 10,
                                               height: i.DragLayout.frame.height + 10)
            
            if(draggableFrameCompare.intersects(draggableFrame))
            {
                isIntersects = true
            }
        }
        
        if(!isIntersects)
        {
            _lastClearTablePoint = CGPoint(x: CGFloat(n_x), y: CGFloat(n_y))
        }
    }
    
    func MapEditPanelAddTable(type: String, x: CGFloat, y: CGFloat, rotation: CGFloat)
    {
        print("*** MapEditPanelAddTable 1 rotation \(rotation)")
        
        let newY = (self.editPanel.getY() - (y * -1))

        let newTable = self.presenter.getEmptyTableByType(type: type)
                        
        newTable.parameters.number = 0
        
        self.clearTableSelection()
        
        _selectedUID = UUID().uuidString
        
        let tableView = TableView(table: newTable, checkins: [], delegate: nil)
        tableView.IsNew = true
        tableView.table.uid = _selectedUID
        
                                
        let offsetX = tableView.table.parameters.width / 4 //+ self.scrollView.contentOffset.x
        let offsetY = tableView.table.parameters.height / 4 //+ self.scrollView.contentOffset.y
    
        newTable.parameters.x = Float(x) - offsetX + Float(self.scrollView.contentOffset.x)
        newTable.parameters.y = Float(newY) - offsetY + Float(self.scrollView.contentOffset.y)
        
        tableView.RotateContainer(angle: rotation)
        
        addGestures(tableView: tableView)
 
        _unconfirmedTables.append(tableView)
        
        //----
        

        
        //----
        
        showTable(tableView)
                                                            
        tableView.setSelected(isOn: true)
        
        //----
        
        let draggableFrame = CGRect(x: tableView.center.x - tableView.DragLayout.frame.width / 2,
                                    y: tableView.center.y - tableView.DragLayout.frame.height / 2,
                                    width: tableView.DragLayout.frame.width,
                                    height: tableView.DragLayout.frame.height)
        
        //----
        
        for i in self.tableViews
        {
            let draggableFrameCompare = CGRect(x: i.center.x - i.DragLayout.frame.width / 2,
                                               y: i.center.y - i.DragLayout.frame.height / 2,
                                               width: i.DragLayout.frame.width,
                                               height: i.DragLayout.frame.height)
            
            if(draggableFrameCompare.intersects(draggableFrame))
            {
                UIView.animate(withDuration: 0.15) {
                    tableView.setX(self._lastClearTablePoint.x)
                    tableView.setY(self._lastClearTablePoint.y)
                }
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                
                return
            }
        }
        
        for i in self._unconfirmedTables
        {
            let draggableFrameCompare = CGRect(x: i.center.x - i.DragLayout.frame.width / 2,
                                               y: i.center.y - i.DragLayout.frame.height / 2,
                                               width: i.DragLayout.frame.width,
                                               height: i.DragLayout.frame.height)
            
            if(draggableFrameCompare.intersects(draggableFrame))
            {
                UIView.animate(withDuration: 0.15) {
                    tableView.setX(self._lastClearTablePoint.x)
                    tableView.setY(self._lastClearTablePoint.y)
                }
                
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                
                return
            }
        }
    }
}

// MARK: - Private methods
private extension MapViewController
{
    func setupView()
    {
        view.backgroundColor = #colorLiteral(red: 0.9013465047, green: 0.8757992387, blue: 0.8373508453, alpha: 1)
                
        view.addSubview(scrollView)
        
        self.view.addSubview(topPanel)
        self.view.addSubview(buttonEdit)
        self.view.addSubview(buttonCancel)
        self.view.addSubview(buttonConfirm)
        self.schemeView.addSubview(buttonDelete)
//        self.view.addSubview(buttonDeleteConfirm)
        self.view.addSubview(editPanel)
        
        topPanel.delegate = self
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.bouncesZoom = true
        scrollView.contentSize = CGSize(width: maxWidth, height: maxHeight)
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(view.safeAreaInsets)
        }
        
        var schemeFrame = view.frame
        schemeFrame.size.width = maxWidth
        schemeFrame.size.height = maxHeight
        
        schemeView.frame = schemeFrame
        schemeView.isUserInteractionEnabled = true
        schemeView.backgroundColor = mapBackgroundColor
        scrollView.addSubview(schemeView)
        
        let schemeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.schemeTapGestureAction(_:)))
        schemeView.addGestureRecognizer(schemeTapGesture)
        //---
        
        buttonEdit.addTarget(self, action: #selector(self.enableEditMode(_:)), for: .touchUpInside)
        
//        buttonDelete.addTarget(self, action: #selector(self.editModeDelete(_:)), for: .touchUpInside)
//        buttonDeleteConfirm.addTarget(self, action: #selector(self.editModeDeleteConfirm(_:)), for: .touchUpInside)
        buttonConfirm.addTarget(self, action: #selector(self.editModeConfirm(_:)), for: .touchUpInside)
        buttonCancel.addTarget(self, action: #selector(self.editModeWithoutConfirm(_:)), for: .touchUpInside)
        
        //---
        
        editPanel.setSize(ScreenSize.SCREEN_WIDTH, 154)
        editPanel.setX(0)
        editPanel.setY(ScreenSize.SCREEN_HEIGHT - 154)
        editPanel.delegate = self
        self.view.addSubview(editPanel)
        
        editPanel.Init()
        
        
        
        //---
        
        showWheelicon.setSize(38, 38)
        showWheelicon.toCenterX(self.view)
        showWheelicon.setY(ScreenSize.SCREEN_HEIGHT - 154 - 38 - 15)
        showWheelicon.isUserInteractionEnabled = true
        self.view.addSubview(showWheelicon)

        let showWheelTap = UISwipeGestureRecognizer(target: self, action: #selector(self.wheelIconAction(_:)))
        showWheelTap.direction = .up
        showWheelicon.addGestureRecognizer(showWheelTap)
//
//        //---
//

        //---
        
        
        buttonDelete.tag = self.presenter.getButtonDeleteId()
        buttonDelete.setSize(48, 48)
        buttonDelete.setY(self.scrollView.contentOffset.y + 8)
        buttonDelete.setX(self.scrollView.contentOffset.x + ScreenSize.SCREEN_WIDTH / 2 - 24)
        
        buttonDelete.delegate = self
        
        //---
        

    }
    

    
//    func hideWheel()
//    {
//        showWheel.isHidden = true
//
//        UIView.animate(withDuration: 0.25) {
//            self.wheel.setY(ScreenSize.SCREEN_HEIGHT)
//            self.wheel.setSize(ScreenSize.SCREEN_WIDTH + 16, ScreenSize.SCREEN_WIDTH + 16)
//        } completion: { success in
//            self.wheel.isHidden = true
//        }
//
//    }
    

    
//    @objc func editModeDelete(_ sender: AnyObject)
//    {
//        print("*** editModeDelete \(_selectedUID)")
//
//        if(_selectedUID.isEmpty)
//        {
//            return
//        }
//
//        buttonDelete.isHidden = true
//
////        buttonDeleteConfirm.isHidden = false
//    }
    
    @objc func editModeConfirm(_ sender: AnyObject)
    {
        _selectedUID = ""
        
        _hideEdit()
        
        hideWheel()

        self.presenter.setModeNormal()

        var isEdit = false

        if(_unconfirmedTables.count > 0 || _deletedTablesUIDs.count > 0)
        {
            isEdit = true
        }
        
        if(isEdit)
        {
            
            self._isObserving = false
            
            
            var loader: MayberLoader!
            
//            DispatchQueue.global(qos: .userInteractive).async {
            
                loader = MayberLoader(title: "Waiting for a while...")
                self.view.addSubview(loader)
        
                loader.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
                
//            }
            
            
            
            let dg = DispatchGroup()
            
            var dataToSave = [TableView]()
            
            let deletedUIDs = _deletedTablesUIDs
            
            if(_unconfirmedTables.count > 0)
            {
                for i in _unconfirmedTables
                {
                    dataToSave.append(i)
                }
            }
            
            if(dataToSave.count > 0)
            {
                dg.enter()
                self.presenter.saveTables(data: dataToSave)
                {
                    dg.leave()
                }
                completitionWithError: { error in
                    dg.leave()
                }
            }
            
            if(deletedUIDs.count > 0)
            {
                print("** DELETED UIDS")
                print(deletedUIDs)
                

                dg.enter()
                self.presenter.deleteTables(uids: deletedUIDs)
                {
                    dg.leave()
                }
                completitionWithError: { error in
                    dg.leave()
                }
            }
                        
            dg.notify(queue: DispatchQueue.main)
            {
                
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
                {
                    self._isObserving = true
                    
                    loader.snp.removeConstraints()
                    loader.removeFromSuperview()
                    
                    self._clearEdit()
                    
                    
                    
                    self._reloadData()
                }
            }
        }
        else
        {
            _clearEdit()
        }
    }
    
    private func _clearEdit()
    {
        _unconfirmedTables = [TableView]()
        
        _deletedTablesUIDs = [String]()
        
        self.removeAllTables()

        self.loadData(forced: true)

        self.didReloadTables()
        
        self.showWheelicon.isHidden = true
    }
    
    @objc func editModeWithoutConfirm(_ sender: AnyObject)
    {
        if(!_selectedUID.isEmpty)
        {
//            self.hideWheel()
            
//            self.editPanel.showArrows {
//
//            }
            
            self.clearTableSelection()
                        
            hideWheel()
            
            return
        }
        
        hideWheel()
                
        _hideEdit()
        
        _selectedUID = ""
        
        self.presenter.setModeNormal()
        
        //-----
        
        for i in _unconfirmedTables
        {
            i.removeFromSuperview()
        }
        
        _unconfirmedTables = [TableView]()
                        
        _deletedTablesUIDs = [String]()
        
        //----
        
        
        
        self.removeAllTables()

        self.loadData(forced: true)

        self.didReloadTables()
    }
    
    @objc func enableEditMode(_ sender: AnyObject)
    {
        _showEdit()
        
        self.presenter.setModeEdit()
    }
    
    func loadData(forced: Bool)
    {
        _selectedUID = ""
        
        let placeUid = presenter.getPlace()
        
        showTables(placeUid: placeUid, forced: forced)
    }
    
    func _showEdit()
    {        
        self.presenter.setModeEdit()
        //        return
            
        self.topPanel.isHidden = true
        self.buttonEdit.isHidden = true

        self.buttonCancel.isHidden = false
        self.buttonConfirm.isHidden = false
        self.buttonDelete.isHidden = false
//        self.buttonDeleteConfirm.isHidden = true

        self.editPanel.isHidden = false
        
        self.showWheelicon.isHidden = false
        
        replaceButtonDelete(scale: scrollView.zoomScale)
    }
    
    func _hideEdit()
    {
        self.presenter.setModeNormal()
                        
//        self.editPanel.hideWheels {
        
        self.showWheelicon.isHidden = true
        
        
        self.topPanel.isHidden = false
        self.buttonEdit.isHidden = false
        
        self.buttonCancel.isHidden = true
        self.buttonConfirm.isHidden = true
        self.buttonDelete.isHidden = true
//            self.buttonDeleteConfirm.isHidden = true
        self.editPanel.isHidden = true
//        }
     
        
//        self.hideWheel()
//
//        self.showWheel.isHidden = true
        
        self.showWheelicon.isHidden = true
        
        self.editPanel.RotateAllTables(angle: 0)
    }
    
    @objc func schemeTapGestureAction(_ sender: UITapGestureRecognizer)
    {
//        setWheelRotation(angle: 0)
        
        
//        showWheel()
        
        if(self.presenter.getMode() != .Edit)
        {
            return
        }
        
//        clearTableSelection()
        
        self.hideWheel()
//
//        self.showWheel.isHidden = false
        
        print("*** schemeTapGestureAction")
    }
}

// MARK: - Observers
private extension MapViewController
{

}

// MARK: - Show views
private extension MapViewController
{
    func didReloadTables()
    {
        let info = InfoHint(title: "Tables has been reloaded")
        info.toCenterX(self.view)
        info.setY(10, relative: topPanel)
        self.view.addSubview(info)

        info.Show()
    }
    
    func removeAllTables()
    {
        self.tableViews = [TableView]()
        self._unconfirmedTables = [TableView]()
        
//        self.presenter.setModeNormal()
        
        for i in schemeView.subviews
        {
            if(i.tag >= 5000)
            {
                continue
            }
            
            i.snp.removeConstraints()
            i.removeFromSuperview()
        }
    }
    
    func remakeSchemeSizes(newWidth: CGFloat, newHeight: CGFloat)
    {
        if(newWidth > self.maxWidth || newHeight > self.maxHeight)
        {
            let width: CGFloat = (newWidth > self.maxWidth) ? newWidth + 50 : self.maxWidth
            let height: CGFloat = (newHeight > self.maxHeight) ? newHeight + 50 : self.maxHeight
                        
            scrollView.contentSize = CGSize(width: width, height: height)
            
            schemeView.setSize(width, height)
            
            self.maxWidth = newWidth
            
            self.maxHeight = newHeight
        }
    }
    
    func showTables(placeUid: String, forced: Bool)
    {
        let tables = presenter.getTables(placeUid: placeUid, forced: forced)
         
        if(tables.count > 0)
        {
            let maxOffsetX = tables.max { $0.parameters.x + $0.parameters.width < $1.parameters.x + $1.parameters.width }
            let maxOffsetY = tables.max { $0.parameters.y + $0.parameters.height < $1.parameters.y + $1.parameters.height }
            
            let maxX = maxOffsetX!.parameters.x + maxOffsetX!.parameters.width
            let maxY = maxOffsetY!.parameters.y + maxOffsetY!.parameters.height

            remakeSchemeSizes(newWidth: CGFloat(maxX), newHeight: CGFloat(maxY))
        }
                
        //--
                        
        let checkins = presenter.getCheckins()
                        
        tables.forEach { table in
            let tableCheckins = checkins.filter { $0.tableUid == table.uid }
            let tableView = TableView(table: table, checkins: tableCheckins, delegate: nil)
            
            //let tableView = TableView(table: table)
            addGestures(tableView: tableView)
            tableViews.append(tableView)
            showTable(tableView)
        }
    }
    
    func showTable(_ tableView: TableView)
    {
        var frame = tableView.table.parameters.frame

        tableView.frame = frame
        schemeView.addSubview(tableView)
    }
}

// MARK: - Gestures
private extension MapViewController
{
    func addGestures(tableView: TableView)
    {
        let tapTable = UITapGestureRecognizer(target: self, action: #selector(tableTapHandler(tapGesture:)))
        tapTable.numberOfTapsRequired = 1
        tableView.DragLayout.addGestureRecognizer(tapTable)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.dragTable(_:)))
        tableView.DragLayout.addGestureRecognizer(panGesture)
    }
    
    @objc func dragTable(_ sender: UIPanGestureRecognizer)
    {
//        print("*** dragTable 0 \(self.presenter.getMode())")

        if(self.presenter.getMode() != .Edit)
        {
            return
        }
        
        //---
        
        buttonDelete.isHidden = false
        
//        buttonDeleteConfirm.isHidden = true
        
        //---
        
        guard
            let tableView = sender.view?.superview?.superview as? TableView,
            let table = tableView.table
        else {
            return
        }
        
//        self.view.sendSubviewToBack(<#T##view: UIView##UIView#>)
        
        self.schemeView.bringSubviewToFront(tableView)

        if(sender.state == .began)
        {
            self.clearTableSelection()
                        
            _selectedUID = table.uid
                                    
            tableView.setSelected(isOn: true)
        }

        //---
        
        let translation = sender.translation(in: self.schemeView)
        
        let x = tableView.center.x + translation.x
        let y = tableView.center.y + translation.y
        
        let draggableFrame = CGRect(x: x - tableView.DragLayout.frame.width / 2, y: y - tableView.DragLayout.frame.height / 2, width: tableView.DragLayout.frame.width, height: tableView.DragLayout.frame.height)
        
        //----------
        //----------
        //----------
        
        if let deleteLayout = self.schemeView.viewWithTag(self.presenter.getButtonDeleteId()) as? MapDeleteView
        {
            let deleteFrame = CGRect(
                x: deleteLayout.frame.origin.x - 10,
                y: deleteLayout.frame.origin.y - 10,
                width: deleteLayout.frame.width + 10,
                height: deleteLayout.frame.height + 10)
            
//            self.schemeView.sendSubviewToBack(deleteLayout)
            
            if(deleteFrame.intersects(draggableFrame))
            {
                deleteLayout.focusOn()
                
                if(sender.state == .ended)
                {
                    deleteLayout.actionDelete()
                    
                    return
                    
                    print("*** DELETE STATE END")
                }
            }
            else
            {
                deleteLayout.focusOff()
            }

        }

//        print("** DRAG NEW X \(draggableFrame.minX) Y \(draggableFrame.minY)")
        
        var isIntersect = false
        
//
        if(draggableFrame.minX <= 0 || draggableFrame.minY <= 0)
        {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()

            isIntersect = true
            
            return
        }
        
        for i in self._unconfirmedTables
        {
            if(i.table.uid != table.uid)
            {
                let draggableFrameCompare = CGRect(x: i.center.x - i.DragLayout.frame.width / 2 - 10,
                                                   y: i.center.y - i.DragLayout.frame.height / 2 - 10,
                                                   width: i.DragLayout.frame.width + 10,
                                                   height: i.DragLayout.frame.height + 10)
                
                if(draggableFrameCompare.intersects(draggableFrame))
                {
//                    let generator = UIImpactFeedbackGenerator(style: .heavy)
//                    generator.impactOccurred()
                    
                    isIntersect = true
                    
                    if(sender.state == .ended)
                    {
                        UIView.animate(withDuration: 0.15) {
                            tableView.center = self._lastClearTablePoint
                        }
                        
                        
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                        
                        return
                    }

//                    return
                }
            }

        }
        
        for i in self.tableViews
        {
            if(i.table.uid != table.uid)
            {
                if(_unconfirmedTables.contains(where:{ $0.table.uid == i.table.uid }))
                {
                    continue
                }
                
                let draggableFrameCompare = CGRect(x: i.center.x - i.DragLayout.frame.width / 2,
                                                   y: i.center.y - i.DragLayout.frame.height / 2,
                                                   width: i.DragLayout.frame.width,
                                                   height: i.DragLayout.frame.height)
                
                if(draggableFrameCompare.intersects(draggableFrame))
                {

                    isIntersect = true
                    
                    if(sender.state == .ended)
                    {
                        UIView.animate(withDuration: 0.15) {
                            tableView.center = self._lastClearTablePoint
                        }
                        
                        let generator = UIImpactFeedbackGenerator(style: .heavy)
                        generator.impactOccurred()
                        
                        return
                    }

//                    return
                }
            }

        }

        //---
        
        if(!isIntersect)
        {
            _lastClearTablePoint = CGPoint(x: x, y: y)
        }
                                        
        tableView.center =  CGPoint(x: x, y: y)

        sender.setTranslation(CGPoint.zero, in: self.schemeView)

        if(sender.state == .ended)
        {
//            if(isIntersect)
//            {
//                tableView.center = _lastClearTablePoint
//            }
                        
            
            if !_unconfirmedTables.contains(where: { $0.table.uid == table.uid })
            {
                _unconfirmedTables.append(tableView)
            }
        }
    }
    
    @objc func tableTapHandler(tapGesture: UITapGestureRecognizer)
    {
//        print("*** tableTapHandler")
        
        //_selectedUID
        
        if(self.presenter.getMode() == .Edit)
        {
            buttonDelete.isHidden = false
            
            hideWheel()
            
            self.showWheelicon.isHidden = false
            
//            buttonDeleteConfirm.isHidden = true
            
            guard
                let tableView = tapGesture.view?.superview?.superview as? TableView,
                let table = tableView.table
            else {
                return
            }

            self.clearTableSelection()
                        
            _selectedUID = table.uid
                
            tableView.setSelected(isOn: true)
            
            //--

            editPanel.scrollToTableType(type: table.typeString)
            
            let tableRotation = table.parameters.rotation

            editPanel.RotateTableByType(type: table.typeString, angle: CGFloat(tableRotation))

        }
        
        if(self.presenter.getMode() == .Normal)
        {
//            print("*** tableTapHandler 3")
            
            // showLoader
//            let bg = BaseLoader()
//            view.addSubview(bg)
//            bg.snp.makeConstraints { make in
//                make.edges.equalToSuperview()
//            }
                    
            guard
                let tableView = tapGesture.view?.superview?.superview as? TableView,
                let table = tableView.table
            else {
                return
            }
            
            // get table code
            let areCheckins = presenter.getCode(table: table)
            
            if !areCheckins
            {
                // checkins are not exist => TableShowCode => Seats
                                
                self.tableShowCode(tableUid: table.uid)
            }
            else
            {
//                        Logger.logDebug("==> Seats", "")
                self.presenter.openSeats(tableUid: table.uid)
            }
            
            
//            presenter.getCode(table: table) { [weak self] stateTable in
//
////                Logger.logDebug("state = \(String(describing: stateTable))", "")
//
//                guard let self = self else { return }
//
//                bg.removeFromSuperview()
//
//                if let state = stateTable
//                {
//                    let (code, checkinsAreEmpty) = state
////                    Logger.logDebug("code: \(code), checkinsAreEmpty: \(checkinsAreEmpty)", "")
//
//                    if checkinsAreEmpty
//                    {
//                        // checkins are not exist => TableShowCode => Seats
//                        self.tableShowCode(code, tableUid: table.uid)
//                    }
//                    else
//                    {
////                        Logger.logDebug("==> Seats", "")
//                        self.presenter.openSeats(tableUid: table.uid)
//                    }
//                }
//                else
//                {
////                    Logger.logDebug("No code", "")
//                    //showAlert("No code")
//                }
//            }
        }
    }
}

// MARK: - TableShowCodeDelegate
extension MapViewController: TableShowCodeDelegate
{
    func TableShowCodeDelegateObtainCode(tableUid: String, finish: @escaping (Int) -> ())
    {
        print("*** TableShowCodeDelegateObtainCode")
        
//        finish(123)
        
        self.presenter.getCode(table: tableUid) { code in
            finish(code!)
        }
    }
    
    func tableShowCodeDelegateOKAction(_ sender: TableShowCode?)
    {
        sender?.snp.removeConstraints()
        sender?.removeFromSuperview()
    }
    
    func tableShowCodeDelegateCreateAction(_ sender: TableShowCode?)
    {
        sender?.snp.removeConstraints()
        sender?.removeFromSuperview()
        
        presenter.openSeats(tableUid: sender!.GetTableUID)
    }
//
//    func TableShowCodeDelegateObtainCode(tableUid: String) -> Int
//    {
//        return 0
//    }
//
//    func tableShowCodeDelegateOKAction()
//    {
////        numberView.removeFromSuperview()
//    }
//
//    func tableShowCodeDelegateCreateAction()
//    {
////        let tableUid = numberView.tableUid
////        numberView.removeFromSuperview()
////
////        presenter.openSeats(tableUid: tableUid)
//    }
    
    func tableShowCode(tableUid: String)
    {
        print("*** SHOW CODE")
        
        let numberView = TableShowCode(tableUid: tableUid)//, actionOK: {
        numberView.delegate = self
        
        numberView.Start()
//
//        }, actionCreate: {
//            self.presenter.openSeats(tableUid: tableUid)
//        }, gotNewCode: { code in
//            self.presenter.storeCode(code, tableUid: tableUid)
//        })

        view.addSubview(numberView)

        numberView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func replaceButtonDelete(scale: CGFloat = 0)
    {
        buttonDelete.setY(self.scrollView.contentOffset.y + 55)
        buttonDelete.setX(self.scrollView.contentOffset.x + ScreenSize.SCREEN_WIDTH / 2 - 24)
        
        self.schemeView.bringSubviewToFront(buttonDelete)
    }
}
// MARK: - Scroll delegate
extension MapViewController: UIScrollViewDelegate
{
//    func viewForZooming(in scrollView: UIScrollView) -> UIView?
//    {
//        
////        guard let zoom = scrollView.zoomScale else { return scrollView }
//        
////        print("*** viewForZooming \(self.scrollView.zoomScale)")
//
//
////        schemeView.bringSubviewToFront(buttonDelete)
////
////        buttonDelete.setY(self.scrollView.contentOffset.y + 55)
////        buttonDelete.setX(self.scrollView.contentOffset.x + ScreenSize.SCREEN_WIDTH / 2 - 24)
//
//        return schemeView
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        replaceButtonDelete(scale: scrollView.zoomScale)
        
//        if scrollView.isTracking
//        {
//            print("*** scrollViewDidScroll ")
//
//            print(scrollView.contentOffset)
//        }
    }
}

// MARK: - MapViewProtocol
extension MapViewController: MapViewProtocol
{

}

extension MapViewController: MapDeleteViewDelegate
{
    func MapDeleteViewDelegateDelete()
    {                
        if(_selectedUID.isEmpty)
        {
            return
        }
                        
        let checkins = self.presenter.getCheckins()
                        
        let cnt = checkins.filter({ $0.tableUid == _selectedUID }).count
                        
        if(cnt > 0)
        {
            print(checkins.filter({ $0.tableUid == _selectedUID }))
            
            let alert = CommonAlert(actionOK: {
                
            })
            self.view.addSubview(alert)
            
            alert.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
                     
            guard let old = self.presenter.getTable(uid: _selectedUID) else {
                return
            }

            if let tableView = tableViews.first(where: { $0.table.uid ==  _selectedUID })
            {
                UIView.animate(withDuration: 0.15) {
                    tableView.frame = old.parameters.frame
                }

            }
                                    
            return
        }
        
        print("** MapViewController MapDeleteViewDelegateDelete 2")
        
        if let idx = _unconfirmedTables.firstIndex(where: { $0.table.uid ==  _selectedUID })
        {
            _unconfirmedTables.remove(at: idx)
        }
        
        if let idx = tableViews.firstIndex(where: { $0.table.uid ==  _selectedUID })
        {
            tableViews.remove(at: idx)
        }
        
        for i in schemeView.subviews
        {
            if(i.tag >= 5000)
            {
                continue
            }
            
            guard let table = i as? TableView else
            {
                return
            }

            if(table.table.uid == _selectedUID)
            {
                i.removeFromSuperview()
            }
        }

        _deletedTablesUIDs.append(_selectedUID)
        
        _selectedUID = ""
    }

}
