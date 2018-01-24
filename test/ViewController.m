//
//  ViewController.m
//  test
//
//  Created by Sid Mogili on 1/13/18.
//  Copyright © 2018 Sid Mogili. All rights reserved.
//

#import "ViewController.h"
#import "CustomCell.h"
#import "Movies.h"
#import "DetailViewController.h"

@interface ViewController ()
{
    NSMutableArray *SearchData,*MoviesList;
    BOOL isFiltered;
    NSIndexPath *Selectedrow;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableview.delegate = (id)self;
    self.tableview.dataSource = (id)self;
    self.searchbarMovies.delegate = (id)self;

    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-DD"];
    NSString *dateString = [dateFormatter stringFromDate:date];
//    NSString *urlStr = @"http:data.tmsapi.com/v1.1/movies/showings?startDate=2018-01-15&zip=02368&api_key=22h87g3pgun5vaf4bw5ex4w3";
    NSString *urlStr = [@"http:data.tmsapi.com/v1.1/movies/showings?startDate=" stringByAppendingString:[dateString stringByAppendingString:@"&zip=02368&api_key=22h87g3pgun5vaf4bw5ex4w3"]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *responseData = [NSData dataWithContentsOfURL:url];
    NSMutableArray *res = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
    MoviesList = [NSMutableArray arrayWithCapacity:res.count];
    for (int i = 0; i < res.count; i++){
        Movies *movie = [[Movies alloc]init];
        movie.MovieTitle = [[res objectAtIndex:i]objectForKey:@"title"];
        movie.MovieDescription = [[res objectAtIndex:i]objectForKey:@"shortDescription"];
        movie.MovieFullDescription = [[res objectAtIndex:i]objectForKey:@"longDescription"];
        movie.MovieImageURL = [@"http://tmsimg.com/assets/" stringByAppendingString:[[[res objectAtIndex:i]valueForKey:@"preferredImage"]objectForKey:@"uri"]];
        [MoviesList addObject:movie];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered) {
        return SearchData.count;
    } else {
        return MoviesList.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (isFiltered) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Movies *movie = SearchData[indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.Name.text = movie.MovieTitle;
                cell.Description.text = movie.MovieDescription;
                cell.ItemImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:movie.MovieImageURL]]];
            });
        });
    }
    else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            Movies *movie = MoviesList[indexPath.row];
            dispatch_async(dispatch_get_main_queue(), ^{
            cell.Name.text = movie.MovieTitle;
            cell.Description.text = movie.MovieDescription;
            cell.ItemImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:movie.MovieImageURL]]];
            });
        });
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Selectedrow = indexPath;
    [self performSegueWithIdentifier:@"DetailViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"DetailViewController"]) {
        DetailViewController *vc = [segue destinationViewController];
        Movies *movie = MoviesList[Selectedrow.row];
        vc.Description = movie.MovieFullDescription;
        vc.MovieImageURL = movie.MovieImageURL;
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        isFiltered = FALSE;
    }
    else{
        isFiltered = TRUE;
        SearchData = [[NSMutableArray alloc] init];
        for (Movies *movie in MoviesList){
            NSRange nameRange = [movie.MovieTitle rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound)
            {
                [SearchData addObject:movie];
            }
        }
    }
    [self.tableview reloadData];
    }

- (void)searchBarTextDidBeginEditing:(UISearchBar *)SearchBar{
    isFiltered = FALSE;
    SearchBar.showsCancelButton=YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)SearchBar{
    [SearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)SearchBar{
    isFiltered = FALSE;
    [SearchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)SearchBar{
    [SearchBar resignFirstResponder];
}

@end
