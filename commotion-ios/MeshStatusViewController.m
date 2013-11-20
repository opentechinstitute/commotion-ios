//
//  MeshStatusViewController.m
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import "MeshStatusViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation MeshStatusViewController

//==========================================================
#pragma mark Initialization & Run Loop
//==========================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.tabBarItem.image = [UIImage imageNamed:@"meshStatusTab"];
        self.tabBarItem.title = @"Mesh Status";
        
        // listen for mesh data fetch to return
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(proccessMeshData:)
                                                     name:@"meshJsonReady"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // build ui
    [self addUIelements];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSLog(@"viewWillAppear MeshStatusViewController");
}


// this method is used to insert add/delete button to show the demonstrate the add/delete function
- (void)addUIelements
{
    NSArray *wifiStatusElements = [self fetchWIFIStatus];

    SSID.text = [wifiStatusElements objectAtIndex:0];
    SSIDSmall.text = [wifiStatusElements objectAtIndex:0];
    BSSID.text = [wifiStatusElements objectAtIndex:1];
    IP.text = [self fetchIPAddress];
    
    //NSLog(@"SSID: %@", SSID.text);
    //NSLog(@"BSSID: %@", BSSID.text);
    //NSLog(@"IP: %@", IP.text);
    
    /*** NAV BACKGROUND COLOR ***/
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:115.0/255.0 blue:156.0/255.0 alpha:1.0];
    self.navigationController.wantsFullScreenLayout = YES;
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    /******** BG LABEL *********/
    navLabel = [[UIButton alloc] initWithFrame:CGRectMake(-12, 0, 345, 47)];
    navLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"headBg.png"]];
    
    navLogo = [[UIImageView alloc] initWithFrame:CGRectMake(19, 0, 66, 47)];
    UIImage *logoHeadImage = [UIImage imageNamed:@"logoHead"];
    navLogo.image = logoHeadImage;
    [navLogo setOpaque:YES];
    [navLabel addSubview:navLogo];
    
    
    navLabeltext = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 118, 43)];
    navLabeltext.backgroundColor = [UIColor clearColor];
    navLabeltext.numberOfLines = 1;
    navLabeltext.textColor = [UIColor blackColor];
    navLabeltext.font = [UIFont systemFontOfSize:18];
    [navLabeltext setOpaque:YES];
    [navLabel addSubview:navLabeltext];
    
    [self.navigationController.navigationBar addSubview:navLabel];    
    
}

//==========================================================
#pragma mark Process Data
//==========================================================
-(void) proccessMeshData:(NSNotification *)fetchedMeshData {
    
    //NSLog(@"proccessMeshData: %@", [fetchedMeshData userInfo]);
    
    NSDictionary *meshJSON = [fetchedMeshData userInfo];
    
    //NSString *olsrdState = [meshData valueForKey:@"state"];
    //NSString *meshLocalIP = [meshData valueForKey:@"localIP"];
    //NSString *meshRemoteIP = [meshData valueForKey:@"remoteIP"];
    //NSString *meshLinkQuality = [meshData valueForKey:@"linkQuality"];
    //[localIP setStringValue:[NSString stringWithFormat:@"IP Address: %@", meshLocalIP]];
    //[olsrdStatus setStringValue:[NSString stringWithFormat:@"OLSRD: %@", olsrdState]];
    
    //NSLog(@"%s: meshData: %@", __FUNCTION__, meshData);
    
    NSArray *links = [meshJSON objectForKey:@"links"];
    NSArray *interfaces = [meshJSON objectForKey:@"interfaces"];
    
    int linkCount = [links count];
    connectedNodes.text = [NSString stringWithFormat:@"%i", linkCount];
    //NSLog(@"You are connected to %i nodes.", linkCount);
    
    if (interfaces) {
        for (NSDictionary *interface in interfaces) {
            NSString *state = ([[interface objectForKey:@"state"] isEqualToString:@"up"] ? @"Running" : @"Stopped");
            status.text = state;        
        }
    }
}

//==========================================================
#pragma mark WIFI Status
//==========================================================
- (NSArray *)fetchWIFIStatus {

    NSString
    *wifiSSID = @"";
    NSString *wifiBSSID = @"";
    NSArray *wifiStatus = @[];
    CFArrayRef wifiArray = CNCopySupportedInterfaces();
    
    
    if (wifiArray != nil){
        NSDictionary* wifiDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(wifiArray, 0));
        
        //NSLog(@"myArray: %@", wifiDict);
        
        if (wifiDict!=nil){
            wifiSSID=[wifiDict valueForKey:@"SSID"];
            wifiBSSID=[wifiDict valueForKey:@"BSSID"];
        } else {
            wifiSSID=@"searching...";
            wifiBSSID=@"searching...";
        }
    }
    else {
        wifiSSID=@"searching...";
        wifiBSSID=@"searching...";
    }
    
    wifiStatus = @[wifiSSID, wifiBSSID];
    
    return wifiStatus;
}

// Get IP Address
- (NSString *)fetchIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
} 


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
