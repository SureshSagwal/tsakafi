

import UIKit

enum SlideOutState {
    case LeftPanelExpanded
    case Collapsed
}

enum SlideController {
    case MainController
    case AssociateController
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

struct Version {
    static let SYS_VERSION_FLOAT = (UIDevice.currentDevice().systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
}

struct Orientation {
    static let IS_LANDSCAPE = UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeLeft || UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight
}

struct AppId {
    static let appId = UIDevice.currentDevice().identifierForVendor!.UUIDString
}

struct Period {
    static let THIS_MONTH = "this-month"
    static let PREVIOUS_MONTH = "previous-month"
    static let CURRENT_MONTH = "current-month"
    static let THIS_YEAR = "this-year"
    static let PREVIOUS_YEAR = "previous-year"
    static let LAST_3_MONTHS = "last-3-months"
    static let LAST_6_MONTHS = "last-6-months"
    static let LAST_12_MONTHS = "last-12-months"
    static let LAST_13_MONTHS = "last-13-months"
    static let LAST_24_MONTHS = "last-24-months"
    static let LAST_36_MONTHS = "last-36-months"
    static let WHOLE_YEAR = "whole-year"
    static let YEAR_TO_DATE = "year-to-date"
    static let ALL_TIME = "all-time"

}

struct MatterDetailType {
    static let PERFORMANCE = "SinceInceptionReport"
    static let CURRENT_MONTH = "GetCurrentMonthPerformance"
    static let REVENUE = "GetMatterRevenueReport"
}

struct ContactType {
    static let ALL = "All"
    static let EMPLOYEE = "Employee"
    static let CLIENT = "Client"
    static let EXTERNALPEOPLE = "External"
}

struct MatterType {
    static let BILLING = "BillingMatter"
    static let MANAGING = "ManagingMatter"
    static let WORKING = "WorkingMatter"
}

struct BassisOfAccounting {
    static let ACCURAL = "accrual"
    static let CASH = "cash"
}