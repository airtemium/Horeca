//
//  TableView.swift
//  MayberAdminNew
//
//  Created by Martynov on 21.05.2021.
//

import UIKit

// MARK: - TableViewDelegate
protocol TableViewDelegate
{
    func chooseChair(_ number: Int, checkinUID: String)
}

class TableSeatOrder
{
    var SeatNumber = 0
    
    var CheckinUID = ""
    
    init(number: Int, checkinUID: String)
    {
        CheckinUID = checkinUID
        
        SeatNumber = number
    }
}

enum TableViewColorScheme: Int
{
    case Black
    case Blue // rgb 0 122 255
    case Gray // rgb 199 199 204 seats rgb 109 114 120
    case Purple // rgb 37 70 119
}

// MARK: - TableView
final class TableView: UIView
{
    // MARK: - Properties -
    var IsNew = false
    
    
    private var _readyToDrag = false
    
    private var _delegate: TableViewDelegate?
    
    private var containerView: UIView!
    
    private var seatsView: UIView!
    
    private var tableView: UIView!
    
    private var _selectionView: UIView!
    
    private var _dragView: UIView!
    
    private let numberLabel = UILabel()

    /*private*/ var places = [PlaceView]()
    
    private(set) var table: TableModel!
    
    private var checkins: [CheckinModel]!
    
    private var seatCheckins = [TableSeatOrder]()
    
    private var _scheme = TableViewColorScheme.Gray
    
    private var _angle: CGFloat = 0
            
    // MARK: - init -
    required init(table: TableModel, checkins: [CheckinModel], delegate: TableViewDelegate?, scheme: TableViewColorScheme = .Gray)
    {
        super.init(frame: .zero)
        
        _delegate = delegate
        
        _scheme = scheme
        
        self.table = table
        
        self.checkins = checkins
        
        setupView()
        
//        self.layer.borderWidth = 1
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    var TableLayout: UIView
    {
        get
        {
            return self.tableView
        }
    }
    
    var ReadyToDrag: Bool
    {
        get
        {
            return _readyToDrag
        }
        set
        {
            _readyToDrag = newValue
        }
    }
    
    var SelectedLayout: UIView
    {
        get
        {
            return self._selectionView
        }
    }
    
    var DragLayout: UIView
    {
        get
        {
            return self._dragView
        }
    }
    
    var Container: UIView
    {
        get
        {
            return containerView
        }
    }
    
    func setSelected(isOn: Bool)
    {
        if(isOn)
        {
            _selectionView.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.25)
        }
        else
        {
            _selectionView.backgroundColor = .clear
        }
    }
    
    func RotateContainer(angle: CGFloat)
    {
//        print("*** TABLE VIEW RotateContainer *** \(table.parameters.rotation) *** \(angle)")
        
//        try! DB.shared.getRealm.write {
//            table.parameters.rotation = Float(angle)
//        }
//        table.parameters.nrotation = Float(angle)
//
        let angle2 = CGFloat(.pi * angle / 180)
        containerView.transform = CGAffineTransform(rotationAngle: angle2)
        
        _selectionView.center = tableView.center
        _dragView.center = tableView.center
        
        
        _angle = angle
    }
    
    func GetRotation() -> CGFloat
    {
        return _angle
    }
}

// MARK: - Public Methods -
extension TableView
{
    static let spacingPlace = CGFloat(8)
    
    static var maxWidth: CGFloat
    {
        88 + twoPlacesWithSpacings
    }
    
    static var maxHeight: CGFloat
    {
        48 + twoPlacesWithSpacings
    }
    
    var containerSize: CGSize
    {
        containerView.bounds.size
        
    }
    
    func scale(_ scale: CGFloat)
    {
        containerView.transform = CGAffineTransform(scaleX: scale, y: scale)
        numberLabel.isHidden = abs(scale - 1.0) > 1e-3
    }
}

// MARK: - Private Methods -
extension TableView
{
    static var spacingFactor: CGFloat = 1.0 + 1.0 / 2.0
    static var twoPlacesWithSpacings = 2.0 * PlaceView.placeSize * spacingFactor
    
