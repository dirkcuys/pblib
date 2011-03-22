package gallery;

class Thumb extends flash.display.Sprite
{
	public var frame : flash.display.Shape;
	public var middleX(default,setMiddleX) : Float;
	public var middleY(default,setMiddleY) : Float;
	public var pictureURL : String;
	
	private var thumbWidth : Float; /// desired width of thumbnail
	private var thumbHeight : Float; /// desired height of thumbnail
	private var thumbURL : String;	
	private var frameSize : Float;
	private var padding : Float;
	private var whiteLine : flash.display.Shape;
	
	public function new(thumbURL : String, pictureURL : String, thumbWidth : Float, thumbHeight : Float)
	{
		super();
		this.thumbURL = thumbURL;
		this.pictureURL = pictureURL;
		this.thumbWidth = thumbWidth;
		this.thumbHeight = thumbHeight;
		this.frameSize = 5;
		this.padding = 1;
		
		initialize();
	}

	private function initialize()
	{	
		frame = new flash.display.Shape();
		frame.graphics.beginFill(0x222222, 1.0);
		frame.graphics.drawRoundRect(0, 0, thumbWidth + frameSize*2, thumbHeight + frameSize*2, frameSize);
		addChild(frame);

		whiteLine = new flash.display.Shape();
		//whiteLine.graphics.beginFill(0xFFFFFF, 1.0);
		whiteLine.graphics.lineStyle(1, 0xFFFFFF);
		whiteLine.graphics.drawRect(frameSize + padding, frameSize + padding, thumbWidth - 2*padding, thumbHeight - 2*padding);
		addChild(whiteLine);

		useHandCursor = true;
		buttonMode = true;
		mouseChildren = false;
		
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loadComplete);
		loader.load(new flash.net.URLRequest(thumbURL));
		
		// TODO: add progress bar to show load progress
	}
	
	public function loadComplete(event : flash.events.Event)
	{
		var loader = event.target;
		//trace(loader.content);
		var picture : flash.display.Bitmap = loader.content;
		if (picture.width > picture.height)
		{
			//landscape
			picture.scaleX = picture.scaleY = thumbWidth/picture.width;
			thumbHeight = picture.height;
		}
		else
		{
			// portrait
			picture.scaleX = picture.scaleY = thumbHeight/picture.height;
			thumbWidth = picture.width;
		}

		picture.smoothing = true;
		picture.x = picture.y = frameSize;
		
		frame.graphics.clear();
		frame.graphics.beginFill(0x222222, 1.0);
		frame.graphics.drawRoundRect(0, 0, thumbWidth + frameSize*2, thumbHeight + frameSize*2, frameSize);
		
		whiteLine.graphics.clear();
		whiteLine.graphics.lineStyle(1, 0xFFFFFF);
		whiteLine.graphics.drawRect(frameSize + padding, frameSize + padding, thumbWidth - 2*padding, thumbHeight - 2*padding);
		
		addChild(picture);
	}

	public function setMiddleX(mx : Float) : Float
	{
		middleX = mx;
		x = middleX - width/2.0;
		return middleX;
	}

	public function setMiddleY(my : Float) : Float
	{
		middleY = my;
		y = middleY - height/2.0;
		return middleY;
	}
}
