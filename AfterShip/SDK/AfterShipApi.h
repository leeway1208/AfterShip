//
//  ViewController.h
//  AfterShip
//
//  Created by liwei wang on 1/6/2016.
//
//
//Design the proper interface of API in SDK as opensour project, which is friendly to use and easy to maintain.
//
//Code an Android or iOS mobile SDK for the aftership API endpoints:
//
//POST /trackings
//GET /trackings/:slug/:tracking_number
//


#import <UIKit/UIKit.h>
@protocol AfterShipDelegate <NSObject>
@required
-(void)AfterShipFinishedRequest:(NSData*)responseData response:(NSURLResponse*)response;


@end



@interface AfterShipApi : NSObject



@property (assign, nonatomic) id<AfterShipDelegate> delegate;


-(void)trackingsPostRequest:(NSString *)trackingNumber ApiKey:(NSString *)myApiKey
;

-(void)trackingsGetRequest:(NSString *)myApiKey;

@end

