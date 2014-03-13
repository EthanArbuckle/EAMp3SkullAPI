EAMp3SkullAPI
=============

Objective-C API wrapper for mp3skull.com.

This relies on AFNetworking and TFHpple.

Usage:

```objective-c

- (void)search {

    EAMP3SkullAPI *api = [[EAMP3SkullAPI alloc] init];
    [api setDelegate:self];
    [api performSearchWithQuery:@"say something"];
  
}

- (void)receivedDataFromAPI:(NSArray *)data {
    if ([[data[0] objectForKey:@"type"] intValue] == EATypeTop100)
        NSLog(@"top 100 received");
    
    if ([[data[0] objectForKey:@"type"] intValue] == EATypeSearchResults)
        NSLog(@"search results received");
}

- (void)failedToReceiveDataWithError:(NSError *)error {
    NSLog(@"failed %@", error);
}

```
