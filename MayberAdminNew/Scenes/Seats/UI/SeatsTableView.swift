//
//  SeatsTable.swift
//  MayberAdminNew
//
//  Created by Artem on 23.06.2021.
//

import Foundation
import UIKit

protocol SeatsTableViewDelegate
{
    func SeatsTableViewDelegateSeatSelected(number: Int, points: CGPoint)
            
    func getSuperView() -> UIView?
    
    func getCheckinColorByNumber(number: Int) -> UIColor
    
    func chooseSeat(_ number: Int, points: CGPoint)
    
    func ClearAdditional()
}

class SeatsTableView: UIView
{
    var badge: UIView!
    
    var badgeLabel: UILabel!
    
    var delegate: SeatsTableViewDelegate?
    
    private var _table: TableModel?
    
    private var _rootWidth: CGFloat = 0
    
    private var _rootHeight: CGFloat = 0
    
    private var _maxHeightRatio: CGFloat = 0.35
    
    private var _maxHeight: CGFloat = 0
    
    var tableLayout: UIView!
    
    var substrateLayout: UIView!
    
    var emptySeatColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)//142 142 147

    var _places = [SeatPlaceView]()
    
    var placesCount = 0
    
    init(table: TableModel, rootWidth: CGFloat, rootHeight: CGFloat)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: rootWidth, height: rootHeight))
        
        self._table = table

        _maxHeight = rootHeight * _maxHeightRatio

        drawTable()
        
        drawSeats()
        
        self.bringSubviewToFront(substrateLayout)
        self.bringSubviewToFront(tableLayout)
        self.bringSubviewToFront(badge)
    }
    
    func ReloadCheckins(checkins: [CheckinModel])
    {
        for i in checkins
        {
            ReloadCheckin(checkin: i)
        }
    }
    
    func NewCheckin(checkin: CheckinModel)
    {
        if let v = self.viewWithTag(1000 + checkin.guestNumber) as? SeatPlaceView
        {
            v.IsCheckin = true

            v.setCheckinColor(color: getCheckinColorByNumber(number: checkin.guestNumber))
            
            v.SetIncrease()
            
            v.setBadgeCount(count: 1)

//            _moveSeats(number: checkin.guestNumber, moveOnlySelected: true)
        }
    }
    
    func ReloadCheckin(checkin: CheckinModel)
    {
        _moveSeats(number: checkin.guestNumber)
        
        if let v = self.viewWithTag(1000 + checkin.guestNumber) as? SeatPlaceView
        {
            v.IsCheckin = true
            
            v.setCheckinColor(color: getCheckinColorByNumber(number: checkin.guestNumber))
        }
    }
    
    func ClearSelected()
    {
        _moveSeats(number: 0, isClear: true)
    }
    
    func getCheckinColorByNumber(number: Int) -> UIColor
    {
        guard let d = self.delegate else {
            return UIColor.white
        }
                
        return d.getCheckinColorByNumber(number: number)
    }
    
    func ReloadCheckinBadge(guestNumber: Int, badgeCount: Int)
    {
        if let v = self.viewWithTag(1000 + guestNumber) as? SeatPlaceView
        {
            v.setBadgeCount(count: badgeCount)
        }
    }
    
    private func drawTable()
    {
        guard let t = self._table else {
            return
        }
        
        tableLayout = UIView()
        tableLayout.isUserInteractionEnabled = true
        tableLayout.backgroundColor = UIColor(red: 37/255, green: 70/255, blue: 119/255, alpha: 1)//rgb 37 70 119
        tableLayout.setSize(tableWidth, tableHeight)
        tableLayout.toCenterX(self)
        tableLayout.toCenterY(self)
        
        substrateLayout = UIView()
        
        substrateLayout.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
        substrateLayout.setSize(tableWidth + 7, tableHeight + 7)
        substrateLayout.toCenterX(self)
        substrateLayout.toCenterY(self)
        
        switch t.type {
        case .circle(_):
            tableLayout.layer.cornerRadius = tableLayout.getWidth() / 2
            substrateLayout.layer.cornerRadius = substrateLayout.getWidth() / 2
            break
        default:
            tableLayout.layer.cornerRadius = 5
            substrateLayout.layer.cornerRadius = 5
            break
        }
        
        self.addSubview(substrateLayout)
        self.addSubview(tableLayout)
        
        //---
        
        let tableTap = UITapGestureRecognizer(target: self, action: #selector(self.tableTap(_:)))
        tableTap.numberOfTouchesRequired = 1
        tableLayout.addGestureRecognizer(tableTap)
        
        //---
        
        badge = UIView()
        badge.isHidden = true
        badge.setSize(20, 20)
        badge.setX(0)
        badge.setY(0)
        badge.backgroundColor = .red
        badge.layer.cornerRadius = (20) / 2
        self.addSubview(badge)
        
        badgeLabel = UILabel()
        badgeLabel.alpha = 1
        badgeLabel.textColor = .white
        badgeLabel.textAlignment = .center
        badgeLabel.text = "\(0)"
        badgeLabel.font = UIFont.systemFont(ofSize: 12)
        badgeLabel.setSize(badge.getWidth(), badge.getHeight())
        badgeLabel.setX(0)
        badgeLabel.setY(0)
        badge.addSubview(badgeLabel)
        
        placeTableBadge()
    }
    
    func setBadgeCount(count: Int)
    {
        badge.isHidden = true
        
        if(count > 0)
        {
            badge.isHidden = false
            badgeLabel.text = "\(count)"
        }
    }
    
    @objc func tableTap(_ sender: UITapGestureRecognizer)
    {
        let v = sender.view
        
        
        
        
//        let points = CGPoint(x: v!.center.x, y: v!.center.y)
        
        tableLayout.layer.borderWidth = 3
        tableLayout.layer.borderColor = UIColor.white.withAlphaComponent(0.45).cgColor
        
        guard let d = self.delegate else { return }
        
//        sender.view.loca
        
//        let location = d.getSuperView()?.convert(v!.center, to: nil)
        
        let location = sender.location(in: d.getSuperView())
        
//        d.SeatsTableViewDelegateSeatSelected(number: 0, points: points)
                        
        self.ClearSelected()
        
        d.ClearAdditional()
        
        d.chooseSeat(0, points: location)
    }
    
    func ClearTableSelection()
    {
        tableLayout.layer.borderWidth = 0
        tableLayout.layer.borderColor = UIColor.clear.cgColor
    }
    
    func placeTableBadge()
    {
        guard let t = self._table else {
            return
        }
        
        self.bringSubviewToFront(badge)
        
        switch(t.type)
        {
        case .circle(_):

            break
        case .square(_):
            badge.setX(tableLayout.getWidth() + tableLayout.getX() - 10)
            badge.setY(tableLayout.getY() - 10)
            break
        case .rectangle(_):
            badge.setX(tableLayout.getWidth() + tableLayout.getX() - 10)
            badge.setY(tableLayout.getY() - 10)
            break
        }
    }
    
    private func drawSeats()
    {
        var countSeats = 0
        
        guard let t = self._table else {
            return
        }
        
        switch(t.type)
        {
        case .circle(let count):
            countSeats = count.intValue
            drawCircleTableSeats(countSeats: countSeats)
            break
        case .square(let count):
            countSeats = count.intValue
            
            if(count == .two)
            {
                drawSimpleTableSeats(countSeats: countSeats)
            }
            else
            {
                drawSideTableSeats(countSeats: countSeats)
            }
            
            break
        case .rectangle(let count):
            countSeats = count.intValue
            
            if(count == .eight2)
            {
                drawSideTableSeats(countSeats: countSeats)
            }
            else
            {
                drawSimpleTableSeats(countSeats: countSeats)
            }
            break
        }
    }
    

    func drawCircleTableSeats(countSeats: Int)
    {

        let centerOfCircle = self.tableLayout.center

        let radius: CGFloat = CGFloat(self.tableWidth) / 2 + 35

        let degrees = 360 / CGFloat(countSeats)

        for i in 0..<countSeats
        {

            let seat = SeatPlaceView(width: 35, height: 35, number: i + 1, arrange: .circle)
            seat.tag = 1000 + i + 1
            seat.delegate = self
            self.addSubview(seat)

            seat.SetLabelAlfa(alfa: 1)

            let hOffset = radius * cos(CGFloat(i) * degrees * .pi / 180)
            let vOffset = radius * sin(CGFloat(i) * degrees * .pi / 180)

            seat.center = CGPoint(x: centerOfCircle.x + hOffset, y: centerOfCircle.y + vOffset);

            _places.append(seat)
        }

        placesCount = countSeats
    }
    
    func drawSideTableSeats(countSeats: Int)
    {
        let placeSize = tableWidth / (CGFloat(countSeats - 2) / 2)
        
        let seatSize: CGFloat = CGFloat(placeSize) * 0.55
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        var arrange = SeatPlaceViewArrange.top
        
        for i in 1...countSeats
        {
            if(i == 1)
            {
                x = tableLayout.getX() - (seatSize / 2)
                y = (tableLayout.getY() + tableLayout.getHeight() / 2) - (seatSize / 2)
                
                arrange = .left
            }
            
            if(i == 2)
            {
                x = tableLayout.getX() + (placeSize / 2) - (seatSize / 2)
                
                y = tableLayout.getY() - (seatSize / 2)
                
                arrange = .top
            }
            
            if(i == (countSeats / 2) + 1)
            {
                x = tableLayout.getX() + tableLayout.getWidth() - (seatSize / 2)
                
                y = (tableLayout.getY() + tableLayout.getHeight() / 2) - (seatSize / 2)
                
                arrange = .right
            }
            
            if(i == (countSeats / 2) + 2)
            {
//                x = tableLayout.getX() + (placeSize / 2) - (seatSize / 2)

                y = tableLayout.getY() + tableLayout.getHeight() - (seatSize / 2)
                
                arrange = .bottom
                
//                x = x - placeSize
            }
            
            let seat = SeatPlaceView(width: seatSize, height: seatSize, number: i, arrange: arrange)
            seat.tag = 1000 + i
            seat.delegate = self
            seat.setX(x)
            seat.setY(y)
            self.addSubview(seat)
                        
            if(arrange == .top)
            {
                x = x + placeSize
            }
            
            if(arrange == .right)
            {
                x = x - (placeSize / 2)
            }
            
            if(arrange == .bottom)
            {
                x = x - placeSize
            }
            
            _places.append(seat)
        }
        
        placesCount = countSeats
    }
    
    func drawSimpleTableSeats(countSeats: Int)
    {
        let placeSize = tableWidth / (CGFloat(countSeats) / 2)
        
        let seatSize: CGFloat = CGFloat(placeSize) * 0.55
        
        var x: CGFloat = tableLayout.getX() + (placeSize / 2) - (seatSize / 2)
        
        var y: CGFloat = tableLayout.getY() - (seatSize / 2)
        
        var arrange = SeatPlaceViewArrange.top
        
        for i in 1...countSeats
        {
            if(i == (countSeats / 2) + 1)
            {
//                x = tableLayout.getX() + (placeSize / 2) - (seatSize / 2)
                
                y = tableLayout.getY() + tableLayout.getHeight() - (seatSize / 2)
                
                arrange = .bottom
                
                x = x - placeSize
            }
            
            let seat = SeatPlaceView(width: seatSize, height: seatSize, number: i, arrange: arrange)
            seat.tag = 1000 + i
            seat.delegate = self
            seat.setX(x)
            seat.setY(y)
            self.addSubview(seat)
            
            if(arrange == .top)
            {
                x = x + placeSize
            }
            
            if(arrange == .bottom)
            {
                x = x - placeSize
            }
            
            _places.append(seat)
                                                        
        }
        
        placesCount = countSeats
    }

    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tableHeight: CGFloat
    {
        guard let t = self._table else {
            return 0
        }
        
        switch t.type
        {
        case .circle(let count):
            
            if(count == .eight)
            {
                return _maxHeight
            }
            
            if(count == .two)
            {
                return _maxHeight * 0.75
            }
            
            if(count == .four)
            {
                return _maxHeight * 0.75
            }
            
            if(count == .six)
            {
                return _maxHeight * 0.85
            }
            break
        case .rectangle(let count):
            if(count == .eight)
            {
                return _maxHeight * 0.8
            }
            
            if(count == .eight2)
            {
                return _maxHeight * 0.8
            }
            
            if(count == .four)
            {
                return _maxHeight
            }
            
            if(count == .six)
            {
                return _maxHeight * 0.85
            }
            break
        case .square(let count):
            if(count == .two)
            {
                return _maxHeight * 0.75
            }
            
            if(count == .four)
            {
                return _maxHeight * 0.75
            }
            break
        }
        
        return 0
//        switch table.type
//        {
//        case .circle(_):
//            return tableWidth
//        case .square(_):
//            return tableWidth
//        case .rectangle(_):
//            return 36
//        }
    }

    var tableWidth: CGFloat
    {
        guard let t = self._table else {
            return 0
        }
        
        switch t.type
        {
        case .circle(let count):
                                    
            if(count == .eight)
            {
                return tableHeight
            }
            
            if(count == .two)
            {
                return tableHeight
            }
            
            if(count == .four)
            {
                return tableHeight
            }
            
            if(count == .six)
            {
                return tableHeight
            }
            break
        case .rectangle(let count):
            if(count == .eight)
            {
                return tableHeight * 2.5
            }
            
            if(count == .eight2)
            {
                return tableHeight * 1.9
            }
            
            if(count == .four)
            {
                return tableHeight * 1.3
            }
            
            if(count == .six)
            {
                return tableHeight * 1.9
            }
            break
        case .square(let count):
            if(count == .two)
            {
                return tableHeight
            }
            
            if(count == .four)
            {
                return tableHeight
            }
            break
        }
        
        return 0
    }
}


