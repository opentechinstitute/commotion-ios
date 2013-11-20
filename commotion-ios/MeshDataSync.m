//
//  MeshDataSync.m
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import "MeshDataSync.h"
#import "JSONParse.h"

@implementation MeshDataSync

@synthesize downloadURL, downloadData, downloadPath, meshData;


//==========================================================
#pragma mark Initialization & Run Loop
//==========================================================
-(id) init {
    //NSLog(@"MeshDataSync: init");
    
	if (![super init]) return nil;
    
    // connection to local json data - fetch json
    //[self processLocalTestJson];
    
    // connection to localhost data - fetch json
    //[self fetchHTTPMeshData];
        
    return self;
}


//==========================================================
#pragma mark HTTP & Test Mesh Data Processing
//==========================================================

-(void) fetchHTTPMeshData {
    
    NSString *downloadString = @"http://localhost:9090";
    
    // Create the request.
    theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:downloadString]
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                            timeoutInterval:60.0];
    
    
    downloadData = [NSMutableData dataWithCapacity: 0];
    
    theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    if (!theConnection) {
        // Release the receivedData object.
        downloadData = nil;
        NSLog(@"downloadConnection FAILED");
    }
}

-(void) fetchLocalTestJson {
        
    [self readyLocalTestJson];
}

- (void) readyHTTPMeshData:(NSData *)responseData {
        
    JSONParse* jsonParse = [[JSONParse alloc] init];
    // Read the file, return an array with our JSON objects as NSDictionaries
    NSDictionary *jsonDict = [jsonParse readDataFromResponse:responseData];
    
    //NSLog(@"%s: %@", __FUNCTION__, jsonDict);

    // post notification that JSON is received and ready to be processed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"meshJsonReady" object:nil userInfo:jsonDict];
}

-(void) readyLocalTestJson {
    
    JSONParse* jsonParse = [[JSONParse alloc] init];
    
    // Read the file, return an array with our JSON objects as NSDictionaries
    NSDictionary *jsonDict = [jsonParse readDataFromJSONFile:@"hans-all"];
    
    //NSLog(@"%s: %@", __FUNCTION__, jsonDict);

    // post notification that JSON is received and ready to be processed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"meshJsonReady" object:nil userInfo:jsonDict];
}


//==========================================================
#pragma mark NSURLConnection Delegates
//==========================================================

// NSURLConnectionDelegate method: handle the initial connection
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"%s: didReceiveResponse", __FUNCTION__);
    [downloadData setLength:0];
}

// NSURLConnectionDelegate method: handle data being received during connection
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [downloadData appendData:data];
    //NSLog(@"downloaded %lu bytes", [data length]);
}

// NSURLConnectionDelegate method: What to do once request is completed
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self readyHTTPMeshData: downloadData];
    
    theConnection = nil;
    downloadData = nil;
}

// NSURLConnectionDelegate method: Handle the connection failing
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    theConnection = nil;
    downloadData = nil;
    
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    // send a nil dict to indicate the process failed
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"meshDataProcessingComplete" object:nil userInfo:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
