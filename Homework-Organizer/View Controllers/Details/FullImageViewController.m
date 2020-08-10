//
//  FullImageViewController.m
//  Homework-Organizer
//
//  Created by Julie Herrick on 7/15/20.
//  Copyright © 2020 Julie Herrick. All rights reserved.
//

#import "FullImageViewController.h"
#import "Assignment.h"

@interface FullImageViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation FullImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.file = self.assignment.image;
//    [self.imageView loadInBackground];
    

}



//- (IBAction)scaleImage:(UIPinchGestureRecognizer *)gestureRecognizer {
//    CGFloat lastScale = 0.0;
//    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
//    // Reset the last scale, necessary if there are multiple objects with different scales.
//        lastScale = [gestureRecognizer scale];
//    }
//
//    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
//    [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
//
//     CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
//
//    // Constants to adjust the max/min values of zoom.
//    const CGFloat kMaxScale = 2.0;
//    const CGFloat kMinScale = 1.0;
//
//     CGFloat newScale = 1 -  (lastScale - [gestureRecognizer scale]); // new scale is in the range (0-1)
//     newScale = MIN(newScale, kMaxScale / currentScale);
//     newScale = MAX(newScale, kMinScale / currentScale);
//     CGAffineTransform transform = CGAffineTransformScale([[gestureRecognizer view] transform], newScale, newScale);
//     [gestureRecognizer view].transform = transform;
//
//     lastScale = [gestureRecognizer scale];  // Store the previous. scale factor for the next pinch gesture call
//     }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
