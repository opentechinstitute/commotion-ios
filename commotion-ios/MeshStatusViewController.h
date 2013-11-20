//
//  MeshStatusViewController.h
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import <UIKit/UIKit.h>

@interface MeshStatusViewController : UIViewController {
    
    UIImageView *navLogo;
    UIButton *navLabel;
    UILabel *navLabeltext;
    IBOutlet UILabel *SSID;
    IBOutlet UILabel *SSIDSmall;
    IBOutlet UILabel *BSSID;
    IBOutlet UILabel *IP;

    IBOutlet UILabel *connectedNodes;
    IBOutlet UILabel *status;
    
}

#pragma mark Initialization & Run Loop
-(void) addUIelements;

#pragma mark Process Data
-(void) proccessMeshData:(NSNotification *)fetchedMeshData;

#pragma mark WIFI Status
- (NSArray *)fetchWIFIStatus;
- (NSString *)fetchIPAddress;

@end
