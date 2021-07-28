//
//  PlaceView.swift
//  MayberAdminNew
//
//  Created by Martynov on 07.06.2021.
//

import UIKit

protocol PlaceViewDelegate
{
    func choose(_ number: Int)
    //func changeMenuItemCount(_ newMenuItemCount: Int)
}

// MARK: -
final class PlaceView: UIView
{
    var placeHalf = placeSize / 2
    
    let vacantPlaceColor = UIColor(red: 109.0 / 255.0, green: 114.0 / 255.0, blue: 0 / 255.0, alpha: 1.0)
    
    var placeColors = [UIColor]()

    let scaleFactor = CGFloat(1.4)
    
    var descaleFactor: CGFloat = 0

    var _scheme: TableViewColorScheme = .Gray
    
    var placeView: UIView = {
        var v = UIView()
        
        return v
    }()
    
    var badgeView: UIView = {
        var v = UIView()
        v.clipsToBounds = true
        v.backgroundColor = .red
        v.layer.borderWidth = 0.2
        v.layer.borderColor = UIColor.white.cgColor
        v.isHidden = true
        return v
    }()
    
    var badgeLabel: UILabel = {
        var l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 3, weight: .semibold)
        l.numberOfLines = 0
        l.sizeToFit()
        l.text = "0"
        return l
    }()
    
    private var _delegate: PlaceViewDelegate?
    {
        didSet {
            print("*** PlaceView delegate set")
        }
    }
    
    public let number: Int
    
    public var isCheckined = false
    {
        didSet {
            oldValue == isCheckined ? () : { checkined(isCheckined) }()
        }
    }
    
    public var isActive = false
    {
        didSet {
            oldValue == isActive ? () : { choosed(isActive) }()
        }
    }
    
    var menuItemCount = 0
    
    let numberLabel = UILabel()

    var checkinTransform = CGAffineTransform.identity
    
    required init(frame: CGRect, number: Int, delegate: PlaceViewDelegate?, scheme: TableViewColorScheme = .Gray)
    {
        self.number = number
        
        descaleFactor = 1.0 / scaleFactor
        
        super.init(frame: frame)
        
        placeColors = [vacantPlaceColor, .systemRed, .systemOrange, .systemYellow, .systemGreen, .systemTeal, .systemBlue, .blue, .systemPurple]
        
        _delegate = delegate
        
        _scheme = scheme
        
        setupViews()
        
//        Self.setup(placeView)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPlaceColor() -> UIColor
    {
        switch(_scheme)
        {
        case .Black:
            return .black
        case .Blue:
            return UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        case .Gray:
            return UIColor(red: 109/255, green: 114/255, blue: 120/255, alpha: 1)
        case .Purple:
            return UIColor(red: 224/255, green: 29/255, blue: 88/204, alpha: 1)
        }
    }
}

// MARK: - Public Methods -
extension PlaceView
{
    static let placeSize = CGFloat(12)
    
}

// MARK: - Private Methods -
extension PlaceView
{

//    static func setup<T: UIView>(_ view: T)
//    {
//        view.backgroundColor = Self.vacantPlaceColor
//        view.layer.cornerRadius = Self.placeHalf
//        view.layer.masksToBounds = true
//    }
    
    func SetColorScheme(scheme: TableViewColorScheme)
    {
        _scheme = scheme
        
        placeView.backgroundColor = getPlaceColor()
    }
    
    func setupViews()
    {
        placeView.backgroundColor = getPlaceColor()
        placeView.layer.cornerRadius = self.placeHalf
        placeView.layer.masksToBounds = true
        
        self.addSubview(placeView)
        
        placeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        numberLabel.font = UIFont.systemFont(ofSize: 5.5, weight: .semibold)
        numberLabel.text = "\(number)"
        numberLabel.textColor = .clear
        placeView.addSubview(numberLabel)

        numberLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            
        }
        
        self.addSubview(badgeView)
//
//        badgeView.transform = transform
//
        badgeView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(2.25)
        }
        
        self.layoutIfNeeded()
        
        badgeView.layer.cornerRadius = badgeView.frame.width / 2
        badgeView.addSubview(badgeLabel)
//
        badgeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        showBadgeView()
        
        badgeLabel.text = "\(menuItemCount)"
        
//        print("*** PlaceView setupViews")
//        print(checkinTransform)
    }
    
    func checkined(_ isOn: Bool)
    {
//        print("*** PlaceView checkined")
        
        
        let index = isOn ? number : 0
        let newBackgroundColor = placeColors[index]
        
//        UIView.animate(withDuration: 0.45, delay: 0.15, options: .curveEaseOut)
//        {
            self.placeView.backgroundColor = newBackgroundColor
//            self.transform = isOn ? self.checkinTransform : .identity
        
        if(isOn)
        {
            self.transform = self.checkinTransform
        }
        else
        {
            self.transform = .identity
        }
//        }
//        completion: { completed in
//            //Logger.logDebug("PlaceView N: \(self.number) C: \(self.isCheckined) View: \(self)", "")
//
//            UIView.animate(withDuration: 0.15)
//            {
                self.numberLabel.textColor = isOn ? .white : .clear
//            }
//            completion: { completed in
//                //Logger.logDebug("PlaceView N: \(self.number) L: \(self.numberLabel)", "")
//            }
//        }
    }
    
    func choosed(_ isOn: Bool)
    {
//        print("*** PlaceView choosed 1 \(isOn)")
        
        //... show active or not
        guard isCheckined else {
            
            
            return
        }
        
//        print("*** PlaceView choosed 2")
        
        let scale: CGFloat = isOn ? scaleFactor : descaleFactor
        
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut)
//        {
            self.transform = self.transform.scaledBy(x: scale, y: scale)
//        }
//        completion: { [weak self] completed in
////            Logger.logDebug("PlaceView N: \(self?.number) A: \(self?.isActive) View: \(self)", "")
//        }

        if isOn
        {
//            print("*** PlaceView choosed 3")
            
            guard let d = self._delegate else {
                return
            }
            
            d.choose(number)
        }
    }
    
    func changedBaggeCount(_ newMenuItemCount: Int)
    {
        print("** SET BADGE NUMBER")
        
        if(newMenuItemCount == 0)
        {
            return
        }
        
        self.badgeView.isHidden = false
        
        self.badgeLabel.text = "\(newMenuItemCount)"
    }
}
