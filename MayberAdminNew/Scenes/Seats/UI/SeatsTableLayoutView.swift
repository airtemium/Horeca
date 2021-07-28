//
//  SeatsTableView.swift
//  MayberAdminNew
//
//  Created by Martynov on 02.06.2021.
//

import UIKit

protocol SeatsTableLayoutViewDelegate
{
    func getTableConfig() -> TableModel?
    
    func getTableCheckins() -> [CheckinModel]
    
    func chooseSeat(_ number: Int, points: CGPoint)
    
    func getOrderItemsByCheckin(checkinUID: String) -> Int
    
    func getCheckinColorByNumber(number: Int) -> UIColor
}

class SeatsTableLayoutView: UIView, SeatsTableViewDelegate
{
    private var _additionalSeatsLimit = 6
    
    private var _countCommonSeats = 0
    
    private var _startAdditionalSeatNumber = 0
    
    var delegate: SeatsTableLayoutViewDelegate?
    
    var table: SeatsTableView!
    
    var _additionalPlaces = [SeatPlaceView]()
    
    private var _type: TableType!
    
    private var _selectedAdditional = 0
    
    var _additionalLayout: UIView = {
        var v = UIView()
//        v.backgroundColor = .red
        return v
    }()
    
    init()
    {
        super.init(frame: .zero)
        self.backgroundColor =  UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStartAdditionalSeatNumber(type: TableType)
    {
        switch type {

        case .circle(.two):
            _countCommonSeats = 2
            
            break
        case .square(.two):
            _countCommonSeats = 4
            break
        case .rectangle(.six):
            _countCommonSeats = 6
            break
        case .circle(.four):
            _countCommonSeats = 4
            break
        case .circle(.six):
            _countCommonSeats = 6
            break
        case .circle(.eight):
            _countCommonSeats = 8
            break
        case .square(.four):
            _countCommonSeats = 4
            break
        case .rectangle(.four):
            _countCommonSeats = 4
            break
        case .rectangle(.eight):
            _countCommonSeats = 8
            break
        case .rectangle(.eight2):
            _countCommonSeats = 8
            break
        }
        
        _startAdditionalSeatNumber = _countCommonSeats + 1
    }
    
    func Init()
    {
        
        guard let delegate = self.delegate else { return }
        
        guard let config = delegate.getTableConfig() else { return }
        
        _type = config.type

        setStartAdditionalSeatNumber(type: config.type)
                        
        table = SeatsTableView(table: config, rootWidth: self.frame.width, rootHeight: self.frame.height)
                
        self.addSubview(table)
        
        table.delegate = self
        
        table.setSize(self.frame.width, self.frame.height)
        table.toCenterX(self)
        table.toCenterY(self)
        
        table.setY(table.getY() - 15)
        
        
        
        _additionalLayout.setY(self.getHeight() - 45 - 15)
        _additionalLayout.setSize(0, 55)
        
        _additionalLayout.toCenterX(self)
        
        self.addSubview(_additionalLayout)
        
        // ----
        
//        var currenctCheckins = delegate.getTableCheckins()


    }
    
    func getTablePoints() -> CGPoint
    {
        guard let t = self.table else {
            return .zero
        }
        
        return t.center
    }
            
//    @objc func testAction(_ sender: AnyObject)
//    {
//        guard let delegate = self.delegate else { return }
//        
//        let checkins = delegate.getTableCheckins()
//        Reload(checkins: checkins)
//    }
    
    func Reload(checkins: [CheckinModel], force: Bool = true)
    {
        guard let delegate = self.delegate else { return }
                        
        if(table == nil)
        {
            return 
        }
        
        table.ReloadCheckins(checkins: checkins)
        
        for i in checkins.filter({ $0.guestNumber <= _countCommonSeats && $0.guestNumber != 0 } )
        {
            let orders = delegate.getOrderItemsByCheckin(checkinUID: i.checkinUid)

            table.ReloadCheckinBadge(guestNumber: i.guestNumber, badgeCount: orders)

        }
        
        if let tableCheckin = checkins.filter({ $0.guestNumber == 0 }).first
        {
            print("*** IS TABLE CHECKIN")
            
            let orders = delegate.getOrderItemsByCheckin(checkinUID: tableCheckin.checkinUid)
            
            table.setBadgeCount(count: orders)
        }
        
        
        //----
        
        _additionalPlaces = [SeatPlaceView]()
        
        setStartAdditionalSeatNumber(type: _type)
        
        _additionalLayout.setY(self.getHeight() - 45 - 15)
        _additionalLayout.setSize(0, 55)
        
        _additionalLayout.toCenterX(self)
        
        for i in _additionalLayout.subviews
        {
            i.removeFromSuperview()
        }
        
        var ii = [Int]()
        
        for i in checkins.filter({ $0.guestNumber > _countCommonSeats } )
        {
                                    
            let orders = delegate.getOrderItemsByCheckin(checkinUID: i.checkinUid)
            
            print("** ADD SEATS number \(i.guestNumber) orders \(orders)")
            
            _placeAdditionalSeat(number: i.guestNumber, badge: orders, force: force)
            
            ii.append(i.guestNumber)
        }
        
        if(ii.count > 0)
        {
            _startAdditionalSeatNumber = ii.max()! + 1
        }
        
        print("** ALL CHECKINS \(checkins.count) **8 _startAdditionalSeatNumber \(_startAdditionalSeatNumber)")
    }
    
    func SeatsTableViewDelegateSeatSelected(number: Int, points: CGPoint)
    {
        print("*** SeatsTableViewDelegateSeatSelected")
        
        guard let d = self.delegate else {
            return
        }
        
        ClearAdditional()
        table.ClearTableSelection()
        
//        if(number > 0)
//        {
//            table.ClearTableSelection()
//        }
        
        
        d.chooseSeat(number, points: points)
    }
    
    func NewCheckin(checkin: CheckinModel)
    {
        table.NewCheckin(checkin: checkin)
    }
    
    func getSuperView() -> UIView?
    {
        return self.superview
    }
    
    func getCheckinColorByNumber(number: Int) -> UIColor
    {
        guard let d = self.delegate else {
            return UIColor.white
        }
        
        return d.getCheckinColorByNumber(number: number)
    }
    
    func AddNewSeat()
    {
        if(_startAdditionalSeatNumber > _countCommonSeats + _additionalSeatsLimit)
        {
            return
        }

        _placeAdditionalSeat(number: _startAdditionalSeatNumber, badge: 0, force: true)
        
        _startAdditionalSeatNumber += 1
    }
    
    private func _placeAdditionalSeat(number: Int, badge: Int = 0, force: Bool = true)
    {
        let seatSize: CGFloat = CGFloat(65) * 0.55
        
        var offset: CGFloat = 0
        
        _additionalLayout.setSize(_additionalLayout.getWidth() + seatSize + 20, _additionalLayout.getHeight())
        self._additionalLayout.toCenterX(self)
        
        
        if(_additionalLayout.subviews.count > 0)
        {
            offset = (CGFloat(_additionalLayout.subviews.count) * (seatSize + 20))
        }
        
        let seat = SeatPlaceView(width: seatSize, height: seatSize, number: number, arrange: .additional)
        seat.tag = 1000 + number
        seat.delegate = self
        seat.setX(ScreenSize.SCREEN_WIDTH)
        seat.toCenterY(_additionalLayout)
        _additionalLayout.addSubview(seat)
        
        seat.setBadgeCount(count: badge)
        seat.setCheckinColor(color: getCheckinColorByNumber(number: number))
        seat.SetLabelAlfa(alfa: 1)
        
        self._additionalLayout.toCenterX(self)
        let x = self._additionalLayout.getX()
        
        _additionalPlaces.append(seat)
        
        if(self._selectedAdditional == number)
        {
            if let o = _additionalPlaces.first(where: { $0.GetNumber == number })
            {
                o.IsSelected = true
                
                o.SetIncrease()
            }
        }
        
        if(force)
        {
            UIView.animate(withDuration: 0.5) {
                seat.setX(offset)
                self._additionalLayout.setX(x + 10)
            } completion: { s in
                
            }
        }
        else
        {
            seat.setX(offset)
            self._additionalLayout.setX(x + 10)
            
//            if(self._selectedAdditional == number)
//            {
//                self.SeatPlaceViewDelegateSelect(number: number, points: CGPoint(x: 0, y: 0))
//            }
        }
        
    }
}

extension SeatsTableLayoutView: SeatPlaceViewDelegate
{
    func ClearAdditional()
    {
        _selectedAdditional = 0
        
        for o in _additionalPlaces
        {
            o.IsSelected = false
            
            o.UnsetIncrease()
        }
    }
    
    func SeatPlaceViewDelegateSelect(number: Int, points: CGPoint)
    {
        table.ClearSelected()
        
        table.ClearTableSelection()
        
        _selectedAdditional = number

        
        if let o = _additionalPlaces.first(where: { $0.IsSelected })
        {
            o.IsSelected = false
            
            o.UnsetIncrease()
        }
        
        if let o = _additionalPlaces.first(where: { $0.GetNumber == number })
        {
            o.IsSelected = true
            
            o.SetIncrease()
            
            guard let d = self.delegate else { return }
            
            d.chooseSeat(number, points: points)
        }
        
        print("*** SeatsTableLayoutView ** SeatPlaceViewDelegateSelect *** \(number)")
        
        
    }
    
    func chooseSeat(_ number: Int, points: CGPoint)
    {
        guard let d = self.delegate else { return }
        d.chooseSeat(number, points: points)
    }
    
    func UpdateSeatOrdersItems(number: Int)
    {
        if(number == 0)
        {
            self.table.setBadgeCount(count: 1)
        }
        else
        {
            if let o = _additionalPlaces.first(where: { $0.GetNumber == number })
            {
                o.setBadgeCount(count: 1)
                o.SetLabelAlfa(alfa: 1)
            }
        }

    }
}
