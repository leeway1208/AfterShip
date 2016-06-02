# AfterShip

1. # Import
import "AfterShipApi.h"

2. # Set Delegate
AfterShipDelegate

3. # Initialize 
AfterShipApi *aft = [[AfterShipApi alloc]init];
aft.delegate = self;

4. # get
[aft trackingsGetRequest:TEST_API_KEY];

4. # post
[aft trackingsPostRequest:TEST_TRACKING_NUMBER ApiKey:TEST_API_KEY];

5. # get the response
(void)AfterShipFinishedRequest:(NSData*)responseData response:(NSURLResponse *)response
