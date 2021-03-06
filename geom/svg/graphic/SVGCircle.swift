import Foundation
/**
 * Creates a circle instance
 * @example <circle cx="30" cy="30" r="20" style="stroke: black; fill: none;" />
 */
class SVGCircle : SVGGraphic{
    var cx : CGFloat;//center x
    var cy : CGFloat;//center y
    var r : CGFloat;
    init(_ cx:CGFloat, _ cy:CGFloat, _ r:CGFloat, _ style : SVGStyle? = nil, _ id : String? = nil) {
      self.cx = cx;
      self.cy = cy;
      self.r = r;
      super.init(style, id);
    }
    /**
     * @Note If the radius is zero, no shape will be displayed; it is an error to provide a negative radius.
     * @Note if the cx or cy is omitted (nan), it is presumed to be zero.
     * @Note it is an error to provide a negative radius.
     * @NOTE: strokeWidth should always be >= 0 if there is a lineStyle (asserting if there is a linestyle is done by the caller of this method)
     */
    override func draw(){
        //Swift.print("SVGCircle.draw() + r: " + "\(r)")
        if(!r.isNaN) {
            let x:CGFloat = (!cx.isNaN ? cx : 0) - r
            let y:CGFloat = (!cy.isNaN ? cy : 0) - r
            let rect:CGRect = CGRect(x, y, r*2, r*2)
            /*Fill*/
            if(style!.fill != nil){
                let fillFrame = (style!.stroke != nil && style!.stroke! is Double && !(style!.stroke! as! Double).isNaN) || style!.stroke != nil && style!.stroke! is SVGGradient  ?  RectGraphicUtils.fillFrame(rect, style!.strokeWidth!, OffsetType(OffsetType.center)) : rect
                //Swift.print("fillFrame: " + "\(fillFrame)")
                fillShape.frame = fillFrame/*,position and set the size of the frame*/
                fillShape.path = CGPathParser.circle(r,r,r)/*<--the path is positioned relative to the frame, remember the circle is drawn from the center not from 0,0 which is what we want when it concerns the SVGCircle*//*CGPathParser.ellipse(CGRect(0,0,rect.width,rect.height))*/
            }
            /*Line*/
            //Swift.print("style!.stroke: " + "\(style!.stroke)")
            if(style!.stroke != nil){//checks if there is a stroke in style
                let lineOffsetRect = RectGraphicUtils.lineOffsetRect(rect, style!.strokeWidth!, OffsetType(OffsetType.center))
                //Swift.print("lineOffsetRect: " + "\(lineOffsetRect)")
                lineShape.frame = lineOffsetRect.lineFrameRect
                //Swift.print("lineShape.frame: " + "\(lineShape.frame)")
                
                //this may not work if the x and y is more than 0,0 etc make sure it works
                
                lineShape.path = CGPathParser.ellipse(lineOffsetRect.lineRect)/*<--why arent we using the circle method here?, well this works aswell*/
            }
            
            
        }
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
extension SVGCircle{
    var center:CGPoint {get{return CGPoint(cx,cy)}set{cx = newValue.x;cy = newValue.y}}
}