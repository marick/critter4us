/*
 * AppController.j
 * critter4us
 *
 * Created by You on July 17, 2009.
 * Copyright 2009, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>


@implementation AppController : CPObject
{
  CPWindow theWindow;
  CPTextField cow1, cow2;
  CPButton button;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero()
    styleMask:CPBorderlessBridgeWindowMask];
    var contentView = [theWindow contentView];

    cow1 = [[CPTextField alloc] initWithFrame:CGRectMake(100, 40, 250, 30)];
    [cow1 setEditable:YES];
    [cow1 setSelectable:YES];
    [cow1 setBezeled:YES];
    [contentView addSubview:cow1];

    cow2 = [[CPTextField alloc] initWithFrame:CGRectMake(100, 80, 250, 30)];
    [cow2 setEditable:YES];
    [cow2 setSelectable:YES];
    [cow2 setBezeled:YES];
    [contentView addSubview:cow2];

    button = [[CPButton alloc] initWithFrame:CGRectMake(100, 120, 80, 30)];
    [button setTitle:"Cow Me!"];
    [button setTarget:self];
    [button setAction:@selector(cowMe:)];
    [contentView addSubview:button];

    var table = [[CPTableView alloc] initWithFrame:CGRectMake(250, 40, 400, 400)];
    var col = [[CPTableColumn alloc] initWithIdentifier:@"foo"];
    [col setWidth:100];
    

    [table addTableColumn:col];

    [contentView addSubview:table];

    [theWindow orderFront:self];
}

- (void)cowMe:(id)sender
{
  var command = { "action" : "fetch cows" };
  var content = [CPString JSONFromObject: command];
  var contentLength = [[CPString alloc] initWithFormat:@"%d", [content length]];
  var request = [[CPURLRequest alloc] initWithURL:@"http://localhost:7000/cows"];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:content];
  [request setValue:contentLength forHTTPHeaderField:@"Content-Length"]; 
  [request setValue:"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"]; 
  
  var connection = [CPURLConnection connectionWithRequest:request delegate:self];
  [cow1 setStringValue:"cow1"];
  [cow2 setStringValue:"cow2"];
}

- (void)cowMe:(id)sender
{
  var request = [CPURLRequest requestWithURL: @"http://localhost:7000/json/cows"]; 
  var data = [CPURLConnection sendSynchronousRequest: request   
                              returningResponse:nil error:nil]; 
  var str = [data description]; 
  var json = [str objectFromJSON];
  [cow1 setStringValue: json["cows"][0]];
  [cow2 setStringValue: json["cows"][1]];
}

-(void)connection:(CPURLConnection)connection didFailWithError:(id)error
{
  alert(error);
}


-(void)connection:(CPURLConnection)connection didReceiveResponse:(CPHTTPURLResponse)response
{
  //  var statusCode = [response statusCode];
}

-(void)connection:(CPURLConnection)connection didReceiveData:(CPString)data
{
  // receivedJsonData = [data objectFromJSON];
  alert(data);
}

@end
