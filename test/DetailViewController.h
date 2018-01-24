//
//  DetailViewController.h
//  test
//
//  Created by Sid Mogili on 1/14/18.
//  Copyright © 2018 Sid Mogili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *MovieDescription;
@property (weak, nonatomic) IBOutlet UIImageView *MovieImage;
@property (nonatomic,weak) NSString *Description;
@property (nonatomic,weak) NSString *MovieImageURL;
@end
