//
//  AppDelegate.m
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    meshSyncClass = [[MeshDataSync alloc] init];

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(executeMeshDataPollingTest) userInfo:nil repeats:YES];
    [timer fire];
    
    // connection to local json data - fetch json
    //[self executeMeshDataPollingTest];
    // connection to localhost data - fetch json
    //[self executeMeshDataPolling];
    
	// load top level UIView
    _mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[self.window addSubview:_mainView];
    
    [_mainView addSubview:_loadingView];
    [self performSelector:@selector(_loadHomeView) withObject:nil afterDelay:1.00];   // was 0.01
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	[self.window makeKeyAndVisible];
    

    // remove tab bar gradient, replace with solid black bar
    UIImage *tabBackground = [[UIImage imageNamed:@"tab-bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage* tabBarShadow = [[UIImage imageNamed:@"tab-shadow"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:tabBarShadow];
        
    return YES;
}


- (void)_loadHomeView {
	[self showHomeView:YES];
    [_loadingView removeFromSuperview];
}


// DISPLAY HOME - tab bar controller
- (void)showHomeView:(BOOL)animated {
    //NSError *error = nil;

    ///////////////////////
    // HOME VIEW
    ///////////////////////
    
	// remove current view
    [[_mainView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // load home
	rootViewController = [[HomeViewController alloc] initWithNibName:nil bundle:nil];
    [_mainView addSubview: rootViewController.view];
    
}

//==========================================================
#pragma mark OLSRD Service & Mesh Polling
//==========================================================
- (void) executeMeshDataPolling {
    
    [meshSyncClass fetchHTTPMeshData];
    NSLog(@"Polling HTTP for data...");

}

- (void) executeMeshDataPollingTest {
    
    [meshSyncClass fetchLocalTestJson];
    NSLog(@"Polling Static JSON for data...");

}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
 {
 }
 */

/*
 // Optional UITabBarControllerDelegate method.
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
 {
 }
 */

@end
