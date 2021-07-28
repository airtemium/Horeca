//
//  MapEditPanel.swift
//  MayberAdminNew
//
//  Created by Artem on 11.06.2021.
//

import Foundation
import UIKit
import SnapKit

protocol MapEditPanelDelegate
{
    func MapEditPanelAddTable(type: String, x: CGFloat, y: CGFloat, rotation: CGFloat)
    
    func getTableByType(type: String) -> TableModel
    
    func clearTableSelection()
    
    func MapEditPanelDelegateMoveNewtable(type: String, x: CGFloat, y: CGFloat)
    
//    func showWheel(x: CGFloat, y: CGFloat)
    
//    func hideWheel()
}

class MapEditPanel: UIView, UIScrollViewDelegate
{
    var delegate: MapEditPanelDelegate?
    
    var _startDirection: PanSwipeDirection = .down
            
    var bg: UIImageView = {
        var i = UIImageView()
        i.image = UIImage(named: "map_edit_bg")
        return i
    }()
    
    private var _isScrolling = false
    
    var scroll: UIView = {
        var v = UIView()
        v.backgroundColor = .clear
        v.isUserInteractionEnabled = true
        return v
    }()

    var wheelArrows: UIImageView = {
        var i = UIImageView()
        i.isHidden = true
        i.image = UIImage(named: "map_rotate_arrows")
        return i
    }()
    
    private var _tables = [TableModel]()
    
    private var _contentSize: CGFloat = 0
    
    private var _blockWidth: CGFloat = 120
    
    private var _currentOffset: CGFloat = 0
    
    var _originalX: CGFloat = 0
    var _originalY: CGFloat = 0
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    private func _initTables()
    {
        _tables.append(_prepareNewTable(type: "SquareTwoPlaces")!)
        _tables.append(_prepareNewTable(type: "CircleTwoPlaces")!)
        _tables.append(_prepareNewTable(type: "SquareFourPlaces")!)
        _tables.append(_prepareNewTable(type: "RectangleFourPlaces")!)
        _tables.append(_prepareNewTable(type: "CircleFourPlaces")!)
        _tables.append(_prepareNewTable(type: "RectangleSixPlaces")!)
        _tables.append(_prepareNewTable(type: "CircleSixPlaces")!)
        _tables.append(_prepareNewTable(type: "CircleEightPlaces")!)
        _tables.append(_prepareNewTable(type: "RectangleEightPlaces2")!)
        _tables.append(_prepareNewTable(type: "RectangleEightPlaces")!)
    }
    
    private func _prepareNewTable(type: String) -> TableModel?
    {
        guard let d = self.delegate else {
            return nil
        }
        
        let newTable = d.getTableByType(type: type)
   
        return newTable
    }
    
    func Init()
    {
        self.addSubview(bg)
        self.addSubview(scroll)
                        
        bg.setSize(self.bounds.width, self.bounds.height)
        
        _initTables()
        
        initWheels()
        
        for (i, newTable) in _tables.enumerated()
        {
            let t = UIView()
            t.backgroundColor = .clear
            
            t.setSize(_blockWidth, self.bounds.height)
            t.setX(_contentSize)
            t.setY(0)
            
            scroll.addSubview(t)
            
            _contentSize = _contentSize + t.getWidth()
            
            //--

            let tableView = TableView(table: newTable, checkins: [], delegate: nil, scheme: .Black)
            tableView.frame = tableView.table.parameters.frame
            tableView.tag = 2000 + i
            t.addSubview(tableView)
            

            tableView.center.y = wheelArrows.center.y
            tableView.toCenterX(t)

            //----

            t.tag = 1000 + i
            t.isUserInteractionEnabled = true
            let pan = UIPanGestureRecognizer(target: self, action: #selector(self.dragTable(_:)))
//            pan.direction = UISwipeGestureRecognizer.Direction.up
            t.addGestureRecognizer(pan)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapTable(_:)))
            t.addGestureRecognizer(tap)
        }
        
