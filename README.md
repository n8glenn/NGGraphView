NGGraphView
===============

Simple graphing view.

![DemoGif](http://cl.ly/UxEx/graph.gif)

## Requirement
- ARC.
- iOS 6 or higher(tested on iOS 6 and 7).

## Install
### CocoaPods
Add `pod 'NGGraphView'` to your Podfile.

### Manually

1. Copy `NGGraphView` directory to your project.

## Usage

    #import "NGGraphView.h"
    #import "NGDataPoint.h"
    ...
    NGGraphView *_graphView; // add this to your view controller.

    // you will want to set up an IBOutlet like so...
    @property (nonatomic, retain) IBOutlet NGGraphView *graphView;

    // next you will go to your view in interface builder
    // add a new UIView, set the type to NGGraphView, and connect it 
    // to this variable.

    // finally you will want to initialize your graph view
    // set it's properties to customize it's appearance
    // and add some data to it...
    [_graphView setTitle:@"My Test Graph"];
    [_graphView setSubTitle:@"This is a test."];
    [_graphView setLineColor:[UIColor blueColor]];
    [_graphView setLineWidth:1.0];
    [_graphView setSegments:5];  // this graph is divided up into five sections.
    [_graphView setShowPoints:YES];
    [_graphView setPointSize:7];
    [_graphView setPointColor:[UIColor redColor]];
    // now add some data, the NGDataPoint is used to add data to the graph view.
    [_graphView addDataPoint:[NGDataPoint withLabel:@"first" andCount:3]];
    [_graphView addDataPoint:[NGDataPoint withLabel:@"second" andCount:10]];
    [_graphView addDataPoint:[NGDataPoint withLabel:@"third" andCount:7]];
    [_graphView addDataPoint:[NGDataPoint withLabel:@"fourth" andCount:15]];
    [_graphView addDataPoint:[NGDataPoint withLabel:@"fifth" andCount:19]];
    
### Customization
#### Property
You can customize below properties.

    [_graphView setTitle:@"My Test Graph"];
    [_graphView setSubTitle:@"This is a test."];
    [_graphView setLineColor:[UIColor blueColor]];
    [_graphView setLineWidth:1.0];
    [_graphView setSegments:5];
    [_graphView setShowPoints:YES];
    [_graphView setPointSize:7];
    [_graphView setPointColor:[UIColor redColor]];

## Author
Nate Glenn, n8glenn@gmail.com

## LICENSE
MIT
