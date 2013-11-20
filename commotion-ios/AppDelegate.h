//
//  AppDelegate.h
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "MeshDataSync.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

    UIWindow *window;
	UIView *_mainView;
	HomeViewController *rootViewController;
    IBOutlet UIView *_loadingView;
    MeshDataSync *meshSyncClass;
    
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (readonly) HomeViewController *rootViewController;

#pragma mark OLSRD Service & Mesh Polling
- (void) executeMeshDataPolling;
- (void) executeMeshDataPollingTest;

@end


