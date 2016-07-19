# FlickrSpike - Yet Another Image Gallery

An Image Gallery that uses Flickr public image feed as its data source.


#### Explicit requirements:  
1. As a user (of the application) I can see publicly shared photos on Flickr.  
2. As a user I can see the details of Photos, such as:
    * Username of publisher
    * Number of Views
    * Tags
    * Date Taken
    * Date Published
3. As a user I should be able to Save Photos to my device.
4. As a user I should be able to Open the Photo in a Browser, to see the actualy Flickr Page for the photo.
5. As a user I should be able to Send the Photo as an attatchment in an EmailZ



### 1.  Architecture

This app has deigned using Model-View-ViewModel (MVVM) pattern to provide a separation of concerns between them. It is also useful for maintainability and it also avoids the Massive-View controllers problem.

Typically the project structure has the followings:  
* ***Service*** – The core of the app that talks to the backend side via network calls
* ***Model*** – The data model to represent an entity. eg. FlickrPhoto
* ***View*** – The UI Elements which are container within a View Controler and interact with UI. eg. Table View Cells
* ***View-Model*** – The model representing the data necessary for the view to display itself; but it’s also responsible for gathering, interpreting, and transforming that data by communicating with services layer  
*	***View-Controller*** – The controllers that directly interact with the UI and manage the UI state. The code for Views and View-Controllers have similar goals and they are commonly categorised into one category  

The communication between view-models and view-controllers I have chosen traditional ***delegate*** based approach to achieve the communication between view-models and view-controllers becasue of strict requirement of the project to not to use any third=party libraries.


### 2.  Backend Infrastructure

The backend of the project is Flickr API. The public feed of the API is accessed with an API Key, to fetch and search photos.

The heart of this app is in the Image Downloader extention to the UIImageView which downlods Photos from Flickr asynchronously. As Images are downloaded, they are added to the Image Cache, to avoid downloading an Image evrytime a reusable cell comes into view.

I used a tags system to make sure images dont flickr/change when scrolling the views. Each UIImage View is assigned a Tag from their IndexPath and each image load request is given a Tag of their own. If both tags match, only then the photo is assigned to a UIImageView.



### 3. User Interface Design
The app is supported in potrait mode only for all device families - iPhone SE, 5, 5s, 6, 6s, 6Plus, 6Plus s, iPad, iPad mini, iPad Pro. The user interface is adaptive accross all these devices.


##### Gallery View Controller:  
This is the main and only View Controller in the app. This includes a Split View:

* The Split View has two main components, a Menu Bar and a Collection View Controller.
* The Collection View Controller has two cells, one of which contains a Table View Controller and the other contains a Collection View Controller.
* The Data Source is shared between both views to keep them always in sync.
    * The Menu bar is used as a Custom Tab Bar to swich between the two cells of the Split View, to access either Table or Collection View.

    * Table View -
        * The Table View shows the Photos loaded from Flickr in full screen wide Square Views.
        * The Table View also has a header view that shows the Username of the publisher of each Photo.
        * The Table View has a Data Cell which displayes the Meta Data for the each Photo.
        * The Photo View in the Table View has a Long Press Gesture Recogniser which displayes an Action Sheet for that Photo which has options to Save Photo, Open Photo in Safari and Share Photo by Email.
        * The same Action Sheet can also be accessed from the Options button in the the Header View of each Photo.
    
    * Collection View -
        * The Collection View displays a grid of Square Photos, 3 photos horizontally.
        * To Display a Photo full-screen from the Collection view, a full screen view has been added which opens in a temporary UIWindow, when a Photo is tapped.
        * The Full Screen View contains all the information about a Photo as a Table View section.
        * The Full Screen View can dismissed by dragging it downwards and it gives a disappearing effect when dragged.

* The Table View & Collection View share information among each other and also with the Split View and the View Controller Displaying them, via ***delegate*** method to perform some tasks.
* A Search Bar has been added to the Navigation Bar. A user can perform search for one or more tags. The search functionality considers all tags added to the search separated by space.
* The app constantly loads more Photos as the user scrolls to the end of either Table or Collection View. The number of photos loaded each time can be set in the Constants file and is set to 20 by default.
* The app is localization ready. All the strings are stored in a struct and can be easilty translated to another language.


***
### Level of effort and time estimates
This app was built on full-time basis for three days. Following is the approximate break down of time spent in man-hours for various aspects of the design and developement process.

| Aspect                          |Approximate Time|
| ------------------------------------ |:---------:|
| Backend setup for the API            | 0.5 hours |
| App arechitecture planning           | 1.0 hour  |
| Coding for the core service layer    | 1.0 hour  |
| Coding for the view models           | 1.0 hour  |
| Coding for the view controllers      | 8.0 hours |
| User interface design                | 3.0 hours |
| Graphic design in Sketch             | 1.0 hour  |
| Code commenting and documentation    | 2.5 hour  |
| ReadMe.md documentation on Github    | 2.0 hours |
| **Total**                            | **20 hours**  |



***
### Issues & Limitations
There are a few issues with the app that can be improved.
* The delegate based communication between view-models and view-controllers can be improved with better solutions(eg. ReactiveCocoa).
* Some proper Flickr functionalities can be added, like updating Views count on Flickr.
* The Error messages can be more detailed. That can be achieved by adding most, if not all, error codes from Flickr API to the App's Error enum.













