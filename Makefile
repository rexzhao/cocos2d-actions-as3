
FILE1=$(wildcard org/cocos2d/Actions/*.as)
FILE2=$(wildcard org/cocos2d/*.as)

all : cocos2dMain.swf 

%.swf : %.as $(FILE1) $(FILE2)
	mxmlc $< -debug=true -static-link-runtime-shared-libraries --show-actionscript-warnings=true --strict=true

clean:
	rm -v *.swf
