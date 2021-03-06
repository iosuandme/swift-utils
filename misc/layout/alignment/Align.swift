import Cocoa
/**
 * IMPORTANT: The align method only supports NSView. But use alignmentPoint instead if you have to work with different class types. As it does the same thing as the align method does
 */
class Align {
    /**
     * Aligns @param view to @param canvasAlignment and @param viewAlignment within @param canvasSize with a optional @param offset
     * @param view: Layout item you want to manipulate
     * @param canvasSize: Area size  on which you want to align the target to (usually the parent size)
     * @param canvasAlignment: alignment of the target on the canvas
     * @param viewAlignment: alignment of the target within its own canvas
     * @param offset: add additional offset in the x,y axis
     * @example
     * Align.align(someCircle,CGPoint(400,300),Alignment.CENTER,Alignment.TOP_LEFT)//Output: centers a circle within 400x300 rectangle
     * Align.align(someCircle,CGPoint(400,300),Alignment.CENTER_RIGHT,Alignment.CENTER_RIGHT)//Output: aligns the circle to the y axis center and  to the right border of the rectangle but withinn the rectange
     */
    class func align(view:NSView, _ canvasSize:CGSize, _ canvasAlignment:String = Alignment.topLeft,_ viewAlignment:String = Alignment.topLeft, _ offset:CGPoint = CGPoint()) {
        let alignmentPoint:CGPoint = Align.alignmentPoint(CGSize(view.w, view.h), canvasSize, canvasAlignment, viewAlignment, offset)
        NSViewModifier.position(view, alignmentPoint)
    }
    /**
     * Returns the point from where to align target @param objectSize within @param canvasSize at @param objectAlignment and @param canvasAlignment and @param offset
     * @param objectSize the size of the object that is being aligned
     * @param canvasSize is the size of the canvas the object is beeing aligned to (Thinkn of the canvas as a painting and the object as an element in that painting, figurativly speaking)
     * @Note this function is usefull when aligning two or more objects where you can add the size together and find the correct alignment point
     */
    class func alignmentPoint(objectSize:CGSize, _ canvasSize:CGSize, _ canvasAlignment:String = Alignment.topLeft,_ objectAlignment:String = Alignment.topLeft, _ offset:CGPoint = CGPoint())->CGPoint {
        var alignmentPoint:CGPoint = Align.point(canvasSize, canvasAlignment)
        let viewAlignmentPoint:CGPoint = Align.point(objectSize, objectAlignment)
        alignmentPoint = alignmentPoint - viewAlignmentPoint
        return alignmentPoint + offset
    }
    /**
     * Returns the pivot point of an object according to what pivotAlignment it has
     * @example // :TODO: write an example
     */
    class func point(size:CGSize, _ alignment:String) -> CGPoint {
        switch alignment{
            case Alignment.topLeft:return CGPoint()
            case Alignment.topRight:return CGPoint(size.width,0)
            case Alignment.centerCenter, Alignment.center:return CGPoint(round((size.width/2)),round((size.height/2)))
            case Alignment.centerLeft: return CGPoint(0,round((size.height/2)))
            case Alignment.topCenter: return CGPoint(round((size.width/2)),0)
            case Alignment.centerRight: return CGPoint(size.width,round((size.height/2)))
            case Alignment.bottomRight: return CGPoint(size.width,size.height)
            case Alignment.bottomLeft: return CGPoint(0,size.height)
            case Alignment.bottomCenter: return CGPoint(round((size.width/2)),size.height)
            default:fatalError("No alignment matched the argument:" + "\(alignment)")
        }
    }
}
extension Align{
    /**
     * Aligns an array of view instances (batch align)
     * NOTE: alt names: alignMany? or alignAll?
     */
    class func align(views:Array<NSView>, _ canvasSize:CGSize, _ canvasAlignment:String = Alignment.topLeft,_ viewAlignment:String = Alignment.topLeft, _ offset:CGPoint = CGPoint()) {
        for view in views{ Align.align(view, canvasSize,canvasAlignment,viewAlignment,offset)}
    }
}