extension SeatsTableView: SeatPlaceViewDelegate
{
    func getSuperView() -> UIView?
    {
        guard let d = self.delegate else {
            return nil
        }
        
        return d.getSuperView()
    }
    
    private func _moveSeats(number: Int, isClear: Bool = false)
    {
        for v in _places
        {
            if(isClear)
            {
                v.UnsetIncrease()
            }
            
            if(v.IsCheckin)
            {
                continue
            }
            
            if(v.GetArrange == .circle)
            {
                v.UnsetIncrease()
                continue
            }

            
            if(v.GetArrange != .circle)
            {
                var nx: CGFloat = 0
                var ny: CGFloat = 0
                
                var a: CGFloat = 0
                
                var isMove = false
                
                if(v.GetArrange == .top)
                {
                    if(v.GetNumber == number && !v.IsAside)
                    {
                        nx = v.getX()
                        ny = v.getY() - v.getHeight()
                        a = 1
                        
                        v.IsAside = true
                        
                        isMove = true
                    }
                                            
                    if(v.GetNumber != number && v.IsAside)
                    {
                        nx = v.getX()
                        ny = v.getY() + v.getHeight()
                        a = 0

                        v.IsAside = false
                        
                        isMove = true
                    }
                }
                
                if(v.GetArrange == .bottom)
                {
                    if(v.GetNumber == number && !v.IsAside)
                    {
                        nx = v.getX()
                        ny = v.getY() + v.getHeight()
                        a = 1

                        v.IsAside = true
                        
                        isMove = true
                    }

                    if(v.GetNumber != number && v.IsAside)
                    {
                        nx = v.getX()
                        ny = v.getY() - v.getHeight()
                        a = 0

                        v.IsAside = false
                        
                        isMove = true
                    }
                }

                if(v.GetArrange == .left)
                {
                    
                    if(v.GetNumber == number && !v.IsAside)
                    {
                        nx = v.getX() - v.getWidth()
                        ny = v.getY()
                        a = 1

                        v.IsAside = true
                        
                        isMove = true
                    }

                    if(v.GetNumber != number && v.IsAside)
                    {
                        nx = v.getX() + v.getWidth()
                        ny = v.getY()
                        a = 0

                        v.IsAside = false
                        
                        isMove = true
                    }
                }

                if(v.GetArrange == .right)
                {
                    if(v.GetNumber == number && !v.IsAside)
                    {
                        nx = v.getX() + v.getWidth()
                        ny = v.getY()
                        a = 1

                        v.IsAside = true
                        
                        isMove = true
                    }

                    if(v.GetNumber != number && v.IsAside)
                    {
                        nx = v.getX() - v.getWidth()
                        ny = v.getY()
                        a = 0

                        v.IsAside = false
                        
                        isMove = true
                    }
                }
                
//                    v.UnsetIncrease()
                
                if(!isMove)
                {
                    
                    continue
                }
                
                v.SetLabelAlfa(alfa: a)
                
                UIView.animate(withDuration: 0.35) {
                    v.setX(nx)
                    v.setY(ny)
                } completion: { succes in

                    
                }
            }
        }
    }
    
    func SeatPlaceViewDelegateSelect(number: Int, points: CGPoint)
    {
        _moveSeats(number: number)
        
        if let o = _places.first(where: { $0.IsSelected })
        {
            o.IsSelected = false
            
            o.UnsetIncrease()
        }
        
        if let o = _places.first(where: { $0.GetNumber == number })
        {
            o.IsSelected = true
            
            o.SetIncrease()
            
            guard let d = self.delegate else { return }
            
            d.SeatsTableViewDelegateSeatSelected(number: number, points: points)
        }
        
//        if let v = self.viewWithTag(1000 + number) as? SeatPlaceView
//        {
//            v.SetIncrease()
//
//            guard let d = self.delegate else { return }
//
//            d.SeatsTableViewDelegateSeatSelected(number: number, points: points)
//        }
    }
    

}
