import Cocoa
/**
 * Watches for file changes in a list of filePaths
 * NOTE: You could stop and start to restart
 * NOTE: The nice thing about FSEvents is that you just need to watch one folder and you will be notified of any changes that occur anywhere in the subfolder hierarchy of that folder.
 * FUN-FACT: Dropbox also uses FSEvents to watch the change inside the Dropbox folder.
 * NOTE: lots of info on FSEVent: https://developer.apple.com/library/mac/documentation/Darwin/Reference/FSEvents_Ref/index.html#//apple_ref/c/tdef/FSEventStreamCallback
 * EXAMPLE: fileWatcher!.event = { [weak self] event in Swift.print(self?.temp); Swift.print(event.description)}//<--this is the closure that would print the fileChange event and also be able to interact with the app. The temp var is a temp var in the calling class to demonstrate that the closure is able to interact with the app as well
 */
class FileWatcher{
    let filePaths:[String]/*Specifiy many paths to watch, works on folders and file paths*/
    var hasStarted = false/*Whether or not the watcher has started yet.*/
    var streamRef:FSEventStreamRef?
    private(set) var lastEventId: FSEventStreamEventId/*<-this needs to be private or an error will happen when in use*/ // The date to start at.
    var event: ((fileWatcherEvent: FileWatcherEvent) -> Void)?
    init(_ paths: [String], _ sinceWhen: FSEventStreamEventId) {
        self.lastEventId = sinceWhen
        self.filePaths = paths
    }
    /**
     * Start listening for FSEvents
     * NOTE: Starts receiving events and servicing them from the client's runloop(s) using the callback supplied by the client when the stream was created. If a value was supplied for the sinceWhen parameter then "historical" events will be sent via your callback first, then a HistoryDone event, then "contemporary" events will be sent on an ongoing basis (as though you had supplied kFSEventStreamEventIdSinceNow for sinceWhen).
     * NOTE: FSEvents now supports file-level granularity, use kFSEventStreamCreateFlagFileEvents flag when creating events stream to get informed about changes to particular files.
     * latency: How often the watcher updates. (This should be sett acording to use, if you need instant feedback then set it to 0, less frequent then maybe 3.0)
     * flags: The flags used to create the watcher.
     * runLoopMode: The run loop mode for the watcher.
     */
    func start() {
        Swift.print("start - has started: " + "\(hasStarted)")
        if(hasStarted){return}/*<--only start if its not already started*/
        var context = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutablePointer<Void>(unsafeAddressOf(self))
        let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
        streamRef = FSEventStreamCreate(kCFAllocatorDefault, eventCallback, &context, filePaths, lastEventId, 0/*<--latency*/, flags)//Creates an FSEventStream.
        FSEventStreamScheduleWithRunLoop(streamRef!, CFRunLoopGetMain()/*NSRunLoop.currentRunLoop().getCFRunLoop()*//*CFRunLoopGetMain()*/, kCFRunLoopDefaultMode)// Schedules an FSEventStream on a runloop, like CFRunLoopAddSource() does for a CFRunLoopSourceRef., you could also use a different runloop here: NSRunLoop.currentRunLoop().getCFRunLoop() for instance
        FSEventStreamStart(streamRef!)
        hasStarted = true
    }
    /**
     * Stop listening for FSEvents
     * NOTE: Stops the stream, ensuring the client's callback will not be called again for this stream. After stopping the stream, it can be restarted seamlessly via FSEventStreamStart() without missing any events.
     */
    func stop() {
        Swift.print("stop - has started: " + "\(hasStarted)")
        if(!hasStarted){return}/*<--only stop if it has been started*/
        FSEventStreamStop(streamRef!)
        FSEventStreamInvalidate(streamRef!)//Invalidates the stream, like CFRunLoopSourceInvalidate() does for a CFRunLoopSourcRef.
        FSEventStreamRelease(streamRef!)//Decrements the refcount on the stream (initially one and incremented via FSEventStreamRetain()). If the refcount reaches zero, the stream is deallocated.
        streamRef = nil
        hasStarted = false
    }
    /**
     * NOTE: This is the type of the callback function supplied by the client when creating a new stream. This callback is invoked by the service from the client's runloop(s) when events occur, per the parameters specified when the stream was created.
     * PARAM: streamRef: The stream for which event(s) occurred.
     * PARAM: clientCallBackInfo: The info field that was supplied in the context when this stream was created.
     * PARAM: numEvents: The number of events being reported in this callback. Each of the arrays (eventPaths, eventFlags, eventIds) will have this many elements.
     * PARAM: eventPaths: An array of paths to the directories in which event(s) occurred.The type of this parameter depends on the flags passed to FSEventStreamCreate...(). If kFSEventStreamCreateFlagUseCFTypes was set, then this will be a CFArrayRef containing CFStringRef objects (per CFStringCreateWithFileSystemRepresentation()). Ownership follows the Get rule, and they will be released by the framework after your callback returns. If kFSEventStreamCreateFlagUseCFTypes was not set, then the framework will pass your callback a raw C array of raw C strings that will be deallocated by the framework after your callback returns. A path might be "/" if ether of these flags is set for the event: kFSEventStreamEventFlagUserDropped, kFSEventStreamEventFlagKernelDropped.
     * PARAM: eventFlags: An array of flag words corresponding to the paths in the eventPaths parameter. If no flags are set, then there was some change in the directory at the specific path supplied in this event. See FSEventStreamEventFlags.
     * PARAM: eventIds: An array of FSEventStreamEventIds corresponding to the paths in the eventPaths parameter. Each event ID comes from the most recent event being reported in the corresponding directory named in the eventPaths parameter. Event IDs all come from a single global source. They are guaranteed to always be increasing, usually in leaps and bounds, even across system reboots and moving drives from one machine to another. Just before invoking your callback your stream is updated so that calling the accessor FSEventStreamGetLatestEventId() will return the largest of the values passed in the eventIds parameter; if you were to stop processing events from this stream after this callback and resume processing them later from a newly-created FSEventStream, this is the value you would pass for the sinceWhen parameter to the FSEventStreamCreate...() function.
     */
    private let eventCallback: FSEventStreamCallback = { (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutablePointer<Void>, numEvents: Int, eventPaths: UnsafeMutablePointer<Void>, eventFlags: UnsafePointer<FSEventStreamEventFlags>, eventIds: UnsafePointer<FSEventStreamEventId>) in
        let fileSystemWatcher: FileWatcher = unsafeBitCast(contextInfo, FileWatcher.self)
        let paths = unsafeBitCast(eventPaths, NSArray.self) as! [String]
        var eventFlagArray = Array(UnsafeBufferPointer(start: eventFlags, count: numEvents))
        for index in 0..<numEvents {
            fileSystemWatcher.event?(fileWatcherEvent: FileWatcherEvent(eventIds[index], paths[index], eventFlags[index]))
        }
        fileSystemWatcher.lastEventId = eventIds[numEvents - 1]//<--im not sure if this is needed anymore
    }
    /**
     * Carefull with enabling this as we don't deinit things in swift anymore? ARC and all that?
     * NOTE: if you enable it the class will deint right after its init. A suggestion is to call stop when its not needed.
     */
    deinit {
        //stop()
    }
}
extension FileWatcher{
    /**
     * Convenince init
     */
    convenience init(_ pathsToWatch:[String]) {
        self.init(pathsToWatch, FSEventStreamEventId(kFSEventStreamEventIdSinceNow))
    }
}