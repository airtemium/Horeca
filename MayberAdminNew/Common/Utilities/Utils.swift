
//  Created by Airtemium

import Foundation
import UIKit
import CryptoKit

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}

public func PriceWithCurrencyFormatter(price: Double, currency: String) -> String
{
    if(currency.count == 1)
    {
        return String(format: "%@ %.2f", currency, price)
    }
    
    return String(format: "%.2f %@", price, currency)
}

public enum PanSwipeDirection: Int
{
    case up, down, left, right, upSwipe, downSwipe, leftSwipe, rightSwipe
    
    public var isSwipe: Bool
    {
        return [.upSwipe, .downSwipe, .leftSwipe, .rightSwipe].contains(self)
    }
    
    public var isVertical: Bool
    {
        return [.up, .down, .upSwipe, .downSwipe].contains(self)
    }
    
    public var isHorizontal: Bool
    {
        return !isVertical
    }
}

extension UIControl
{
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->())
    {
        if #available(iOS 14.0, *)
        {
            addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
        }
        
        else {
            @objc class ClosureSleeve: NSObject
            {
                let closure:()->()
                init(_ closure: @escaping()->()) { self.closure = closure }
                @objc func invoke() { closure() }
            }
            
            let sleeve = ClosureSleeve(closure)
            
            addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
            
            objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

public extension UIPanGestureRecognizer
{

   var direction: PanSwipeDirection?
   {
        let SwipeThreshold: CGFloat = 1000
    
        let velocity = self.velocity(in: view)
    
        let isVertical = abs(velocity.y) > abs(velocity.x)
    
        switch (isVertical, velocity.x, velocity.y)
        {
        case (true, _, let y) where y < 0:
            return y < -SwipeThreshold ? .upSwipe : .up
        case (true, _, let y) where y > 0:
            return y > SwipeThreshold ? .downSwipe : .down
        case (false, let x, _) where x > 0:
            return x > SwipeThreshold ? .rightSwipe : .right
        case (false, let x, _) where x < 0:
            return x < -SwipeThreshold ? .leftSwipe : .left
        default:
            return nil
        }
    }

}


extension UIView
{
    /* for example

    let button = UIButton()
    button.setX(10)
    button.setY(100)
    button.setSize(150, 30)
    button.backgroundColor = UIColor.red
    self.view.addSubview(button)

    let button2 = UIButton()
    button2.setX(10, relative: button)
    button2.setY(100)
    button2.setSize(150, 30)
    button2.backgroundColor = UIColor.blue
    self.view.addSubview(button2)

    let button3 = UIButton()
    button3.setSize(150, 30)
    button3.setX(10)
    button3.setY(10, relative: button2)
    button3.backgroundColor = UIColor.green
    self.view.addSubview(button3)

    let button4 = UIButton()
    button4.setSize(150, 30)
    button4.toCenterX(self.view)
    button4.setY(10, relative: button3)
    button4.backgroundColor = UIColor.green
    self.view.addSubview(button4)

    */

    func setSize(_ width: CGFloat, _ height: CGFloat)
    {
        let x = self.frame.origin.x
        let y = self.frame.origin.y

        self.frame = CGRect(x: x, y: y, width: width, height: height)
    }

    func toCenterX(_ relative: UIView)
    {
        self.frame.origin.x = relative.frame.size.width / 2 - self.frame.size.width / 2
    }

    func toCenterY(_ relative: UIView)
    {
        self.frame.origin.y = relative.frame.size.height / 2 - self.frame.size.height / 2
    }

    func setX(_ x: CGFloat)
    {
        self.frame.origin.x = x
    }

    func setY(_ y: CGFloat)
    {
        self.frame.origin.y = y
    }

    func setX(_ x: CGFloat, relative: UIView, position: UIViewArrange = .Right)
    {
        if(position == .Right)
        {
            self.frame.origin.x = relative.getX() + relative.getWidth() + x
        }

        if(position == .Left)
        {
            self.frame.origin.x = relative.getX() - x - self.getWidth()
        }
    }

    func setY(_ y: CGFloat, relative: UIView, position: UIViewArrange = .Bottom)
    {
        if(position == .Bottom)
        {
            self.frame.origin.y = relative.getY() + relative.getHeight() + y
        }

        if(position == .Top)
        {
            self.frame.origin.y = relative.getY() - y - self.getHeight()
        }

    }

    func setX(_ x: CGFloat, disposeOf: UIViewArrange, parent: UIView)
    {
        switch(disposeOf)
        {
        case .Right:
            self.setX(parent.getWidth() - self.getWidth() - x)
            break;
        case .Bottom:
            self.setX(x)
            break;
        case .Left:
            self.setX(x)
            break;
        case .Top:
            self.setX(x)
            break;
        }
    }

    func setY(_ y: CGFloat, disposeOf: UIViewArrange, parent: UIView)
    {
        switch(disposeOf)
        {
        case .Right:
            self.setY(y)
            break;
        case .Bottom:
            self.setY(parent.getHeight() - self.getHeight() - y)
            break;
        case .Left:
            self.setY(y)
            break;
        case .Top:
            self.setY(y)
            break;
        }
    }

    func getWidth() -> CGFloat
    {
        return self.frame.size.width
    }

    func getHeight() -> CGFloat
    {
        return self.frame.size.height
    }

    func getX() -> CGFloat
    {
        return self.frame.origin.x
    }

    func getY() -> CGFloat
    {
        return self.frame.origin.y
    }

    func shake()
    {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

enum UIViewArrange: Int
{
    case Left = 1
    case Right
    case Top
    case Bottom
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}


func getLabelSize(str: String, size: CGFloat, isBold: Bool = false, setWidth: CGFloat = 5000, setHeight: CGFloat = 100000) -> CGSize
{
    let bubble1 = UILabel(frame: CGRect(x: 0, y: 0, width: setWidth, height: setHeight))

    bubble1.numberOfLines = 0

    bubble1.lineBreakMode = NSLineBreakMode.byWordWrapping

    if(isBold)
    {        
        bubble1.font = UIFont.boldSystemFont(ofSize: size)
    }
    else
    {
        bubble1.font = UIFont.systemFont(ofSize: size)
    }

    bubble1.text = str
    bubble1.sizeToFit()

    return bubble1.frame.size
}

struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)

    static let SCREEN_HALF_WIDTH = ScreenSize.SCREEN_WIDTH / 2
    static let SCREEN_HALF_HEIGHT = ScreenSize.SCREEN_HEIGHT / 2
    static let SCREEN_THIRD_WIDTH = ScreenSize.SCREEN_WIDTH / 3
    static let SCREEN_THIRD_HEIGHT = ScreenSize.SCREEN_HEIGHT / 3
    static let SCREEN_QUARTER_WIDTH = ScreenSize.SCREEN_WIDTH / 4
    static let SCREEN_QUARTER_HEIGHT = ScreenSize.SCREEN_HEIGHT / 4

    var SCREEN_IS_PORTRAIT = (ScreenSize.SCREEN_HEIGHT / ScreenSize.SCREEN_WIDTH > 1) ? false : true
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_8 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_8P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPHONE_XMAX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 896.0
    static let IS_IPHONE =  UIDevice.current.userInterfaceIdiom == .phone
    static let IS_IPAD =  UIDevice.current.userInterfaceIdiom == .pad
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension String
{
    func MD5() -> String {
        if #available(iOS 13.0, *) {
            let digest = Insecure.MD5.hash(data: self.data(using: .utf8) ?? Data())
            return digest.map {
                String(format: "%02hhx", $0)
            }.joined()
        } else {
            // Fallback on earlier versions
        }

        return ""
        
    }
    
    func isFileExists() -> Bool
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(self)
        {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath)
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
}


struct CoercingInt: Codable, RawRepresentable {
    let rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        guard let value = Int(stringValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid integer string.")
        }

        self.rawValue = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("\(self.rawValue)")
    }
}

struct CoercingFloat: Codable, RawRepresentable {
    let rawValue: Float

    init(rawValue: Float) {
        self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        guard let value = Float(stringValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid float string.")
        }

        self.rawValue = value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("\(self.rawValue)")
    }
}

struct Utils {
    
    static let shared = Utils()
    
    private static var kServerUrl = "Server_URL"
    
    var serverUrl: String? {
        Config[Self.kServerUrl] as? String
    }
    
    var Config: [String: AnyObject]
    {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject]
        {
            return dict
        }
        else
        {
            return [String: AnyObject]()
        }
    }
}




extension UIImage
{
    func getSize(width: CGFloat, height: CGFloat) -> CGSize
    {
        var nWidth: CGFloat = 0
        var factor: CGFloat = 0
        var nHeight: CGFloat = 0

        if(height == 0)
        {
            nWidth = width
            factor = nWidth / self.size.width
            nHeight = factor * self.size.height
        }
        else if(width == 0)
        {
            nHeight = height
            factor = nHeight / self.size.height
            nWidth = factor * self.size.width
        }

        return CGSize(width: nWidth, height: nHeight)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
