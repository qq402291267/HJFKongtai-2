//
//  comMethod.m
//  HJFminshi
//
//  Created by 胡江峰 on 16/3/7.
//  Copyright © 2016年 胡江峰. All rights reserved.
//

#import "comMethod.h"
#import "Crypt.h"
@implementation comMethod

+ (UInt16)uint16FromNetData:(NSData *)data
{
    return ntohs(*((UInt16 *)[data bytes]));
}

+ (NSString *)convertDataToip:(NSData *)data
{
    NSMutableString * temphost = [[NSMutableString alloc] init];
    for (int i = 0; i < [data length]; i++) {
        UInt8 no = ((UInt8*)[data bytes])[i];
        [temphost appendFormat:@"%d.",no];
    }
    NSString * host = [temphost substringWithRange:NSMakeRange(0, temphost.length-1)];
    return host;
}

+ (NSString *)convertDataTomacstring:(NSData *)data
{
    NSString * macstring = [[Crypt hexEncode:data] uppercaseStringWithLocale:[NSLocale currentLocale]];
    //    NSLog(@"convertDataTomac:mac = %@,macstring = %@",data,macstring);
    return macstring;
}

//string转data
+ (NSData *)convertmacstringToData:(NSString *)macstring
{
    NSData * macdata = [Crypt decodeHex:macstring];
    //    NSLog(@"convertmacstringToData:macstring = %@,macdata = %@",macstring,macdata);
    return macdata;
}




//得到文本输入左侧空视图
+ (UIView *)gettextRectLeftView{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    return paddingView;
}

//获取宽度和高度

+ (CGSize) titleSizeWithTitle:(NSString *)title size:(CGFloat)size;{
    return [self titleSizeWithTitle:title size:size MaxW:MAXFLOAT];
}

+ (CGSize) titleSizeWithTitle:(NSString *)title size:(CGFloat)size MaxW:(CGFloat)MaxW{
    NSDictionary *dict = @{
                           NSFontAttributeName: [UIFont systemFontOfSize:size]
                           };
    CGSize maxSize = CGSizeMake(MaxW, MAXFLOAT);
    return [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
}


//判断userName和userPassword是否合法
+(BOOL)JudgeUserName:(NSString *)userName userPassword:(NSString *)userPassword{
    return !( userName == nil || [userName isEqualToString:@""] || [userName isEqual:[NSNull null]] || userPassword == nil || [userPassword isEqualToString:@""] || [userPassword isEqual:[NSNull null]]);
}

//警告框
+ (UIAlertView *)showAlertWithTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    return alert;
}

+ (void)RGBtoHSVr:(float)r g:(float)g b:(float)b h:(float *)h s:(float *)s v:(float *)v
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

+ (void)HSVtoRGBh:(float)h s:(float)s v:(float)v r:(float *)r g:(float*)g b:(float *)b
{
    int i;
    float f, p, q, t;
    if( s == 0 ) {
        // achromatic (grey)
        *r = *g = *b = v;
        return;
    }
    h /= 60;            // sector 0 to 5
    i = floor( h );
    f = h - i;          // factorial part of h
    p = v * ( 1 - s );
    q = v * ( 1 - s * f );
    t = v * ( 1 - s * ( 1 - f ) );
    switch( i ) {
        case 0:
            *r = v;
            *g = t;
            *b = p;
            break;
        case 1:
            *r = q;
            *g = v;
            *b = p;
            break;
        case 2:
            *r = p;
            *g = v;
            *b = t;
            break;
        case 3:
            *r = p;
            *g = q;
            *b = v;
            break;
        case 4:
            *r = t;
            *g = p;
            *b = v;
            break;
        default:        // case 5:
            *r = v;
            *g = p;
            *b = q;
            break;
    }
}

//获得app的代理
+ (AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//获取一点的颜色
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
+ (UIColor *)getPixelColorAtLocation:(CGPoint)point imagedata:(UIImage *)imagedata{
    UIColor* color = nil;
    CGImageRef inImage = imagedata.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
            //            NSLog(@"offset: %d", offset);
            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            //            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }
        
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}
//－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－












@end