    func setupView()
    {
        setupContainer()
        
        setupTableNumberLabel()
        
        setupConstraints()
    }
    

    
    func setupContainer()
    {
        let containerFrame = CGRect(origin: .zero, size: table.parameters.size)
        containerView = UIView(frame: containerFrame)
//        containerView.backgroundColor = .red
        addSubview(containerView)
        
        let angle = CGFloat(.pi * table.parameters.rotation / 180.0)
        containerView.transform = CGAffineTransform(rotationAngle: angle)
        
        seatsView = UIView(frame: containerFrame)
        putSeats(seatsView, table.type)
        containerView.addSubview(seatsView)
        
        var tableFrame = CGRect(origin: .zero, size: CGSize(width: tableWidth, height: tableHeight))
        let dx = containerFrame.midX - tableFrame.midX
        let dy = containerFrame.midY - tableFrame.midY
        tableFrame = tableFrame.offsetBy(dx: dx, dy: dy)
        
        var cornerRadius = CGFloat(2.0)
        if case .circle(_) = table.type {
            cornerRadius = tableFrame.height / 2.0
        }
        
        //0 122 255, 0.25
        _selectionView = UIView()
//        _selectionView.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 0.25)
        _selectionView.backgroundColor = .clear
        _selectionView.layer.cornerRadius = 10
        _selectionView.setSize(tableFrame.width + 25, tableFrame.height + 25)
        _selectionView.toCenterX(containerView)
        _selectionView.toCenterY(containerView)
        
        containerView.addSubview(_selectionView)
        
        tableView = UIView(frame: tableFrame)
        tableView.backgroundColor = getTableColor()
        tableView.layer.cornerRadius = cornerRadius
        tableView.layer.masksToBounds = true
        
        containerView.addSubview(tableView)
        
        //---
        
        _dragView = UIView()
        _dragView.backgroundColor = .clear
        _dragView.layer.cornerRadius = cornerRadius
        _dragView.setSize(tableFrame.width + 25, tableFrame.height + 25)
        _dragView.toCenterX(containerView)
        _dragView.toCenterY(containerView)
        
        containerView.addSubview(_dragView)
        
        setBorderMask()

        _selectionView.center = tableView.center
        _dragView.center = tableView.center
        
//        setSelected(isOn: true)
    }
    
    func getNumberLabelColor() -> UIColor
    {
        return UIColor.white
    }
    
    /*
     case Black
     case Blue // rgb 0 122 255
     case Gray // rgb 199 199 204 seats rgb 109 114 120
     case Purple // rgb 37 70 119
     */
    
    func getTableColor() -> UIColor
    {
        switch(_scheme)
        {
        case .Black:
            return .black
            break
        case .Blue:
            return UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
            break
        case .Gray:
//            if(checkins.isEmpty)
//            {
//                return UIColor(red: 37/255, green: 70/255, blue: 119/255, alpha: 1)
//            }
//            else
//            {
                return UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1)
//            }
            
            break
        case .Purple:
            return UIColor(red: 224/255, green: 29/255, blue: 88/204, alpha: 1) // rgb 224 29 88
            break
        default:
            return UIColor.gray
        }
        
