import Cocoa

extension NSMenu {
    /**
     * RETURNS: an reference in the same class type as the input (but must extend NSMenuItem at some point)
     */
    func addMenuItem<T:NSMenuItem>(newItem:T)->T{
        addItem(newItem)
        return newItem
    }
    /**
     *
     */
    func addSubMenu(){
        //add later
    }
}