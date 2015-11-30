/**
 http://www.w3.org/TR/SVG/coords.html#InterfaceSVGPreserveAspectRatio
 
 interface SVGPreserveAspectRatio {
 
 // Alignment Types
 SVG_PRESERVEASPECTRATIO_UNKNOWN = 0;
 SVG_PRESERVEASPECTRATIO_NONE = 1;
 SVG_PRESERVEASPECTRATIO_XMINYMIN = 2;
 SVG_PRESERVEASPECTRATIO_XMIDYMIN = 3;
 SVG_PRESERVEASPECTRATIO_XMAXYMIN = 4;
 SVG_PRESERVEASPECTRATIO_XMINYMID = 5;
 SVG_PRESERVEASPECTRATIO_XMIDYMID = 6;
 SVG_PRESERVEASPECTRATIO_XMAXYMID = 7;
 SVG_PRESERVEASPECTRATIO_XMINYMAX = 8;
 SVG_PRESERVEASPECTRATIO_XMIDYMAX = 9;
 SVG_PRESERVEASPECTRATIO_XMAXYMAX = 10;
 
 // Meet-or-slice Types
 SVG_MEETORSLICE_UNKNOWN = 0;
 SVG_MEETORSLICE_MEET = 1;
 SVG_MEETORSLICE_SLICE = 2;
 
 attribute unsigned short align setraises(DOMException);
 attribute unsigned short meetOrSlice setraises(DOMException);
 };
 */
#import <Foundation/Foundation.h>

@interface SVGPreserveAspectRatio : NSObject

typedef enum SVG_PRESERVEASPECTRATIO
{	
	// Alignment Types
	SVG_PRESERVEASPECTRATIO_UNKNOWN = 0,
	SVG_PRESERVEASPECTRATIO_NONE = 1,
	SVG_PRESERVEASPECTRATIO_XMINYMIN = 2,
	SVG_PRESERVEASPECTRATIO_XMIDYMIN = 3,
	SVG_PRESERVEASPECTRATIO_XMAXYMIN = 4,
	SVG_PRESERVEASPECTRATIO_XMINYMID = 5,
	SVG_PRESERVEASPECTRATIO_XMIDYMID = 6,
	SVG_PRESERVEASPECTRATIO_XMAXYMID = 7,
	SVG_PRESERVEASPECTRATIO_XMINYMAX = 8,
	SVG_PRESERVEASPECTRATIO_XMIDYMAX = 9,
	SVG_PRESERVEASPECTRATIO_XMAXYMAX = 10
} SVG_PRESERVEASPECTRATIO;

typedef enum SVG_MEETORSLICE
{
	// Meet-or-slice Types
	SVG_MEETORSLICE_UNKNOWN = 0,
	SVG_MEETORSLICE_MEET = 1,
	SVG_MEETORSLICE_SLICE = 2
} SVG_MEETORSLICE;

@property(nonatomic) SVG_PRESERVEASPECTRATIO align;
@property(nonatomic) SVG_MEETORSLICE meetOrSlice;

@end