        return UIColor.gray
    }

    func setBorderMask(_ isOn: Bool = true)
    {
//        guard isOn else {
//            containerView.layer.mask = nil
//            return
//        }
        
        if(_scheme != .Black)
        {
            return
        }
        
        let containerFrame = containerView.bounds
        let tableFrame = tableView.frame
        
        // border inverse
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        
        let outerInset = CGFloat(-0.6)
        let innerInset = CGFloat(0.7)
        let tableCornerRadius = CGFloat(1.2)
        let path = UIBezierPath(rect: containerFrame)
        
        switch table.type {
        case .circle(_):
            path.append(UIBezierPath(ovalIn: tableFrame.insetBy(dx: outerInset, dy: outerInset)))
            path.append(UIBezierPath(ovalIn: tableFrame.insetBy(dx: innerInset, dy: innerInset)))
        default:
            path.append(UIBezierPath(rect: tableFrame.insetBy(dx: outerInset, dy: outerInset)))
            path.append(UIBezierPath(roundedRect: tableFrame.insetBy(dx: innerInset, dy: innerInset), cornerRadius: tableCornerRadius))
        }
        
        maskLayer.path = path.cgPath
        containerView.layer.mask = maskLayer
    }
    
    func setupTableNumberLabel()
    {
        var labelSize: CGFloat = getNumberSize
        
        numberLabel.font = UIFont.systemFont(ofSize: labelSize, weight: .semibold)
        
        numberLabel.text = "\(table.parameters.number)"
        
        if(_scheme == .Purple || _scheme == .Black)
        {
            numberLabel.textColor = .white
        }
        else
        {
            numberLabel.textColor = (checkins.count == 0) ? .gray : .white
        }
        
        
        addSubview(numberLabel)
    }
    
    func setupConstraints()
    {
        numberLabel.snp.makeConstraints {
            $0.center.equalTo(self)
        }
    }
    
    func SetColorScheme(scheme: TableViewColorScheme)
    {
        _scheme = scheme
        
        let color = getTableColor()
        
        tableView.backgroundColor = color
        
        for i in self.places
        {
            i.SetColorScheme(scheme: scheme)
        }
    }
    
    func putSeats(_ seatsView: UIView, _ type: TableType)
    {
        let guests = checkins.map { $0.guestNumber }.sorted()

                        
        let firstGuest = guests.first ?? 0
        let activeGuestNumber = (firstGuest > 0) ? firstGuest : (guests.count > 1 ? guests[1] : 0)
        
        let seatsFrame = seatsView.frame
        let center = seatsView.center

        let placeSize = PlaceView.placeSize
        let placeHalf = placeSize / 2
        let placeZeroFrame = CGRect(origin: .zero, size: CGSize(width: placeSize, height: placeSize))
        
        let delta = placeHalf * Self.spacingFactor
        let checkinTransform = CGAffineTransform.identity.translatedBy(x: 0, y: -delta)

        let addSeatsOnCircle: (Int) -> () = { [unowned self] (placeCount) in
            let radius = self.tableWidth / 2.0
            let startAngle = CGFloat.zero
            let deltaAngle = 2.0 * CGFloat.pi / CGFloat(placeCount)
            var currentAngle = startAngle
            let placeFrame = placeZeroFrame.offsetBy(dx: center.x - placeHalf, dy: center.y - placeHalf - radius)
            
            (1...placeCount).forEach
            {
                let placeContainer = UIView(frame: seatsFrame)
                
                let placeView = PlaceView(frame: placeFrame, number: $0, delegate: self, scheme: _scheme)
                placeView.checkinTransform = checkinTransform
                placeView.isCheckined = guests.contains($0)
                
                //---
                
                let guestNumber = $0
                
//                seatCheckins.append(TableSeatOrder(number: $0, checkinUID: checkins.first(where: { $0.guestNumber == guestNumber })!.checkinUid))
                
                //---
                
                placeView.isActive = ($0 == activeGuestNumber)
//                placeView.delegate = self
                placeContainer.addSubview(placeView)
                
                self.places.append(placeView)
                
                placeContainer.transform = CGAffineTransform(rotationAngle: currentAngle)
                placeView.numberLabel.transform = placeContainer.transform.inverted()
//                placeView.badgeView.transform = placeContainer.transform.inverted()
                placeView.badgeLabel.transform = placeContainer.transform.inverted()
                seatsView.addSubview(placeContainer)
                
                currentAngle += deltaAngle
                
            }
        }
        
        let addSeatsOnRectangle: (Int, Bool) -> () = { [unowned self] (placeCount, lastShape) in
            let heightHalf = self.tableHeight / 2
            let widthHalf = self.tableWidth / 2
            let countHalf = placeCount / 2
            let countHalfCG = CGFloat( lastShape ? countHalf - 1 : countHalf)
            let spacing = TableView.spacingPlace
            let deltaX = placeSize + spacing
            let dx = (placeSize * countHalfCG + spacing * (countHalfCG - 1)) / 2
            let dy = heightHalf + placeHalf
            let placeFrame = placeZeroFrame.offsetBy(dx: center.x - dx, dy: center.y - dy)
            var currentPlaceFrame = placeFrame
            var placeContainer = UIView(frame: seatsFrame)

            let lastShapeCheckinTransform = CGAffineTransform.identity.translatedBy(x: delta, y: 0)
            
            (1...placeCount).forEach
            {
                let index = $0 - 1
                
                if index == countHalf
                {
                    seatsView.addSubview(placeContainer)
                    
                    currentPlaceFrame = placeFrame
                    
                    placeContainer = UIView(frame: seatsFrame)
                    placeContainer.transform = CGAffineTransform(rotationAngle: .pi)
                }
                
                let placeView: PlaceView
                
                if lastShape && (index % countHalf == countHalf - 1)
                {
                    // new position on the right side
                    currentPlaceFrame = placeZeroFrame.offsetBy(dx: center.x + widthHalf - placeHalf, dy: center.y - placeHalf)
                    
                    placeView = PlaceView(frame: currentPlaceFrame, number: $0, delegate: self, scheme: _scheme)
                    placeView.checkinTransform = lastShapeCheckinTransform
                }
                else
                {
                    placeView = PlaceView(frame: currentPlaceFrame, number: $0, delegate: self, scheme: _scheme)
                    placeView.checkinTransform = checkinTransform

                    // next position is right on the top side
                    currentPlaceFrame = currentPlaceFrame.offsetBy(dx: deltaX, dy: 0)
                }
                
                placeView.numberLabel.transform = placeContainer.transform.inverted()
//                placeView.badgeView.transform = placeContainer.transform.inverted()
                placeView.badgeLabel.transform = placeContainer.transform.inverted()
                
                placeView.isCheckined = guests.contains($0)
                placeView.isActive = ($0 == activeGuestNumber)
//                placeView.delegate = self
                placeContainer.addSubview(placeView)
                self.places.append(placeView)
            }
            
            seatsView.addSubview(placeContainer)
        }
        
        switch type
        {
        case .rectangle(let placeCount):
            addSeatsOnRectangle(placeCount.intValue, placeCount == .eight2)
        case .circle(let placeCount):
            addSeatsOnCircle(placeCount.intValue)
        case .square(let placeCount):
            addSeatsOnCircle(placeCount.intValue)
        }
    }
    
    var tableHeight: CGFloat
    {
        switch table.type
        {
        case .circle(_):
            return tableWidth
        case .square(_):
            return tableWidth
        case .rectangle(_):
            return 36
        }
    }
    
    var getNumberSize: CGFloat
    {
        switch table.type
        {

        case .circle(let placeCount):
            if placeCount == .two
            {
                return 12
            }
        case .square(let placeCount):
            if placeCount == .two
            {
                return 12
            }
        default:
            return 16
        }
        
        return 16
    }
    
    var tableWidth: CGFloat
    {
        let widthI: Int
        switch table.type
        {
        case .rectangle(let placeCount):
            let width = [
                RectangleTablePlaceCount.four:   48,
                RectangleTablePlaceCount.six:    68,
                RectangleTablePlaceCount.eight:  88,
                RectangleTablePlaceCount.eight2: 68
            ]
            widthI = width[placeCount]!
        case .circle(let placeCount):
            let count = placeCount.intValue
            widthI = [26,40,40,48][count/2-1]
        case .square(let placeCount):
            let count = placeCount.intValue
            widthI = [24,36][count/2-1]
        }
        return CGFloat(widthI)
    }
}

// MARK: - PlaceViewDelegate
extension TableView: PlaceViewDelegate
{
    func choose(_ number: Int)
    {
//        print("*** TableView choose 1 *** \(number)")
        
        //TODO get checkin by number
        
        var uid = ""
        
        let checkin = checkins.first(where: { $0.guestNumber == number })
        
        if(checkin != nil)
        {
            uid = checkin!.checkinUid
        }
        
//        print("*** TableView choose 2 *** \(number) \(uid)")
        
        
        
        guard let d = self._delegate else {
            return
        }
        
//        print("*** TableView choose 3 *** \(number)" )
        
        d.chooseChair(number, checkinUID: uid)
    }
    
    func disactiveSeat(_ number: Int)
    {
        if (1...places.count).contains(number)
        {
            places[number-1].isActive = false
        }
    }
}
