//
//  ViewController.m
//  CoreSpolightDemo
//
//  Created by gideon on 11/18/15.
//  Copyright © 2015 gideon. All rights reserved.
//

#import "ViewController.h"
#import <CoreSpotlight/CoreSpotlight.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"img1.jpg"];
    self.myImage = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:self.myImage];
    [self createSearchIndex];
    [self createUserActivity];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)createSearchIndex
{
    
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:@[@"com.gideon"] completionHandler:^(NSError * _Nullable error) {
        
    }];
    NSArray *titles = @[@"侏罗纪世界",@"霍比特人",@"加勒比海盗",@"速度与激情",@"复仇者联盟"];
    NSMutableArray *searchItems = [@[] mutableCopy];
    int i=0;
    for (NSString *title in titles) {
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"corespolight"];
        //         CSLocalizedString *displayName = [[CSLocalizedString alloc] initWithLocalizedStrings:@{@"en":@"movie", @"fr":@"Chanson",@"zh":title}];
        //        attributeSet.displayName = displayName.localizedString;
        
        attributeSet.title = title;
        attributeSet.contentDescription = [NSString stringWithFormat:@"我看过的最好的一步电影就是:%@", title];
        NSString *imgName = [NSString stringWithFormat:@"img%d.jpg",i+1];
        UIImage *image = [UIImage imageNamed:imgName];
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        attributeSet.thumbnailData = data;
        
        CSSearchableItem *searchItem = [[CSSearchableItem alloc] initWithUniqueIdentifier:imgName domainIdentifier:@"com.gideon" attributeSet:attributeSet];
        i++;
        [searchItems addObject:searchItem];
    }
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchItems completionHandler:^(NSError * _Nullable error) {
        
    }];
}

- (void)createUserActivity
{
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:@"com.gideon.history"];
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"corespolight"];
    attributeSet.title = @"玩命速递";
    attributeSet.contentDescription = [NSString stringWithFormat:@"我看过的最好的一步电影就是:%@", @"玩命速递"];
    UIImage *image = [UIImage imageNamed:@"img1.jpg"];
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    attributeSet.thumbnailData = data;
    userActivity.contentAttributeSet =attributeSet;
    
    userActivity.title = @"玩命速递";
    userActivity.keywords = [[NSSet alloc] initWithArray:@[@"电影",@"好看的",@"大片"]];
    userActivity.userInfo = @{@"name":@"Gidoen"};
    userActivity.eligibleForSearch = YES;
    [userActivity becomeCurrent];
    
}

- (void)restoreUserActivityState:(NSUserActivity *)activity
{
    NSString *name = [activity.userInfo objectForKey:@"name"];
    NSLog(@"%@",name);
    
}
@end
