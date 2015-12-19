import Foundation

class LineShape :Shape{
    var lineStyle:ILineStyle? //TODO:rename to style?
    override func drawInContext(ctx: CGContext) {
        //Swift.print("LineShape.drawInContext")
        graphics.context = ctx
        
        
        //TODO:you only need to call the draw method from here, the line setting etc can be done in the decoratable classes
        
        
        
        self.graphics.line(lineStyle!.thickness,lineStyle!.color/*,lineStyle!.lineCap, lineStyle!.lineJoin, lineStyle!.miterLimit*/)//Stylize the line
        self.graphics.draw(path)//draw everything
    }
}
