package gallery;

class Thumb extends flash.display.Sprite
{
	/// public properties
	public var middleX(default,setMiddleX) : Float; ///< set middleX will alter x
	public var middleY(default,setMiddleY) : Float;
	public var pictureURL(default,null) : String; ///< read-only
	
	private var maxDimension : Float; ///< max width or height of thumbnail
	private var thumbURL : String;	
	private var frameSize : Float; ///< size of frame surrounding picture
	private var padding : Float;
	private var whiteLine : flash.display.Shape;
	private var frame : flash.display.Shape;
	
	public function new(thumbURL : String, pictureURL : String, maxDimension : Float)
	{
		super();
		this.thumbURL = thumbURL;
		this.pictureURL = pictureURL;
		this.maxDimension = maxDimension;
		this.frameSize = 5;
		this.padding = 1;
		
		initialize();
	}

	private function initialize()
	{	
		frame = new flash.display.Shape();
		frame.graphics.beginFill(0x222222, 1.0);
		frame.graphics.drawRoundRect(0, 0, maxDimension + frameSize*2, maxDimension + frameSize*2, frameSize);
		addChild(frame);

		whiteLine = new flash.display.Shape();
		//whiteLine.graphics.beginFill(0xFFFFFF, 1.0);
		//whiteLine.graphics.lineStyle(1, 0xFFFFFF);
		//whiteLine.graphics.drawRect(frameSize + padding, frameSize + padding, thumbWidth - 2*padding, maxDimension - 2*padding);
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
		picture.smoothing = true;
		picture.x = picture.y = frameSize;
				
		if (picture.width > picture.height)
		{
			//landscape
			picture.scaleX = picture.scaleY = maxDimension/picture.width;
		}
		else
		{
			// portrait
			picture.scaleX = picture.scaleY = maxDimension/picture.height;
		}
		
		frame.graphics.clear();
		frame.graphics.beginFill(0x222222, 1.0);
		frame.graphics.drawRoundRect(0, 0, picture.width + frameSize*2, picture.height + frameSize*2, frameSize);
		
		whiteLine.graphics.clear();
		whiteLine.graphics.lineStyle(1, 0xFFFFFF);
		whiteLine.graphics.drawRect(frameSize + padding, frameSize + padding, picture.width - 2*padding, picture.height - 2*padding);
		
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
