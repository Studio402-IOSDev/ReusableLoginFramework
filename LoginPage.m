//
//  LoginPage.m
//  ReusableLoginPage
//
//  Created by 钟鹏 on 15/5/30.
//  Copyright (c) 2015年 danagi. All rights reserved.
//

#import "LoginPage.h"

@interface LoginPage()

{
    NSString *userspath;
    NSString *configpath;
    NSString *loginPostUrl;
    NSString *signupPostUrl;
    NSString *pswforgetPostUrl;
    NSNumber *timeOut;
    NSString *loginFormat;
    NSString *signupFormat;
    NSString *pswfogetFormat;
    NSMutableDictionary *users;
    NSDictionary *config;
}

@end

@implementation LoginPage

#pragma mark - Lifecycle
- (instancetype) init{
    self = [super init];
    if(self){
        NSBundle *bundle      = [NSBundle mainBundle];
        userspath             = [bundle pathForResource:@"loginuser" ofType:@"plist"];
        configpath            = [bundle pathForResource:@"loginconfig" ofType:@"plist"];
        users                 = [[NSMutableDictionary alloc]initWithContentsOfFile:userspath];
        config                = [[NSDictionary alloc]initWithContentsOfFile:configpath];
        self.username         = config[@"current"];
        self.password         = users[self.username];
        NSNumber *num         = config[@"rememberusername"];
        self.rememberUsername = [num boolValue];
        num                   = config[@"rememberpassword"];
        self.rememberPassword = [num boolValue];
        num                   = config[@"autologin"];
        self.autoLogin        = [num boolValue];
        loginPostUrl          = config[@"loginpost"];
        signupPostUrl         = config[@"signuppost"];
        pswforgetPostUrl      = config[@"pswforgetpost"];
        loginFormat           = config[@"loginformat"];
        signupFormat          = config[@"signupformat"];
        pswfogetFormat        = config[@"pswforgetformat"];
        timeOut               = config[@"timeout"];
        if (self.autoLogin && ![self.username  isEqual: @""] && ![self.password isEqual:@""] && self.username != nil && self.password != nil)
            [self loginWithUsername:self.username andPassword:self.password];
    }
    return self;
}

#pragma mark - Custom Accessors
- (void)setUsername:(NSString *)username{
    self.username = username;
    if (username != nil)
        self.password = users[username];
}

- (NSArray *)usernameList{
    return [users allKeys];
}

- (void)setRememberUsername:(BOOL)rememberUsername{
    self.rememberUsername = rememberUsername;
    NSNumber* value = [NSNumber numberWithBool:rememberUsername];
    [config setValue:value forKey:@"rememberusername"];
}

- (void)setRememberPassword:(BOOL)rememberPassword{
    self.rememberPassword = rememberPassword;
    NSNumber* value = [NSNumber numberWithBool:rememberPassword];
    [config setValue:value forKey:@"rememberpassword"];
}

- (void)setAutoLogin:(BOOL)autoLogin{
    self.autoLogin = autoLogin;
    NSNumber* value = [NSNumber numberWithBool:autoLogin];
    [config setValue:value forKey:@"autologin"];
}

#pragma mark - Public
- (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password{
    NSArray* params = @[username,password];
    [self loginWithParams:params];
}

- (void)loginWithParams:(NSArray *)params{
    [self PostwithUrl:loginPostUrl Format:loginFormat andParams:params];
    [self Save];
}

- (void)signupWithParams:(NSArray*) params{
    [self PostwithUrl:signupPostUrl Format:signupFormat andParams:params];
}

- (void)pswforgetWithParams:(NSArray*) params{
    [self PostwithUrl:pswforgetPostUrl Format:pswfogetFormat andParams:params];
}

- (void)removeUserbyUsername:(NSString*)Username{
    [users removeObjectForKey:Username];
}


#pragma mark - Private
- (void)Save{
    if (self.rememberUsername){
        [users setValue:self.username forKey:@""];
        if (self.rememberPassword)
            [users setValue:self.username forKey:self.password];
        [users writeToFile:userspath atomically:true];
    }
    [config writeToFile:configpath atomically:true];
}

- (void)PostwithUrl:(NSString*)postUrl Format:(NSString*)format andParams:(NSArray*)params{
    NSURL *URL                   = [NSURL URLWithString:postUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.timeoutInterval      = [timeOut floatValue];
    request.HTTPMethod           = @"POST";
    NSString *param              = [NSString stringWithFormat:format,params];
    request.HTTPBody             = [param dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"ios" forHTTPHeaderField:@"User-Agent"];
    NSError *error               = [[NSError alloc] init];
    _responseData                = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
}

@end
