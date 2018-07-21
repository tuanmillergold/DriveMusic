//
//  ViewController.m
//  DriveMusic
//
//  Created by Jeames Gillett on 21/7/18.
//  Copyright © 2018 BLM. All rights reserved.
//

#import "ViewController.h"
#import <AppAuth/AppAuth.h>
#import <GTMAppAuth/GTMAppAuth.h>
#import <GTMSessionFetcher/GTMSessionFetcherService.h>
#import <GTMSessionFetcher/GTMSessionFetcherLogging.h>
#import <GoogleAPIClientForREST/GTLRUtilities.h>

#import "AppDelegate.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic) GTMAppAuthFetcherAuthorization *_authorization;

@end

@implementation ViewController

@synthesize _authorization;
- (IBAction)doLoginIn:(id)sender {
    
    NSLog(@"do log in touched");
    
    NSURL *issuer = [NSURL URLWithString:@"https://accounts.google.com"];
    NSString *clientId = @"231221191535-a46t8p3lm1q18n9dklf9aftm8gppfd7i.apps.googleusercontent.com";
    NSURL *redirectURL = [NSURL URLWithString:@"com.googleusercontent.apps.231221191535-a46t8p3lm1q18n9dklf9aftm8gppfd7i:/oauthredirecrt"];
    
    [OIDAuthorizationService discoverServiceConfigurationForIssuer:issuer completion:^(OIDServiceConfiguration *configuration, NSError *_Nullable err  ){
        if (!configuration) {
            NSLog(@"%@", [err localizedDescription]);
            return;
        }
        
        NSLog(@"Configuration: %@", configuration);
        
        OIDAuthorizationRequest *request = [[OIDAuthorizationRequest alloc] initWithConfiguration:configuration clientId:clientId scopes:@[OIDScopeOpenID, OIDScopeProfile] redirectURL:redirectURL responseType:OIDResponseTypeCode additionalParameters:nil];
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        appDelegate.currentAuthorizationFlow = [OIDAuthState authStateByPresentingAuthorizationRequest:request presentingViewController:self callback:^(OIDAuthState *_Nullable state, NSError *_Nullable err) {
            if (state) {
                GTMAppAuthFetcherAuthorization *authorization = [[GTMAppAuthFetcherAuthorization alloc] initWithAuthState:state];
                self._authorization = authorization;
                
                GTMSessionFetcherService *fetcherService = [[GTMSessionFetcherService alloc] init];
                fetcherService.authorizer = self._authorization;
                
                NSURL *userInfoURL = [NSURL URLWithString:@"https://www.googleapis.com/oauth2/v3/userinfo"];
                GTMSessionFetcher *fetcher = [fetcherService fetcherWithURL:userInfoURL];
                
                [fetcher beginFetchWithCompletionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"Fetch Data: %@ ", error);
                        return;
                    }
                    
                    NSError *jsonError = nil;
                    id jsonDictionaryOrArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                    
                    if (jsonError) {
                        NSLog(@"Serialize Error: %@", jsonError);
                        return;
                    }
                    
                    NSLog(@"jsonDictionaryOrArray: %@", jsonDictionaryOrArray);
                    
                    [self performSegueWithIdentifier:@"afterLoginSegue" sender:self];
                }];
            }
        }];
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
