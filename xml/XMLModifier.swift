import Foundation

public class XMLModifier {
    /**
     * Adds @param child to @param xml at an array index @param index
     * // :TODO: needs some refactoring can we use hasComplexContent as an asserter? research
     */
    class func addChildAt(xml:XML,_ index:Array<Int>,_ child:XML) -> XML {// :TODO: rename to addAt?
        let i = index.slice2(0,index.count-1)
        //Swift.print("i: " + "\(i)")
        let parent:NSXMLElement? = XMLParser.childAt(xml, i)
        //Swift.print("parent: " + "\(parent)")
        parent!.addAt(child,index[index.count-1])
        return xml
    }
    /**
     *
     */
    class func addChildAt(xml:XML,_ child:XML,_ index:Int) -> NSXMLElement {
        return insertAt(xml,index,child)
    }
    /**
     * Inserts @param child at @param index in @param xml
     * @Note: works similarly to the sprite.addChildAt() function
     */
    class func insertAt(xml:XML,_ index:Int,_ child:XML) -> NSXMLElement {
        xml.insertChild(child, atIndex: index)
        return xml;
    }
    /**
     * @example XMLModifier.removeChildAt(xml, [0,0]);
     */
    class func removeChildAt(xml:XML,_ index:Array<Int>) -> NSXMLElement {// :TODO: remove may need to be recursive, rename to removeAt?
        return XMLParser.childAt(xml, index.slice2(0,index.count-1))!.removeAt(index[index.count-1])
    }
    /**
     * Convenince
     */
    class func removeChildAt(xml:XML,_ index:Int) -> NSXMLElement {
        xml.removeChildAtIndex(index)
        return xml
    }
    /**
     * @example XMLModifier.setNameAt(database.xml, index, "menu")
     */
    class func setNameAt(xml:XML,_ index:Array<Int>, _ name:String) -> NSXMLElement {
        XMLParser.childAt(xml, index)?.name = name
        return xml
    }
    /**
     * @example XMLModifier.setAttributeAt(xml, [0,1], "title", "someTitle")
     * NOTE: I think this method works with depth indecies
     */
    class func setAttributeAt(xml:XML,_ index:Array<Int>, _ key:String,_ value:String) -> NSXMLElement {
        XMLParser.childAt(xml, index)?[key] = value
        return xml
    }
    /**
     * EXAMPLE: setAttributeAt(xml,[0,1],["color":"blue","gradient":"teal"])
     * NOTE: dictionaries are unordered by nature so the attributes may be randomly arranged. To mitigate this maybe implement setting arguments through an array aswell?
     */
    class func setAttributeAt(xml:XML,_ index:Array<Int>, _ attributes:Dictionary<String,String>) -> XML {
        XMLParser.childAt(xml, index)?.setAttributesWithDictionary(attributes)
        return xml
    }
    /**
     * TODO: Make similar method for multiple key, value pairs
     */
    class func setAttributeAt(xml:XML,_ index:Int, _ key:String, _ value:String)->XML{
        let child = XMLParser.childAt(xml.children!, index)
        child![key] = value
        return xml
    }
    /**
     * TODO: Make similar method for multiple key, value pairs
     */
    class func setAttribute(xml:XML, _ key:String, _ value:String)->XML{
        xml[key] = value
        return xml
    }
    /**
     * EXAMPLE: replaceChildAt(xml, [0,1], child)
     * NOTE: if the index is out of bound the replacment is appended to the parent index
     */
    class func replaceAt(xml:XML,_ index:Array<Int>,_ replacement:XML) -> XML {
        XMLParser.childAt(xml, index.slice2(0,index.count-1))?.replaceAt(xml, index[index.count-1], replacement)//()
        return xml
    }
    /**
     * EXAMPLE: replaceChildAt(xml, 0, child)
     */
    class func replaceAt(xml:XML,_ index:Int,_ replacement:XML) -> XML {
        xml.replaceChildAtIndex(index, withNode: replacement)
        return xml
    }    
}
/**
//stringValueAt
//replaceChildrenAt
//removeChildrenAt
//addChildrenAt

addXMLToXMLList,
merge,
setAttribute,
addAttribute,
applyXmlAttributesToObject,
addChildAt,
insertAt,
removeChildAt,
removeChildrenAt,
replaceChildAt,
replaceChildrenAt,
setNameAt,
setAttributeAt,
replace,
sortByName,
sortByAttribute;

*/

 /**
  * Adding attributes to an element: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSXMLElement_Class/
  * more here: https://gist.github.com/brentdax/caaaa134c500e00efd36
  * worth a look (constructing html): https://gist.github.com/brentdax/caaaa134c500e00efd36
  */