package aux;

/// Progress bar that does not require any bitmaps!!
class ProgressBar extends flash.display.Sprite
{
	public var progress(default,setProgress) : Float;

	private var fillBar : flash.display.Shape;
	private var fillOffset : Float;

	public function new(width : Float)
	{
		super();
		this.fillOffset = 2;
		
		var back = new flash.display.Shape();
		back.graphics.beginFill(0xAAAAAA);
		back.graphics.drawRoundRect(0, 0, width, 20, 10);
		addChild(back);
		
		this.fillBar = new flash.display.Shape();
		addChild(fillBar);
		
		this.progress = 0.0;
        var filterArray = new Array();
        filterArray.push(new flash.filters.BlurFilter(5, 5));
        fillBar.filters = filterArray;
	}

	public function setProgress(f : Float) : Float
	{
		progress = f;
		if (progress > 100) progress = 100;
		if (progress < 0) progress = 0;
		fillBar.graphics.clear();
		fillBar.graphics.beginFill(0x555555);
		fillBar.graphics.drawRoundRect(fillOffset, fillOffset, (width-2*fillOffset)*progress/100.0, height - 2*fillOffset, 8);
		return progress;
	}
}


