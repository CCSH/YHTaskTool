//
//  ViewController.m
//  Example
//
//  Created by CCSH on 2022/9/30.
//

#import "ViewController.h"
#import "YHTaskTool.h"
#import <MBProgressHUD.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phontFied;
@property (weak, nonatomic) IBOutlet UITextField *appFied;
@property (weak, nonatomic) IBOutlet UITextField *verFied;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"phontFied"];
    if(str.length){
        self.phontFied.text = str;
    }
    str = [user objectForKey:@"appFied"];
    if(str.length){
        self.appFied.text = str;
    }
    str = [user objectForKey:@"verFied"];
    if(str.length){
        self.verFied.text = str;
    }
}

- (IBAction)btnAction:(id)sender {
    [self.view endEditing:YES];
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(!self.phontFied.text.length){
        hub.label.text = self.phontFied.placeholder;
        [hub hideAnimated:YES afterDelay:1];
        return;
    }
    
    if(!self.appFied.text.length){
        hub.label.text = self.appFied.placeholder;
        [hub hideAnimated:YES afterDelay:1];
        return;
    }
    if(!self.verFied.text.length){
        hub.label.text = self.appFied.placeholder;
        [hub hideAnimated:YES afterDelay:1];
        return;
    }
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:self.phontFied.text forKey:@"phontFied"];
    [user setValue:self.appFied.text forKey:@"appFied"];
    [user setValue:self.verFied.text forKey:@"verFied"];
    [user synchronize];
    
    [YHTaskTool registerTaskWithAppId:[self.appFied.text integerValue]
                               userId:self.phontFied.text
                             userName:self.phontFied.text
                              version:self.verFied.text
                               inView:nil
                               result:^(NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [hub hideAnimated:NO];
                NSLog(@"YHTaskTool注册成功");
            }else{
                hub.label.text = error.userInfo[@"msg"];
                [hub hideAnimated:YES afterDelay:1];
            }
        });
    }];
    
}


@end
