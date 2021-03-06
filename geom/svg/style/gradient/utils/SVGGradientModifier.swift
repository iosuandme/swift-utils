import Foundation

class SVGGradientModifier {
	/**
	 * Scales @param gradient at @param pivot with @param scalar (0-1)
	 * @Note works for SVGRadialGradient and SVGLinearGradient
	 */
	class func scale(gradient:SVGGradient,_ pivot:CGPoint,_ scale:CGPoint) {
        //Swift.print("SVGGradientModifier.scale()" + "\(gradient.gradientTransform)")
        //fatalError("not implemented yet")
        scaleGradient(&gradient.gradientTransform,pivot,scale)
        //Swift.print("gradient.gradientTransform: " + "\(gradient.gradientTransform)")
    }
    /**
     *
     */
    class func scaleGradient(inout gradientTransform:CGAffineTransform?,_ pivot:CGPoint,_ scale:CGPoint){
        //Swift.print("SVGGradientModifier.scaleGradient")
        if(gradientTransform != nil) {
            var transform:CGAffineTransform = CGAffineTransformIdentity
            transform.scaleFromPoint(scale.x, scale.y, pivot)
            gradientTransform = CGAffineTransformConcat(gradientTransform!, transform)
            
        }/*Scale the current applied matrix*/
        else {
            gradientTransform = CGAffineTransform.scaleFromPoint(CGAffineTransformIdentity, scale.x, scale.y, pivot)
        }/*if there is no gradientTransform allready applied to the Gradient instnace, then apply a new Matrix instance w/ the correct scale*/
    }
}