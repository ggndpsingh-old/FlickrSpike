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
1.	***Service*** – The core of the app that talks to the backend side via network calls
2.	***Model*** – The data model to represent an entity. eg. FlickrPhoto
3.	***View*** – The UI Elements which are container within a View Controler and interact with UI. eg. Table View Cells
4.	***View-Model*** – The model representing the data necessary for the view to display itself; but it’s also responsible for gathering, interpreting, and transforming that data by communicating with services layer  
5.	***View-Controller*** – The controllers that directly interact with the UI and manage the UI state. The code for Views and View-Controllers have similar goals and they are commonly categorised into one category  

The communication between view-models and view-controllers I have chosen traditional ***delegate*** based approach to achieve the communication between view-models and view-controllers becasue of strict requirement of the project to not to use any third=party libraries.



### 2. User Interface Design
The app is supported in potrait mode only for all device families - iPhone SE, 5, 5s, 6, 6s, 6Plus, 6Plus s, iPad, iPad mini, iPad Pro. The user interface is adaptive accross all these devices.


##### Gallery View Controller:  
This is the main and only View Controller in the app. This includes a Split View:

* The Split View has two main components, a Menu Bar and a Collection View Controller.
* The Collection View Controller has two cells, one of which contains a Table View Controller and the other contains a Collection View Controller.
** The Menu bar is used as a Custom Tab Bar to swich between the two cells of the Split View, to access either Table or Collection View.
** The Table View shows the Photos loaded from Flickr in full screen wide Square Views.
** The Table View also has a header cell that shows the Username of the Published of each Photo.
** The Table View has a Data Cell which displayes the Meta Data for the each Photo.


