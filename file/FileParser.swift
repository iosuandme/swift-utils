/*
 *  
 */
func string(filePath:String)->String{
	var err: NSError?
	let content = String.stringWithContentsOfFile(path, encoding: NSUTF8StringEncoding, error: &err)
	if (err == nil){
		return content
	}else{
		return nil
	}
}
/**
 * 
 */
func resourcePath(){
	let sourcePath = NSBundle.mainBundle().pathForResource("contacts", ofType: "db")
}
