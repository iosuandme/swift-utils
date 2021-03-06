import Cocoa

class WinAsserter {
    /**
     * ASserts if a win of PARAM: type exists
     */
    class func hasWindowOfType<T>(type:T.Type) -> Bool{
        return WinParser.windowsOfType(type).count > 0
    }
}
