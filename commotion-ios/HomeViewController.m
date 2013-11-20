//
//  HomeViewController.m
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import "MeshStatusViewController.h"
#import "NodesViewController.h"
#import "HomeViewController.h"


@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        MeshStatusViewController *meshStatusViewController = [[MeshStatusViewController alloc] initWithNibName:@"MeshStatusViewController" bundle:nil];

        NodesViewController *nodesViewController = [[NodesViewController alloc] initWithNibName:@"NodesViewController" bundle:nil];
        
        [self setViewControllers:[NSArray arrayWithObjects: [[UINavigationController alloc] initWithRootViewController:meshStatusViewController],
              [[UINavigationController alloc] initWithRootViewController:nodesViewController], nil]];
        
    }
    return self;
}
//==========================================================
// - VIEW LIFECYCLE
//==========================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationBarHidden = NO;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	[(UINavigationController *)tabBarController.selectedViewController popToRootViewControllerAnimated:NO];
	return YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
