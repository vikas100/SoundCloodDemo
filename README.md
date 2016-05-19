# SoundCloodDemo
Simple iOS App that uses SoundCloud API to demostrate search and user's likes

### Explanation
SoundCloodDemo is a iOS Application written in Swift that demostrates a bunch of programming concepts using the SoundCloud service. When the App is first launched the user is prompted to log in and get redirected to the SoundCloud log in page. Once logged in the user is shown 2 views, FavoritesVC and SearchVC. 
#### FavoritesVC

FavoritesVC displays all of the users liked tracks from SoundCloud in a form of a table view. Each cell displays the image, and title associated with each track. A user has the option to play a track with a simple tap, swipe a cell to the left to delete a track from the list and from the service and share the track using the iOS share dialogue with a hold gesture. The user has the option the refetch the content on this view with a downward pull to the table view from the top of the table view. When a user selects a song a bar button on the right side of the navigation bar will appear indicating the state of music player, user can also manipulate the state of the player with this button.

- SearchVC 


### Notable Features

### Frameworks Used
- MobileCoreServices
- CoreSpotlight
- AVFoundation
- MediaPlayer

### Acknowledgements
- LibSoundCloud-iOS - https://github.com/MrStofkat/LibSoundCloud-iOS/blob/master/LibSoundCloud/SoundCloud.m
- JSONKit - https://github.com/johnezang/JSONKit

