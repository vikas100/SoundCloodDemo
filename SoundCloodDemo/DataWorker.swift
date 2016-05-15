//
//  DatabaseWorker.swift
//  SoundCloodDemo
//
//  Created by inailuy on 5/11/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataWorker {
    static let sharedInstance = DataWorker()
    var tracks = [Track]()
    var fetchedObjects = NSArray()
    var appDelegate : AppDelegate!
    
    init () {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loadSoundcloud), name: TRACKS_LOADED_NOTIFIACTION, object: nil)
        appDelegate = UIApplication.sharedApplication().delegate  as! AppDelegate
        do {
            let fetchRequest = NSFetchRequest()
            let entity = NSEntityDescription.entityForName("Track", inManagedObjectContext: appDelegate.managedObjectContext)
            fetchRequest.entity = entity
            try fetchedObjects = self.appDelegate.managedObjectContext.executeFetchRequest(fetchRequest)
        } catch {
            print(error)
        }
    }
 
    func startSoundcloud() {
        if !hasConnectivity() {
            NSNotificationCenter.defaultCenter().postNotificationName("NO_INTERNET", object: nil)
            return
        }
        
        let soundCloud = appDelegate.soundCloud
        if soundCloud.login() {
            soundCloud.loadLikedTrackArray()
        }
    }
    
    @objc func loadSoundcloud() {
        var newArray = [Track]()
        for likedTrackObject in appDelegate.soundCloud.tracksFavorited {
            let request = NSFetchRequest()
            let entity = NSEntityDescription.entityForName("Track", inManagedObjectContext: appDelegate.managedObjectContext)
            request.entity = entity
            request.predicate = NSPredicate(format: "title = %@", likedTrackObject.title)
            do {
                let list = try appDelegate.managedObjectContext.executeFetchRequest(request) as! [Track]
                var track : Track?
                // success ...
                if list.count == 0 {
                    track = createAndSaveTrack(likedTrackObject as! LikedTrackObject)
                } else {
                    track = list[0]
                }
                newArray.append(track!)
            } catch let error as NSError {
                // failure
                print("Fetch failed: \(error.localizedDescription)")
            }
        }
        
        if tracks.count > 0 {
            for track in tracks as [Track] {
                if newArray.contains(track) == false{
                    appDelegate.managedObjectContext.deleteObject(track)
                }
            }
        }
        do {
            try appDelegate.managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        tracks = newArray
        NSNotificationCenter.defaultCenter().postNotificationName("FINISHED_SOUNDCLOUD", object: nil)
    }
    
    func fetchAllTracks(completion: (array: NSArray) -> Void) {
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Track")
        let sectionSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            tracks = results as! [Track]
            completion(array: tracks)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func createAndSaveTrack(likedTrackObject: LikedTrackObject) -> Track {
        let managedContext = appDelegate.managedObjectContext
        let track = NSEntityDescription.insertNewObjectForEntityForName("Track", inManagedObjectContext: managedContext) as! Track
        track.addValues(likedTrackObject)
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return track
    }
    
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
}