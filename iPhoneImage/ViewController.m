//
//  ViewController.m
//  iPhoneImage
//
//  Created by Erin Luu on 2016-11-21.
//  Copyright © 2016 Erin Luu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView * iPhoneImageView;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //Create a new NSURL object from the iPhone image url string.
    NSURL *url = [NSURL URLWithString:@"http://imgur.com/y9MIaCS.png"];
    
    //NSURLSessionConfiguration defines the behavior and policies to use when making a request with an NSURLSession
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //Create an NSURLSession object using our session configuration (Configuration MUST be done before this
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3
    
    //Create task to download the image from the server
    //The session creates and configures the task and the task makes the request
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //location: The location of a file we just downloaded on the device.
        //response: Response metadata such as HTTP headers and status codes.
        //error: An NSError that indicates why the request failed, or nil when the request is successful.
        if (error) {
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        //In order to access this as a UIImage object, we need to first convert the file's binary into an NSData object,
        NSData *data = [NSData dataWithContentsOfURL:location];
        //Then create a UIImage from that data
        UIImage *image = [UIImage imageWithData:data];
        
        //Networking happens on a background thread and the UI can only be updated on the main thread
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            self.iPhoneImageView.image = image; // 4
        }];
    }];
    
    //A task is created in a suspended state, so we need to resume it. (Other Options: suspend, resume and cancel)
    [downloadTask resume];
}
@end
