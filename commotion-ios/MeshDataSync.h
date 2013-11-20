//
//  MeshDataSync.h
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import <UIKit/UIKit.h>

@interface MeshDataSync : UIViewController <NSURLConnectionDelegate> {

    NSURLRequest *theRequest;
    NSURLConnection *theConnection;
    UIImageView *navLogo;
}


// Object properties
@property (nonatomic, retain) NSURL *downloadURL;
@property (nonatomic, retain) NSMutableData *downloadData;
@property (nonatomic, retain) NSString *downloadPath;
@property (nonatomic, retain) NSMutableDictionary *meshData;


#pragma mark HTTP & Test Mesh Data Processing
-(void) fetchHTTPMeshData;
-(void) fetchLocalTestJson;
-(void) readyHTTPMeshData:(NSData *)responseData;
-(void) readyLocalTestJson;

#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
