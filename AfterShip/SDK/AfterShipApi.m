//
//  ViewController.m
//  AfterShip
//
//  Created by liwei wang on 1/6/2016.
//
//

#import "AfterShipApi.h"

#define REQUEST_URL @"https://api.aftership.com/v4/trackings"
#define REQUEST_TIME_OUT 30.0


@interface AfterShipApi (){
    NSInteger lastMinute;
    BOOL disableRequest;
    
}

@end

@implementation AfterShipApi

@synthesize delegate;

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)trackingsPostRequest:(NSString *)trackingNumber ApiKey:(NSString *)myApiKey
{
    //    if([delegate respondsToSelector:@selector(textEntered:)])
    //    {
    //        //send the delegate function with the amount entered by the user
    //
    //    }
    NSLog(@"post");
    
    [self httpRequest:trackingNumber ApiKey:myApiKey method:@"POST"];
    
    
}

-(void)trackingsGetRequest:(NSString *)myApiKey{
    //    if([delegate respondsToSelector:@selector(textEntered:)])
    //    {
    //        //send the delegate function with the amount entered by the user
    //
    //    }
    
    NSLog(@"get");
    
    [self httpRequest:@"" ApiKey:myApiKey method:@"GET"];
    
    
}




- (void)httpRequest:(NSString *)trackingNumber ApiKey:(NSString *)myApiKey method:(NSString *)httpRequestMethod
{
    if (disableRequest) {
        
        if ([self getCurrentMinute] != lastMinute) {
            disableRequest = NO;
        }
        
    }else{
        NSString *urlStr = REQUEST_URL;
        NSURL *url = [NSURL URLWithString:urlStr];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:REQUEST_TIME_OUT];
        request.HTTPMethod = httpRequestMethod;
        
        
        
        
        [request addValue:myApiKey forHTTPHeaderField:@"aftership-api-key"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:[NSString stringWithFormat:@"aftership-ios-sdk %@",[self getSDKversion]] forHTTPHeaderField:@"aftership-user-agent"];
        
        
        if ([httpRequestMethod isEqualToString:@"POST"]) {
            NSDictionary *trackingNumberDict = [NSDictionary dictionaryWithObject:trackingNumber forKey:@"tracking_number"];
            
            NSDictionary * trackingDict = [NSDictionary dictionaryWithObject:trackingNumberDict forKey:@"tracking"];

            
            NSData *requestData = [NSJSONSerialization dataWithJSONObject:trackingDict options:0 error:nil];
            
            [request setHTTPBody:requestData];
            
            
            
        }
        
        
        
        
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
        
        NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                if ([response respondsToSelector:@selector(allHeaderFields)]) {
                    NSDictionary *dictionary = [(NSHTTPURLResponse *)response allHeaderFields];
                    
                    if([[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"x-ratelimit-remaining"]] intValue] <= 0 ){
                        
                        lastMinute = [self getCurrentMinute];
                        
                        disableRequest = YES;
                        
                    }else{
                        
                        [delegate AfterShipFinishedRequest:data response:response];
                        
                    }
                }
                
                
                
            }
        }];
        [dataTask resume];
        

    }
    
    
}

-(NSInteger )getCurrentMinute{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

    NSLog(@"%ld",(long)[dateComponent minute]);
    
    return  [dateComponent minute];
    
    
    
}


-(NSString *) getSDKversion{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return appVersion;
}




@end