        scroll.setSize(_contentSize, self.bounds.height)
                
        setScrollToCenter()

    }
    
    func RotateAllTables(angle: CGFloat)
    {
        for (i, _) in _tables.enumerated()
        {
            if let t = scroll.viewWithTag(2000 + i) as? TableView
            {
                t.RotateContainer(angle: angle)
            }
        }
    }
        
    func RotateTableByType(type: String, angle: CGFloat)
    {
        //
        
        if let idx = _tables.firstIndex(where: { $0.typeString ==  type })
        {
            if let t = scroll.viewWithTag(2000 + idx) as? TableView
            {
                t.RotateContainer(angle: angle)
            }
        }
    }
    
    func scrollToTableType(type: String)
    {
        for (i, _) in _tables.enumerated()
        {
            if let t = scroll.viewWithTag(2000 + i) as? TableView
            {
                t.SetColorScheme(scheme: .Black)
                
                t.RotateContainer(angle: 0)
            }
        }
        
        if let idx = _tables.firstIndex(where: { $0.typeString ==  type })
        {
            if let t = scroll.viewWithTag(2000 + idx) as? TableView
            {
                t.SetColorScheme(scheme: .Purple)
            }
            
            if let item = scroll.viewWithTag(idx + 1000)
            {
                let offset = item.getX() + _blockWidth / 2
                
                let a = (offset - ScreenSize.SCREEN_WIDTH / 2) * -1

                UIView.animate(withDuration: 0.3) {
                    self.scroll.setX(a)
                } completion: { success in

                }
            }
            
            self.showArrows()
        }
    }
    
    func showArrows(/*finish: @escaping () -> ()*/)
    {
//        UIView.animate(withDuration: 0.3) {
//        self.wheelArrows.isHidden = false
//        } completion: { success in
//            self.wheelArrows.isHidden = true
//
//            finish()
//        }
    }
    
    func initWheels()
    {
        self.addSubview(wheelArrows)
        
        wheelArrows.setSize(110, 110)
        wheelArrows.toCenterX(self)
        wheelArrows.setY(0)
    }
    
    func getCenter() -> CGPoint
    {
        return self.wheelArrows.center
    }
    

    func hideArrows()
    {
        print("*** showWheels 1")
        
        if(!wheelArrows.isHidden)
        {
            return
        }
        
//        guard let d = self.delegate else { return }
        
//        d.showWheel(x: self.wheelArrows.center.x, y: self.wheelArrows.center.y)
                        
        wheelArrows.isHidden = true
        
        //---
        
        wheelArrows.alpha = 0
        
        UIView.animate(withDuration: 0.3) {

            self.wheelArrows.alpha = 1
        } completion: { success in
            
        }
    }
    
    @objc func tapTable(_ sender: UIPanGestureRecognizer)
    {
        print("**** tapTable")
    }
                    
    @objc func dragTable(_ sender: UIPanGestureRecognizer)
    {
        print("**** dragTable")
        
        guard let d = self.delegate else {
            return
        }
        
        let id = sender.view!.tag



        if(sender.state == .began)
        {
            d.clearTableSelection()

            _originalX = sender.view!.center.x
            _originalY = sender.view!.center.y
                        
            if(sender.direction == .up || sender.direction == .upSwipe || sender.direction == .down || sender.direction == .downSwipe)
            {
                _startDirection = .up
            }
            else if(sender.direction == .left || sender.direction == .leftSwipe)
            {
                _startDirection = .leftSwipe
            }
            else
            {
                _startDirection = .rightSwipe
            }
        }
//
        if(sender.direction == .leftSwipe /*&& sender.state == .ended*/)
        {
//            print("*** dragTable 1 \(sender.state.rawValue)")
        }

        if(sender.direction == .rightSwipe /*&& sender.state == .ended*/)
        {
//            print("*** dragTable 2")
        }
//
        if(_startDirection == .up)
        {
            if let t = scroll.viewWithTag(2000 + (id - 1000)) as? TableView
            {
                if(!t.ReadyToDrag)
                {
                    return
                }
            }

            let translation = sender.translation(in: self)
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)

            sender.setTranslation(CGPoint.zero, in: self)
            
            //---
            
            let type = _tables[sender.view!.tag - 1000].typeString

            let location = sender.location(in: self)
            
            d.MapEditPanelDelegateMoveNewtable(type: type, x: location.x, y: location.y)
        }
        
        if(sender.state == .failed || sender.state == .cancelled)
        {

            sender.view!.center.x = _originalX
            sender.view!.center.y = _originalY
        }
        
        if(sender.state == .ended)
        {
            if(_startDirection == .up)
            {
                let location = sender.location(in: self)
                
                sender.view!.center.x = _originalX
                sender.view!.center.y = _originalY
                
                let type = _tables[sender.view!.tag - 1000].typeString

                var rotation: CGFloat = 0
                
                
                
                if let t = scroll.viewWithTag(2000 + (id - 1000)) as? TableView
                {
                    rotation = t.GetRotation()
                }
                
//                let type = _tables[sender.view!.tag - 1000].
                
                d.MapEditPanelAddTable(type: type, x: location.x, y: location.y, rotation: rotation)
            }
            
            if(_startDirection == .rightSwipe)
            {
                let newOffset: CGFloat = scroll.getX() + _blockWidth
                let limit: CGFloat = (ScreenSize.SCREEN_WIDTH / 2 - _blockWidth / 2)

                if(newOffset > limit)
                {
                    return
                }

                _isScrolling = true

                UIView.animate(withDuration: 0.1) {
                    self.scroll.setX(newOffset)
                } completion: { sucess in
                    self._isScrolling = false
                }
                
                colorizeCurrentTable()
            }

            if(_startDirection == .leftSwipe)
            {
                let newOffset: CGFloat = scroll.getX() - _blockWidth

                let limit: CGFloat = (ScreenSize.SCREEN_WIDTH / 2 + _blockWidth / 2)

                if(newOffset + _contentSize < limit)
                {
                    return
                }

                UIView.animate(withDuration: 0.1) {
                    self.scroll.setX(newOffset)
                } completion: { sucess in
                    self._isScrolling = false
                }
                
                colorizeCurrentTable()
            }
        }
    }
    
    private func setScrollToCenter()
    {
        _currentOffset = ((_contentSize / 2) - ScreenSize.SCREEN_WIDTH / 2 + _blockWidth / 2) * -1
        
        self.showArrows()
                        
        scroll.setX(_currentOffset)
        
        colorizeCurrentTable()
    }
    
    func RotateCentralTable(angle: CGFloat)
    {
        for (i, _) in _tables.enumerated()
        {
            if let t = scroll.viewWithTag(1000 + i)
            {
                let center = (scroll.getX() * -1) + (ScreenSize.SCREEN_WIDTH / 2)

                let pos = t.getX() + _blockWidth / 2

                if let t2 = scroll.viewWithTag(2000 + i) as? TableView
                {
//                    t2.ReadyToDrag = false
                    
                    if(pos == center)
                    {
                        t2.RotateContainer(angle: angle)
                    }
                }
            }
        }
    }
    
    func colorizeCurrentTable()
    {
        print("*** colorizeCurrentTable")

        for (i, _) in _tables.enumerated()
        {
            if let t = scroll.viewWithTag(1000 + i)
            {
                let center = (scroll.getX() * -1) + (ScreenSize.SCREEN_WIDTH / 2)
                
                let pos = t.getX() + _blockWidth / 2
                
                if let t2 = scroll.viewWithTag(2000 + i) as? TableView
                {
                    t2.SetColorScheme(scheme: .Black)
                    
                    t2.ReadyToDrag = false
                    
                    if(pos == center)
                    {
                        t2.ReadyToDrag = true
                        t2.SetColorScheme(scheme: .Purple)
                    }
                }
            }
        }
    }

    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

