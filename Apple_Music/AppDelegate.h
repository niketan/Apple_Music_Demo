//
//  AppDelegate.h
//  Apple_Music
//
//  Created by Niketan Patel on 09/08/17.
//  Copyright © 2017 Niketan Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

