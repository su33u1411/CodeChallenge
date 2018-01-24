//
//  CustomCell.h
//  test
//
//  Created by Sid Mogili on 1/13/18.
//  Copyright © 2018 Sid Mogili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Description;
@property (weak, nonatomic) IBOutlet UIImageView *ItemImage;
@end
