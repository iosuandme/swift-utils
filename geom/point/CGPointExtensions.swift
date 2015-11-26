import Foundation


extension CGPoint{
    /**
     * Returns a point, in a polar cordinate system (from 0,0), for @param angle and @param length
     */
    static func polarPoint(radius:CGFloat, _ angle:CGFloat) -> CGPoint {
        return PointParser.polar(radius, angle)
    }
    /**
     * Returns the distance between two points
     */
    static func distance(a:CGPoint,_ b:CGPoint) -> CGFloat{
        return PointParser.distance(a,b)
    }
}
/*Convenient extensions*/
extension CGPoint{
    func distance(p:CGPoint) -> CGFloat { return CGPoint.distance(self,p) }//distance from self to p
    func polarPoint(radius:CGFloat, _ angle:CGFloat) -> CGPoint { return self + CGPoint.polarPoint(radius, angle) }//polarPoint from self
    init(_ x: Double, _ y:Double) { self.x = CGFloat(x); self.y = CGFloat(y); }//Init a CGPoint with Double values
    init(_ x: Int, _ y:Int) {self.x = CGFloat(x);self.y = CGFloat(y); }//Init a CGPoint with Int values
    init(_ x: CGFloat, _ y:CGFloat) { self.x = x;self.y = y;}//Init a CGPoint with CGFloat values (this method differes from the default by omitting the required argument names)
}
public func +(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x+b.x, a.y+b.y)}//Adds the coordinates of point p to the coordinates of this point to create a new point
public func -(a: CGPoint, b: CGPoint) -> CGPoint { return CGPoint(a.x-b.x, a.y-b.y)}//Subtracts the coordinates of point p from the coordinates of this point to create a new point.
public func +=(inout a: CGPoint, b: CGPoint) {a.x += b.x;a.y += b.y;}//modifies a by adding b
public func -=(inout a: CGPoint, b: CGPoint) {a.x -= b.x;a.y -= b.y;}//modifies a by substracting b