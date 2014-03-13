//
//  EAMP3SkullAPI.h
//  mp3skull
//
//  Created by Ethan Arbuckle on 3/12/14.
//  Copyright (c) 2014 Ethan Arbuckle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "TFHpple.h"

typedef enum {
    
    EATypeTop100 = 0,
    EATypeSearchResults
    
} EADataReturnTypes;

@protocol EAMP3SkullAPIDelegate <NSObject>

- (void)recievedDataFromAPI:(NSArray *)data;
- (void)failedToRecieveDataWithError:(NSError *)error;

@end

@interface EAMP3SkullAPI : NSObject

@property (retain, nonatomic) id <EAMP3SkullAPIDelegate> delegate;

- (void)getTop100;
- (void)getResultsFromUrl:(NSString *)passedUrl;
- (void)performSearchWithQuery:(NSString *)searchQuery;

@end
