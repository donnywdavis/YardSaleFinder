//
//  StateCodes.swift
//  YardSaleFinder
//
//  Created by Donny Davis on 6/27/16.
//  Copyright © 2016 Donny Davis. All rights reserved.
//

import UIKit

enum StateCodes: Int {
    case AL
    case AK
    case AZ
    case AR
    case CA
    case CO
    case CT
    case DE
    case FL
    case GA
    case HI
    case ID
    case IL
    case IN
    case IA
    case KS
    case KY
    case LA
    case ME
    case MD
    case MA
    case MI
    case MN
    case MS
    case MO
    case MT
    case NE
    case NV
    case NH
    case NJ
    case NM
    case NY
    case NC
    case ND
    case OH
    case OK
    case OR
    case PA
    case RI
    case SC
    case SD
    case TN
    case TX
    case UT
    case VT
    case VA
    case WA
    case WV
    case WI
    case WY
    
    var shortDescription: String {
        switch self {
        case .AL:
            return "AL"
        case .AK:
            return "AK"
        case .AZ:
            return "AZ"
        case .AR:
            return "AR"
        case .CA:
            return "CA"
        case .CO:
            return "CO"
        case .CT:
            return "CT"
        case .DE:
            return "DE"
        case .FL:
            return "FL"
        case .GA:
            return "GA"
        case .HI:
            return "HI"
        case .ID:
            return "ID"
        case .IL:
            return "IL"
        case .IN:
            return "IN"
        case .IA:
            return "IA"
        case .KS:
            return "KS"
        case .KY:
            return "KY"
        case .LA:
            return "LA"
        case .ME:
            return "ME"
        case .MD:
            return "MD"
        case .MA:
            return "MA"
        case .MI:
            return "MI"
        case .MN:
            return "MN"
        case .MS:
            return "MS"
        case .MO:
            return "MO"
        case .MT:
            return "MT"
        case .NE:
            return "NE"
        case .NV:
            return "NV"
        case .NH:
            return "NH"
        case .NJ:
            return "NJ"
        case .NM:
            return "NM"
        case .NY:
            return "NY"
        case .NC:
            return "NC"
        case .ND:
            return "ND"
        case .OH:
            return "OH"
        case .OK:
            return "OK"
        case .OR:
            return "OR"
        case .PA:
            return "PA"
        case .RI:
            return "RI"
        case .SC:
            return "SC"
        case .SD:
            return "SD"
        case .TN:
            return "TN"
        case .TX:
            return "TX"
        case .UT:
            return "UT"
        case .VT:
            return "VT"
        case .VA:
            return "VA"
        case .WA:
            return "WA"
        case .WV:
            return "WV"
        case .WI:
            return "WI"
        case .WY:
            return "WY"
        }
    }
    
    var description: String {
        switch self {
        case .AL:
            return "Alabama"
        case .AK:
            return "Alaska"
        case .AZ:
            return "Arizona"
        case .AR:
            return "Arkansas"
        case .CA:
            return "California"
        case .CO:
            return "Colorado"
        case .CT:
            return "Connecticut"
        case .DE:
            return "Delaware"
        case .FL:
            return "Florida"
        case .GA:
            return "Georgia"
        case .HI:
            return "Hawaii"
        case .ID:
            return "Idaho"
        case .IL:
            return "Illinois"
        case .IN:
            return "Indiana"
        case .IA:
            return "Iowa"
        case .KS:
            return "Kansas"
        case .KY:
            return "Kentucky"
        case .LA:
            return "Louisiana"
        case .ME:
            return "Maine"
        case .MD:
            return "Maryland"
        case .MA:
            return "Massachusetts"
        case .MI:
            return "Michigan"
        case .MN:
            return "Minnesota"
        case .MS:
            return "Mississippi"
        case .MO:
            return "Missouri"
        case .MT:
            return "Montana"
        case .NE:
            return "Nebraska"
        case .NV:
            return "Nevada"
        case .NH:
            return "New Hampshire"
        case .NJ:
            return "New Jersey"
        case .NM:
            return "New Mexico"
        case .NY:
            return "New York"
        case .NC:
            return "North Carolina"
        case .ND:
            return "North Dakota"
        case .OH:
            return "Ohio"
        case .OK:
            return "Oklahoma"
        case .OR:
            return "Oregon"
        case .PA:
            return "Pennsylvania"
        case .RI:
            return "Rhode Island"
        case .SC:
            return "South Caronlina"
        case .SD:
            return "South Dakota"
        case .TN:
            return "Tennessee"
        case .TX:
            return "Texas"
        case .UT:
            return "Utah"
        case .VT:
            return "Vermont"
        case .VA:
            return "Virginia"
        case .WA:
            return "Washington"
        case .WV:
            return "West Virginia"
        case .WI:
            return "Wisconsin"
        case .WY:
            return "Wyoming"
        }
    }
    
    static var count: Int {
        var count = 0
        while let _ = self.init(rawValue: count) { count += 1 }
        return count
    }
    
    static func getStateCode(index: Int) -> StateCodes {
        return self.init(rawValue: index)!
    }
    
    static func getIndexForState(state: String) -> Int {
        var index = 0
        while let _ = self.init(rawValue: index) {
            let stateCode = getStateCode(index)
            if state == stateCode.shortDescription {
                return index
            }
            index += 1
        }
        
        return 0
    }
    
}
