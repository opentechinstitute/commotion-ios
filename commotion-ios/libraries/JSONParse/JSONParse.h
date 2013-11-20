//
//  JSONParse.h
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import <UIKit/UIKit.h>

@interface JSONParse : NSObject

-(NSMutableDictionary*)readDataFromResponse:(NSData *)responseData;
-(NSMutableDictionary*)readDataFromJSONFile:(NSString*)filename;

@end