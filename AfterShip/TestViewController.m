//
//  TestViewController.m
//  AfterShip
//
//  Created by liwei wang on 1/6/2016.
//
//

#import "TestViewController.h"
#import "AfterShipApi.h"

#define TEST_TRACKING_NUMBER @"1ZAE9558YW00052224"
#define TEST_API_KEY @"abf9184b-34c7-4717-9e9b-30d65d8c97c4"


@interface TestViewController ()<AfterShipDelegate ,UITextFieldDelegate , UITextViewDelegate>{
    int textHeight;
    AfterShipApi *aft;
}
@property (strong,nonatomic) UILabel *trackingNumberLbl;
@property (nonatomic,strong) UITextField * trackingNumberTf;
@property (strong,nonatomic) UILabel *ApiKeyLbl;
@property (nonatomic,strong) UITextField * ApiKeyTf;

@property (strong,nonatomic) UILabel *ratelimitLbl;

@property (nonatomic,strong) UITextView * jsonResponseTv;
@property (strong,nonatomic) UIButton *postBtn;
@property (strong,nonatomic) UIButton *getBtn;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self loadParameter];
    [self loadWidget];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"AfterShip API Test";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadParameter {
    
    
    aft = [[AfterShipApi alloc]init];
    aft.delegate = self;
    
    //注册键盘弹起与收起通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BasicRegkeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(BasicRegkeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    
}

- (void)loadWidget {
    self.view.backgroundColor=[UIColor colorWithRed:0.925 green:0.925   blue:0.925  alpha:1.0f];
    
    
    _trackingNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10,self.view.frame.size.width - 40, 20)];
    _trackingNumberLbl.text = @"Tracking Number:";
    [_trackingNumberLbl setFont:[UIFont systemFontOfSize:12] ];
    [_trackingNumberLbl setTextColor:[UIColor blackColor]];
    [_trackingNumberLbl setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_trackingNumberLbl];
    
    _trackingNumberTf =[[UITextField alloc] initWithFrame:self.view.bounds];
    _trackingNumberTf.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;    _trackingNumberTf.backgroundColor = [UIColor whiteColor];
    _trackingNumberTf.frame = CGRectMake(20, 30,self.view.frame.size.width - 40, 25);
    _trackingNumberTf.clearButtonMode=UITextFieldViewModeNever;
    _trackingNumberTf.leftViewMode=UITextFieldViewModeAlways;
    _trackingNumberTf.delegate = self;
    _trackingNumberTf.text = TEST_TRACKING_NUMBER;
    _trackingNumberTf.layer.cornerRadius=8.0f;
    _trackingNumberTf.layer.masksToBounds=YES;
    _trackingNumberTf.layer.borderWidth= 1.0f;
    _trackingNumberTf.layer.borderColor=[[UIColor colorWithRed:0.733 green:0.737 blue:0.737 alpha:1]CGColor];
    _trackingNumberTf.keyboardType=UIKeyboardTypeDefault;    _trackingNumberTf.returnKeyType=UIReturnKeyDefault;    [self.view addSubview:_trackingNumberTf];
    
    
    
    _ApiKeyLbl = [[UILabel alloc]initWithFrame:CGRectMake(20,  55 + 20 - 20,self.view.frame.size.width - 40, 20)];
    _ApiKeyLbl.text = @"Api Key:";
    [_ApiKeyLbl setFont:[UIFont systemFontOfSize:12] ];
    [_ApiKeyLbl setTextColor:[UIColor blackColor]];
    [_ApiKeyLbl setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_ApiKeyLbl];
    
    _ApiKeyTf =[[UITextField alloc] initWithFrame:self.view.bounds];
    _ApiKeyTf.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _ApiKeyTf.backgroundColor = [UIColor whiteColor];
    _ApiKeyTf.frame = CGRectMake(20, 55 + 20,self.view.frame.size.width - 40, 25);
    _ApiKeyTf.clearButtonMode=UITextFieldViewModeNever;
    _ApiKeyTf.leftViewMode=UITextFieldViewModeAlways;
    _ApiKeyTf.delegate = self;
    _ApiKeyTf.text = TEST_API_KEY;
    _ApiKeyTf.layer.cornerRadius=8.0f;
    _ApiKeyTf.layer.masksToBounds=YES;
    _ApiKeyTf.layer.borderWidth= 1.0f;
    _ApiKeyTf.layer.borderColor=[[UIColor colorWithRed:0.733 green:0.737 blue:0.737 alpha:1]CGColor];
    _ApiKeyTf.keyboardType=UIKeyboardTypeDefault;
    _ApiKeyTf.returnKeyType=UIReturnKeyDefault;
    [self.view addSubview:_ApiKeyTf];
    
    
    
    
    _postBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 140,120, 120, 30)];
    [_postBtn setTitle:@"post" forState:UIControlStateNormal];
    [_postBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_postBtn setBackgroundColor: [UIColor clearColor]];
    [_postBtn addTarget:self action:@selector(postBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_postBtn.layer setMasksToBounds:YES];
    [_postBtn.layer setCornerRadius:4.0];
    [_postBtn.layer setBorderWidth:2.0];
    [_postBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.view  addSubview:_postBtn];
    
    
    _getBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 20, 120 , 120, 30)];
    [_getBtn setTitle:@"get" forState:UIControlStateNormal];
    [_getBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_getBtn setBackgroundColor: [UIColor clearColor]];
    [_getBtn addTarget:self action:@selector(getBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_getBtn.layer setMasksToBounds:YES];
    [_getBtn.layer setCornerRadius:4.0];
    [_getBtn.layer setBorderWidth:2.0];
    [_getBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.view  addSubview:_getBtn];
    
    
    
    _ratelimitLbl = [[UILabel alloc]initWithFrame:CGRectMake(20,  200 - 20,self.view.frame.size.width - 40, 20)];
    _ratelimitLbl.text = @"-ratelimit-remaining:";
    [_ratelimitLbl setFont:[UIFont systemFontOfSize:12] ];
    [_ratelimitLbl setTextColor:[UIColor blackColor]];
    [_ratelimitLbl setTextAlignment:NSTextAlignmentLeft];
    [self.view addSubview:_ratelimitLbl];

    
    
    _jsonResponseTv =[[UITextView alloc] initWithFrame:self.view.bounds];
    _jsonResponseTv.backgroundColor = [UIColor whiteColor];
    _jsonResponseTv.frame = CGRectMake(20, 200,self.view.frame.size.width - 40, self.view.frame.size.height - 180 - 100);
    _jsonResponseTv.delegate = self;
    _jsonResponseTv.layer.cornerRadius=8.0f;
    _jsonResponseTv.layer.masksToBounds=YES;
    _jsonResponseTv.layer.borderWidth= 1.0f;
    _jsonResponseTv.layer.borderColor=[[UIColor colorWithRed:0.733 green:0.737 blue:0.737 alpha:1]CGColor];
    _jsonResponseTv.keyboardType=UIKeyboardTypeDefault;
    _jsonResponseTv.returnKeyType=UIReturnKeyDefault;
    [self.view addSubview:_jsonResponseTv];
    
}


