import Cocoa

class WinModifier {
    /**
     * Positions a window to @param position
     * CAUTION: the coordinate space of the y is flipped, so you have to substract the screen height etc before passing the position point
     */
    class func position(win:NSWindow, _ position:CGPoint){
        win.setFrameOrigin(CGPoint(position.x,position.y))
        //win.setFrame(NSRect(position.x,position.y,win.frame.width,win.frame.height), display: true)/*<--unsure what the display var does*/
    }
    /**
     * Aligns a window to an alignment type
     * IMPORTANT: The screen aligns from the bottom up (so use bottom for top and top for bottom) (you could fix this, it probably only requires a minus sign herer and there)
     */
    class func align(win:NSWindow,_ canvasAlignment:String,_ viewAlignment:String,_ offset:CGPoint = CGPoint(0,0)) {
        let alignmentPoint:CGPoint = alignPoint(win.frame.size,canvasAlignment,viewAlignment,offset)
        //Swift.print("ScreenUtils.alignmentPoint: " + "\(alignmentPoint)")
        WinModifier.position(win, alignmentPoint)
    }
    
    /**
     * NOTE: This method is great when you want to find the correct alignment for an NSWindow before is initiated
     */
    class func alignPoint(winSize:CGSize,_ canvasAlignment:String,_ viewAlignment:String,_ offset:CGPoint = CGPoint(0,0))->CGPoint{
        return Align.alignmentPoint(CGSize(winSize.width,winSize.height), CGSize(NSScreen.mainScreen()!.visibleFrame.width,NSScreen.mainScreen()!.visibleFrame.height),canvasAlignment,viewAlignment,offset)
    }
}