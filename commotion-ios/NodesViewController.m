//
//  NodesViewController.m
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import "NodesViewController.h"
#import "PDColoredProgressView.h"

@implementation NodesViewController

@synthesize tableView;

//==========================================================
#pragma mark Initialization & Run Loop
//==========================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.tabBarItem.image = [UIImage imageNamed:@"nodeStatusTab"];
        self.tabBarItem.title = @"Nodes";

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
    [self addUIelements];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //NSLog(@"viewWillAppear NodesViewController");
}


// this method is used to insert add/delete button to show the demonstrate the add/delete function
- (void)addUIelements
{
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
    
    //[self addProgressBars];
}

//==========================================================
#pragma mark Process Data
//==========================================================
-(void) proccessMeshData:(NSNotification *)fetchedMeshData {
    
    //NSLog(@"proccessMeshData: %@", [fetchedMeshData userInfo]);
    
    meshJSON = [fetchedMeshData userInfo];
    
    /******************/
    /*** INTERFACES ***/
    /******************/
    /**
    NSArray *interfaces = [meshJSON objectForKey:@"interfaces"];

    for (NSDictionary *interface in interfaces) {
        sequenceNumber.text = [NSString stringWithFormat:@"%@", [interface objectForKey:@"olsrMessageSequenceNumber"]];
    }
    **/
    
    /*************/
    /*** LINKS ***/
    /*************/
    links = [meshJSON objectForKey:@"links"];

    /**
    for (NSDictionary *link in links) {
        //NSLog(@"%@", link);
        //remoteip = [link objectForKey:@"remoteIP"];
        //localip = [link objectForKey:@"localIP"];
    }
    **/
    
    int linkCount = [links count];
    connectedNodes.text = [NSString stringWithFormat:@"%i", linkCount];
    
    [tableView reloadData];

}



//==========================================================
#pragma mark TableView
//==========================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [links count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *cellLabel;
    UILabel *cellTextLeadingNumber;
    UILabel *cellTextEndingNumber;
    PDColoredProgressView *linkQualityProgressView;
    NSDictionary *linksDict = [links objectAtIndex:indexPath.row];
    
    // get link quality values
    CGFloat nlq = [[linksDict objectForKey:@"neighborLinkQuality"] floatValue];
    CGFloat lq = [[linksDict objectForKey:@"linkQuality"] floatValue];
    CGFloat linkQuality = (lq*nlq);
    //NSLog(@"linkquality: %f", lq);
    //NSLog(@"neighborlinkquality: %f", nlq);
    //NSLog(@"(lq*nlq): %f", (lq*nlq));
    
    //cell=nil;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        /*** REMOTE IP ***/
        cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 290, 37)];
        cellLabel.numberOfLines = 1;
        cellLabel.textColor = [UIColor colorWithRed:91.0f/255.0f green:91.0f/255.0f blue:91.0f/255.0f alpha:1.0f];
        cellLabel.font = [UIFont boldSystemFontOfSize:16];
        cellLabel.backgroundColor = [UIColor clearColor];
        cellLabel.numberOfLines = 1;
        cellLabel.tag = 2;
        [cell.contentView addSubview:cellLabel];
        
        /*** LEADING NUMBER (0) ***/
        cellTextLeadingNumber = [[UILabel alloc] initWithFrame:CGRectMake(17, 2, 290, 82)];
        cellTextLeadingNumber.textColor = [UIColor colorWithRed:91.0f/255.0f green:91.0f/255.0f blue:91.0f/255.0f alpha:1.0f];
        cellTextLeadingNumber.font = [UIFont systemFontOfSize:13];
        cellTextLeadingNumber.backgroundColor = [UIColor clearColor];
        cellTextLeadingNumber.tag = 3;
        [cell.contentView addSubview:cellTextLeadingNumber];
        
        /*** ENDING NUMBER (100) ***/
        cellTextEndingNumber = [[UILabel alloc] initWithFrame:CGRectMake(275, 2, 290, 82)];
        cellTextEndingNumber.textColor = [UIColor colorWithRed:91.0f/255.0f green:91.0f/255.0f blue:91.0f/255.0f alpha:1.0f];
        cellTextEndingNumber.font = [UIFont systemFontOfSize:13];
        cellTextEndingNumber.backgroundColor = [UIColor clearColor];
        cellTextEndingNumber.tag = 3;
        [cell.contentView addSubview:cellTextEndingNumber];
        
        /*** PROGRESS BARS ***/
        linkQualityProgressView = [[PDColoredProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleDefault];
        CGRect frame = linkQualityProgressView.frame;
        frame.size.height = 15;
        frame.size.width = 236;
        frame.origin.x = 32;
        frame.origin.y = 36;
        linkQualityProgressView.frame = frame;
        linkQualityProgressView.tag = 4;
        
        [cell.contentView addSubview:linkQualityProgressView];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        // show the cached copy
        cellLabel = (UILabel *) [cell viewWithTag:2];
        cellTextLeadingNumber = (UILabel *) [cell viewWithTag:3];
        linkQualityProgressView = (PDColoredProgressView *) [cell viewWithTag:4];
    }
    
    
    // set remoteIP title
    cellLabel.text = [linksDict objectForKey:@"remoteIP"];
    // set leading and ending number in cell
    cellTextLeadingNumber.text = [NSString stringWithFormat:@"0"];
    cellTextEndingNumber.text = [NSString stringWithFormat:@"1"];
    // set link quality progress bar
    [linkQualityProgressView setTintColor: [UIColor colorWithRed:255.0/255.0 green:115.0/255.0 blue:156.0/255.0 alpha:1.0]];
    [linkQualityProgressView setProgress:linkQuality animated: YES];

    
    return cell;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    tableView=nil;

}


@end

