//
//  Table.swift
//  MayberAdminNew
//
//  Created by Martynov on 20.05.2021.
//

import RealmSwift
import CoreGraphics.CGGeometry

// MARK:- TableSet
typealias TableSet = [String: TableModel]

// MARK:-
enum CircleTablePlaceCount: Int {
    case two   = 2
    case four  = 4
    case six   = 6
    case eight = 8
    
    var intValue: Int { self.rawValue }
}

enum SquareTablePlaceCount: Int
{
    case two   = 2
    case four  = 4
    
    var intValue: Int { self.rawValue }
}

enum RectangleTablePlaceCount: Int
{
    case four
    case six
    case eight  // Прямоугольный на 8 мест (схема 0/4/0/4)
    case eight2 // 8 мест вокруг по схеме 1/3/1/3
    
    private static let count = [4, 6, 8, 8]
    
    var intValue: Int { Self.count[self.rawValue] }
}

// MARK:-
enum TableType: CustomStringConvertible
{
    case circle(CircleTablePlaceCount)       // Круглый
    case square(SquareTablePlaceCount)       // Квадратный
    case rectangle(RectangleTablePlaceCount) // Прямоугольный
    
    init?(string: String) {
        guard
            let tableTypeRaw = TableTypes(rawValue: string),
            let tableType = tableTypeFor[tableTypeRaw]
        else {
            return nil
        }
        self = tableType
    }
    
    static let allTypes: [Self] = [
        .circle(.two),
        .square(.two),
        .circle(.four),
        .square(.four),
        .rectangle(.four),
        .circle(.six),
        .rectangle(.six),
        .circle(.eight),
        .rectangle(.eight),
        .rectangle(.eight2)
    ]
    
    var description: String {
        switch self {
        case .circle(let places):    return "circle\(places.intValue)"
        case .square(let places):    return "square\(places.intValue)"
        case .rectangle(let places): return "rectangle\(places.intValue)\((places == .eight2) ? "*" : "")"
        }
    }
}

private enum TableTypes: String {
    case CircleTwoPlaces       // Малый круглый на 2 места (по умолчанию)
    case SquareTwoPlaces       // Малый квадратный на 2 места
    case CircleFourPlaces      // Круглый на 4 места
    case SquareFourPlaces      // Квадратный на 4 места
    case RectangleFourPlaces   // Прямоугольный на 4 места
    case CircleSixPlaces       // Круглый на 6 мест
    case RectangleSixPlaces    // Прямоугольный на 6 мест
    case CircleEightPlaces     // Круглый на 8 мест
    case RectangleEightPlaces  // Прямоугольный на 8 мест (схема 0/4/0/4)
    case RectangleEightPlaces2 // 8 мест вокруг по схеме 1/3/1/3
}

private typealias TableTypeTranslateDictionary = [TableTypes: TableType]

private let tableTypeFor: TableTypeTranslateDictionary = [
    .CircleTwoPlaces:       .circle(.two),
    .SquareTwoPlaces:       .square(.two),
    .CircleFourPlaces:      .circle(.four),
    .SquareFourPlaces:      .square(.four),
    .RectangleFourPlaces:   .rectangle(.four),
    .CircleSixPlaces:       .circle(.six),
    .RectangleSixPlaces:    .rectangle(.six),
    .CircleEightPlaces:     .circle(.eight),
    .RectangleEightPlaces:  .rectangle(.eight),
    .RectangleEightPlaces2: .rectangle(.eight2)
]

// MARK:-
class TableModelParameters: Object, Codable
{
    @objc dynamic var number: Int = 0
    @objc dynamic var seats: Int = 0
    @objc dynamic var x: Float = 0
    @objc dynamic var y: Float = 0
    @objc dynamic var width: Float = 0
    @objc dynamic var height: Float = 0
    @objc dynamic var rotation: Float = 0
    
    var nrotation: Float = 0
    
    override static func primaryKey() -> String?
    {
        return "uid"
    }
    
    @objc dynamic var uid: String = ""
            
    enum CodingKeys: String, CodingKey {
        case number
        case seats
        case x
        case y
        case width
        case height
        case rotation
    }
}

extension TableModelParameters
{
    var origin: CGPoint {
        let (x, y) = (CGFloat(self.x), CGFloat(self.y))
        return CGPoint(x: x, y: y)
    }
    
    var size: CGSize {
        let (width, height) = (CGFloat(self.width / 2), CGFloat(self.height / 2))
        return CGSize(width: width, height: height)
    }
    
    var frame: CGRect {
        CGRect(origin: origin, size: size)
    }
}

// MARK:-
class TableModel: Object, Codable
{
    @objc dynamic var placeUid: String = ""
    
    @objc dynamic var typeString: String = ""
    
    dynamic var type: TableType
    {
        guard let newType = TableType(string: typeString) else {
            return .circle(.two)
        }
        return newType
    }
    
    @objc dynamic var uid: String = ""
    
    @objc dynamic var code: Int = -1
    
    @objc dynamic var partyName: String = ""
    
    @objc dynamic var parameters: TableModelParameters!
    
    @objc dynamic var isRemoved: Bool = false

    enum CodingKeys: String, CodingKey {
        case placeUid   = "place_uid"
        case typeString = "type"
        case uid
        case partyName  = "party_name"
        case parameters = "params"
    }

    override static func primaryKey() -> String?
    {
        return "uid"
    }
}
