//
//  LoginPage.h
//  ReusableLoginPage
//
//  Created by 钟鹏 on 15/5/30.
//  Copyright (c) 2015年 danagi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginPage : NSObject

@property(copy,nonatomic) NSString *username;
@property(copy,nonatomic) NSString *password;
@property(assign,nonatomic) BOOL rememberUsername;
@property(assign,nonatomic) BOOL rememberPassword;
@property(assign,nonatomic) BOOL autoLogin;
@property(strong,nonatomic,readonly) NSArray *usernameList;
@property(strong,nonatomic,readonly) NSData *responseData;

- (instancetype)init;
- (void)loginWithUsername:(NSString*)Username andPassword:(NSString*)Password;
- (void)loginWithParams:(NSArray*) params;
- (void)signupWithParams:(NSArray*) params;
- (void)pswforgetWithParams:(NSArray*) params;
- (void)removeUserbyUsername:(NSString*)Username;

@end
