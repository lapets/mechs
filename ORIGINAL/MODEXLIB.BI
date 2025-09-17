' Routine declarations:

DECLARE SUB mxMode320x240
DECLARE SUB mxMode320x400
DECLARE SUB mxMode320x200
DECLARE SUB mxFill (BYVAL offset%, BYVAL lenn%, BYVAL coll%)
DECLARE SUB mxPset (BYVAL offset%, BYVAL x%, BYVAL y%, BYVAL c%)
DECLARE SUB mxLine (BYVAL offset%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%, BYVAL c%)
DECLARE SUB mxSetDisplayOffset (BYVAL offset&)
DECLARE SUB mxPut (BYVAL i%, BYVAL DestOffset&, BYVAL SprtSegment%, BYVAL SprtOffset%, BYVAL x&, BYVAL y%)
DECLARE SUB mxPrint (BYVAL Voffset%, BYVAL StrSeg%, BYVAL StrOff%, BYVAL x%, BYVAL y%, BYVAL c%)
DECLARE SUB mxBufferCopy (BYVAL Voffset%, BYVAL BSegment%, BYVAL BOffset%)
DECLARE SUB mxPCopy (BYVAL VOffset1%, BYVAL VOffset2%, BYVAL Amount%)
DECLARE SUB mxSetView (BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%)
DECLARE SUB mxGet (BYVAL Voffset%, BYVAL SSegment%, BYVAL SOffset%, BYVAL x1%, BYVAL y1%, BYVAL x2%, BYVAL y2%)
DECLARE FUNCTION mxPoint% (BYVAL offset%, BYVAL x%, BYVAL y%)


'Helpful contants:

CONST Full320x200% = 4000
CONST Full320x240% = 4800
CONST Full320x400% = 8000

CONST Page0in320x200& = &H0
CONST Page1in320x200& = &H3E80
CONST Page2in320x200& = &H7D00
CONST Page3in320x200& = &HBB80

CONST Page0in320x240& = &H0
CONST Page1in320x240& = &H4B00
CONST Page2in320x240& = &H9600

CONST Page0in320x400& = &H0
CONST Page1in320x400& = &H7D00

