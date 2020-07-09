Original App Design Project
===

# Homework Organizer

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Upload your assignments, the estimated time you think it will take to complete them, and the due date. Use the app to track your progress with your homework to makesure you don't miss a deadline

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Productivity
- **Mobile:** Yes
- **Story:** Allows users to keep track of their homework assignments to help them finish on time
- **Market:** Students
- **Habit:** Homework is very frequent so I think it would be habit forming to check when your assignments are due
- **Scope:** Store assignment progress and give notfications close to the due date

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can log in/out using facebook [would this use facebook SDK?]
* User can create a new account
* User can add a new assignment
* User can add a class and due date to assignment
* User can view a list of all assignments
* Users can view assignment due dates on calendar
* User can switch between tabs of a list of assignments and a calendar
* User can swipe to delete assignments
* User can add subtasks to their assignments
* User can check off subtasks and progress bar will reflect completion status
* User can attatch photograph to assignments
* ...

**Optional Nice-to-have Stories**

* User can view their profile
* User can input their classes on their profile
* User can group assignments by class 
* User can get notifications
* User can customize notification time/frequency 
* Assignment will automatically disappear after due date has passed
* ...

### 2. Screen Archetypes

* Login
   * User can log in/out using facebook 
   * User can create a new account
* Assignments List
   * User can view a list of assignments
   * User can add a new assignment
   * User can swipe to delete an assignment

* Add Assignment
   * User can add new assignment
   * User can add due date
   
* Assignment Detail
   * user can view the details of the assignment

* Calendar
    * User can view assignment due dates on calendar

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Assignment List
* Calendar View

**Flow Navigation** (Screen to Screen)

* Login Screen
    => Assignment List
* Assignment List
    => Add Assignment
    => Assignment details
* Assignment Details
    => Assignment List
* Create Assignment
    => Assignment List
* Calendar View
    => none

## Wireframes
<img src="https://i.postimg.cc/vB67Rfvt/IMG-3435.jpg" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
### Models
#### Assignment
 | Property      | Type     | Description |
 | ------------- | -------- | ------------|
 | objectId      | String   | Unique id for the user assignment (default field) |
 | author        | Pointer to User | Author of assignment |
 | title         | String   | Name of the assignment |
 | class         | String   | The name of the class the assignment is for |
 | due_date      | DateTime | The date the assignment is due |
 | tasks         | Array    | An array of subtasks |
 | Progress      | Number   | Based on the number of subtasks stores the proportion completed |
 | completed     | Boolean  | Stores if the task is completed |
 | image         | File     | User can attach image |
 
 #### Subtask
  | Property      | Type     | Description |
  | ------------- | -------- | ------------|
  | objectId      | String   | Unique id for the user subtask (default field) |
  | description   | String   | Description of subtask |
  | completed     | Boolean  | Stores if the task has been completed |


### Networking
#### List of network requests by screen
- Assignment List Screen
  - (Read/GET) Query all assignments where user is author
    ```objective c
    PFQuery *query = [PFQuery queryWithClassName:@"Assignment"];
    [query whereKey:@"author" equalTo: currentuser];
    query.order(byDescending: "createdAt");
 
    [query findObjectsInBackgroundWithBlock:^(NSArray *assignments, NSError *error) {
      if (assignments != nil) {
          NSLog(@"Succesfully retrieved assignments");
          // TODO: Something with assignments
      } else {
          NSLog(@"%@", error.localizedDescription);
      }
    }];
    ```
  - (Update/PUT) Mark assignment as completed
  - (Delete) Delete assignment
- Create Assignment Screen
  - (Create/ADD) Create new Assignment
- Assignment Detials Screen
  - (Update/PUT) Edit assignment details
  
  #### Network Request Actions
     CRUD    | HTTP Verb | Example
   ----------|-----------|------------
    Create   | `ADD`     | Creating a new assignment
    Read     | `GET`     | Fetch assignments from user
    Update   | `PUT`     | Update assignment information
    Delete   | `DELETE`  | Delete an assignment

- [OPTIONAL: List endpoints if using existing API such as Yelp]
