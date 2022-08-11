//
//  Frequency.swift
//  Tesa
//
//  Created by Hao Li on 2022-07-21.
//

import Foundation
import UIKit
public class Frequency {
    public enum Mode: Int, CaseIterable {
        case None = 0 // default mode, when the frequency is not set
        case Daily = 1
        case Weekly = 2
        case Bi_Weekly = 3
        case Monthly = 4
        case Bi_Monthly = 5
        case Seasonal = 6 // three month
        case Semi_Annual = 7
        case Annual = 8
        case Irregular = 9 // for something you only by once
    }
    
    var mode: Mode
    var label: String
    var color: UIColor
    
    private init(mode: Mode, label: String, color: UIColor) {
        self.mode = mode
        self.label = label
        self.color = color
    }
    
    convenience init(rawValue: Int) {
        self.init(mode: Frequency.Mode(rawValue: rawValue) ?? .None)
    }
    
    convenience init(mode: Mode) {
        switch mode {
            case .Daily: self.init(mode: .Daily, label: "Daily", color: UIColor.color(fromRGB: 0xCB1B45)) // 紅
            case .Weekly: self.init(mode: .Weekly, label: "Weekly", color: UIColor.color(fromRGB: 0xF75C2F)) //　紅緋　// 珊瑚朱
            case .Bi_Weekly: self.init(mode: .Bi_Weekly, label: "Bi-Weekly", color: UIColor.color(fromRGB: 0xF19483)) // 曙
            case .Monthly: self.init(mode: .Monthly, label: "Monthly", color: UIColor.color(fromRGB: 0x5DAC81)) // 若竹
            case .Bi_Monthly: self.init(mode: .Bi_Monthly, label: "Bi-Monthly", color: UIColor.color(fromRGB: 0x00896C)) // 青竹
            case .Seasonal: self.init(mode: .Seasonal, label: "Seasonal", color: UIColor.color(fromRGB: 0x51ABDD)) // 群青
            case .Semi_Annual: self.init(mode: .Semi_Annual, label: "Semi-Annual", color: UIColor.color(fromRGB: 0x005CAF)) //　瑠璃
            case .Annual: self.init(mode: .Annual, label: "Annual", color: UIColor.color(fromRGB: 0x66327C)) // 菫
            case .Irregular: self.init(mode: .Irregular, label: "Irregular", color: UIColor.color(fromRGB: 0xFFB11B)) // 山吹
            case .None: self.init(mode: .None, label: "None", color: UIColor.color(fromRGB: 0x828282)) // 灰
        }
    }
}
