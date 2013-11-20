//
//  JSONParse.m
//  commotion-ios
//
//  Created by Bradley @ Scal.io, LLC (http://scal.io)
//
//

#import "JSONParse.h"

@implementation JSONParse


-(NSMutableDictionary*)readDataFromResponse:(NSData *)responseData {
    
    // convert to JSON
    NSError *myError = nil;
    NSMutableDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    return jsonDict;
}

- (NSMutableDictionary*)readDataFromJSONFile:(NSString*)filename {
    
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    NSError *fileError;
    
    // Create a JSON String from the JSON file contents
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&fileError];
    if (fileError)
        NSLog(@"Error parsing JSON File: %@", fileError);
    
    // If we don't have a valid JSON object, return the empty array
    if ([NSJSONSerialization isValidJSONObject:jsonString])
        return jsonDict;
    
    //NSLog(@"jsonString: %@", jsonString);
    
    // Create the JSON Object from the string
    NSError *error;
    jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];

    if (!jsonDict)
        NSLog(@"Error parsing JSON: %@", error);
    
    return jsonDict;
}

@end