-(void)getBtnAction{
    
    [aft trackingsGetRequest:TEST_API_KEY];
}


-(void)postBtnAction{
    
    [aft trackingsPostRequest:TEST_TRACKING_NUMBER ApiKey:TEST_API_KEY];
    
}



-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.trackingNumberTf resignFirstResponder];
    [self.ApiKeyTf resignFirstResponder];
    [self.jsonResponseTv resignFirstResponder];
}

-(void)BasicRegkeyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"Drive_Height-keyboardSize.height-48 (%f)",self.view.frame.size.height - keyboardSize.height - 48);
    
    //自适应代码（输入法改变也可随之改变）
    if((self.view.frame.size.height - keyboardSize.height - 48)<textHeight)
    {
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0.0f, -(textHeight-(self.view.frame.size.height-keyboardSize.height-48)), self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)BasicRegkeyboardWillHide:(NSNotification *)note
{
    
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if((self.view.frame.size.height-keyboardSize.height-48)<textHeight)
    {
        //还原
        [UIView beginAnimations:nil context:NULL];//此处添加动画，使之变化平滑一点
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}

#pragma mark --  delegate

- (void)AfterShipFinishedRequest:(NSData*)responseData response:(NSURLResponse *)response{
    
    
    NSString * resAPI_DO_ACTIVITY_RECEIPT= [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:(NSJSONReadingMutableLeaves) error:nil];

    
 
        //header
    
    
    NSDictionary *dictionary = [(NSHTTPURLResponse *)response allHeaderFields];
    
    
    
//    NSLog(@"%@",dict);
//    NSLog(@"finish!!");
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // _jsonResponseTv.frame = CGRectMake(20, 180,self.view.frame.size.width - 40, _jsonResponseTv.contentSize.height);
        _jsonResponseTv.text = [NSString stringWithFormat:@"%@",dict];
        
         _ratelimitLbl.text = [NSString stringWithFormat:@"-ratelimit-remaining: %@",[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"x-ratelimit-remaining"]]];
    });
}

@end
