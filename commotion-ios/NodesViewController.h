//
//  NodesViewController.h
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//

#import <UIKit/UIKit.h>

@interface NodesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    UIButton *navLabel;
    UILabel *navLabeltext;
    
    IBOutlet UILabel *connectedNodes;
    NSString *remoteip;
    NSString *localip;
    
    //IBOutlet UILabel *sequenceNumber;
    IBOutlet UILabel *status;
    
    NSURLRequest *theRequest;
    NSURLConnection *theConnection;
    UIImageView *navLogo;
    
    NSDictionary *meshJSON;
    NSArray *links;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;


#pragma mark Initialization & Run Loop
-(void) addUIelements;
//-(void) addProgressBars;

#pragma mark Process Data
-(void) proccessMeshData:(NSNotification *)fetchedMeshData;

#pragma mark TableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;


@end
