//
//  EAMP3SkullAPI.m
//  mp3skull
//
//  Created by Ethan Arbuckle on 3/12/14.
//  Copyright (c) 2014 Ethan Arbuckle. All rights reserved.
//

#import "EAMP3SkullAPI.h"

@implementation EAMP3SkullAPI

/*
 This returns an array with 100 objects.
 Each object is an nsdictionary containing a type, title, and url.
 The key 'type' returns EATypeTop100.
 The key 'title' returns the song name.
 The key 'location' returns the full url.
 Note: The url of each of these songs acts as a search query for that title. (same as the site does).
*/
- (void)getTop100 {
    
    //create url
    NSString *constructUrl = @"http://mp3skull.com/top.html";
	NSURL *url = [NSURL URLWithString:constructUrl];
    
    //create operation
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    
    //create operation blocks
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //create container array
        NSMutableArray *container = [[NSMutableArray alloc] init];
        
        //setup parser
	    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:responseObject];
        
        //setup nodes
	    NSArray *posts = [htmlParser searchWithXPathQuery:@"//div[@id='content']/div"];
        
        //cycle through elements
        for (TFHppleElement *tree1 in posts) {
            
            //get title
            NSString *songTitle = [[[[tree1 children][3] children][1] children][0] content];
            
            //get url
            NSString *halfUrl = [(NSDictionary *)[[[tree1 children][3] children][1] attributes] objectForKey:@"href"];
            NSString *songUrl = [NSString stringWithFormat:@"http://mp3skull.com%@", halfUrl];
            
            //create dictionary to contain song info
            NSDictionary *songDictionary = @{ @"type" : @(EATypeTop100), @"title" : songTitle, @"location" : songUrl };
            
            //add song to container
            [container addObject:songDictionary];
            
        }
        
        //send data to delegate
        [_delegate recievedDataFromAPI:[container copy]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       //send error message to delegate
        [_delegate failedToRecieveDataWithError:error];
        
    }];
    
    //run operation
    [op start];
}

/*
 This returns an array with the search results.
 Each object is an nsdictionary containing a type, title, and download location url.
 The key 'type' returns EATypeSearchResults.
 The key 'title' returns the song name.
 The key 'download-location' returns a url to the songs direct download
 Note: Sometimes the download locations 404. This is an error with mp3skull's website
 */
- (void)getResultsFromUrl:(NSString *)passedUrl {
    
    //create url
	NSURL *url = [NSURL URLWithString:passedUrl];
    
    //create operation
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url]];
    
    //create operation blocks
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //create container array
        NSMutableArray *container = [[NSMutableArray alloc] init];
        
        //setup parser
	    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:responseObject];
        
        //setup nodes
	    NSArray *posts = [htmlParser searchWithXPathQuery:@"//div[@id='song_html']"];
        
        //cycle through elements
        for (TFHppleElement *tree1 in posts) {
            
            //get title
            NSString *songTitle = [[[[tree1 children][3] children][1] children][0] text];
            
            //get download location
            NSString *songDownloadURL = [(NSDictionary *)[[[[[[tree1 children][3] children][5] children][1] children][1] children][0] attributes] objectForKey:@"href"];
            
            //create dictionary to contain song info
            NSDictionary *songDictionary = @{ @"type" : @(EATypeSearchResults), @"title" : songTitle, @"download-location" : songDownloadURL };
            
            //add song to container
            [container addObject:songDictionary];

        }
        
        //send data to delegate
        [_delegate recievedDataFromAPI:[container copy]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //send error message to delegate
        [_delegate failedToRecieveDataWithError:error];
        
    }];
    
    //run operation
    [op start];

}

/*
 This method takes a string and converts it into a url.
 The URL is then sent to the getResultsFromUrl method where the posts are processed.
 The return type is exacly the same as getResultsFromUrl, as thats the method that does all the work.
*/
- (void)performSearchWithQuery:(NSString *)searchQuery {
    
    //replace spaces with underscored
    NSString *newSearch = [searchQuery stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    //construct url with search
    NSString *url = [NSString stringWithFormat:@"http://mp3skull.com/mp3/%@.html", newSearch];
    
    //make request
    [self getResultsFromUrl:url];
    
}

@end
