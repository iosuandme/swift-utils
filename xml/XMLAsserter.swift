import Foundation

public class XMLAsserter {
    /**
     * Asserts if @param child has an attribute with the name @param attrName
     * EXAMPLE: XMLAsserter.hasAttribute(child,"type")
     */
    public class func hasAttribute(child:NSXMLElement, _ attrName:String)->Bool{
        return child.attributeForName(attrName) != nil
    }
    /**
     * Asserts if an database item has children at @param index in @param database
     */
    class func hasChildrenAt(xml:NSXMLElement,_ index:Array<Int>)->Bool{
        return xml.childAt(index)?.childCount > 0
    }
    /**
     *
     */
    class func hasChildren(xml:NSXMLElement) -> Bool {
        return xml.childCount > 0
    }
    /**
     * Checks whether the specified string is valid and well formed XML.
     * @param data The string that is being checked to see if it is valid XML.
     * @return A Boolean value indicating whether the specified string is
     * valid XML.
     */
    class func validXML(xmlStr:String)->Bool{
        Swift.print("XMLAsserter.validXML UNTESTED")
        let xmlDoc:NSXMLDocument? = try? NSXMLDocument(XMLString: xmlStr, options: 0)
        if(xmlDoc == nil){return false}
        if(xmlDoc?.kind != NSXMLNodeKind.ElementKind){return false;}
        return true
    }
    class func equals(a:NSXMLElement,_ b:NSXMLElement)->Bool {
        Swift.print("XMLAsserter.equals() UNTESTED")
        Swift.print("a.XMLString")
        Swift.print(a.XMLString)
        Swift.print("b.XMLString")
        Swift.print(b.XMLString)/**/
        return a.XMLString == b.XMLString
    }
    /**
     * Asserts if there is a text value in a node
     * EXAMPLE: "<a><one>text</one></a>".xml.firstNode("one")!.child.hasSimpleContent//true
     */
    class func hasSimpleContent(node:XML)->Bool{
        if(node.childCount == 1){
            return node.children![0].kind == NSXMLNodeKind.TextKind
        }
        return false
    }
    /**
     * Asserts if there is a Node value in a node
     * NOTE: an alternate way of doing this is: self.childCount > 0 && self.children![0].localName != nil
     */
    class func hasComplexContent(node:XML)->Bool{
        if(node.childCount > 0){
            return node.children![0].kind == NSXMLNodeKind.ElementKind
        }
        return false
    }
}
//validXML
//equals