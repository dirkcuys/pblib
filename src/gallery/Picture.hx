package gallery;

class Picture extends flash.display.Sprite
{
	public var bitmap : flash.display.Bitmap;
	public var frame : flash.display.Shape;
	public var middleX(default,setMiddleX) : Float;
	public var middleY(default,setMiddleY) : Float;
	
	private var frameSize : Float;
	private var whiteLine : flash.display.Shape;
	
	public function new(bitmap : flash.display.Bitmap)
	{
		super();
		this.bitmap = bitmap;

		frameSize = 5;
		initialize();
	}

	private function initialize()
	{	
		frame = new flash.display.Shape();
		frame.graphics.beginFill(0x222222, 1.0);
		frame.graphics.drawRoundRect(0, 0, bitmap.width + frameSize*2, bitmap.height + frameSize*2, frameSize);
		addChild(frame);
		
		bitmap.smoothing = true;
		bitmap.x = bitmap.y = frameSize;
		addChild(bitmap);

		var padding = bitmap.scaleX;

		whiteLine = new flash.display.Shape();
		//whiteLine.graphics.beginFill(0xFFFFFF, 1.0);
		whiteLine.graphics.lineStyle(bitmap.scaleX, 0xFFFFFF);
		whiteLine.graphics.drawRect(bitmap.x + padding, bitmap.y + padding, bitmap.width - 2*padding, bitmap.height - 2*padding);
		addChild(whiteLine);

		useHandCursor = true;
		buttonMode = true;
		mouseChildren = false;
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
