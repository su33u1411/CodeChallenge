//
//  ViewController.h
//  test
//
//  Created by Sid Mogili on 1/13/18.
//  Copyright © 2018 Sid Mogili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UISearchBar *searchbarMovies;
@end

