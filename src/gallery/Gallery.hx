package gallery;

class Gallery extends flash.display.Sprite
{
	private var m_background : flash.display.Shape;
	private var m_darkBackground : flash.display.Sprite;
	private var m_mouseX : Float;

	private var m_thumbs : Array<gallery.Thumb>;
	private var m_tolerance : Float;

	public var thumbSize : Float; /// max width or height
	
	public var stageWidth : Float;
	public var stageHeight : Float;

	public function new()
	{
		super();
		m_tolerance = 0;
		m_thumbs = new Array<gallery.Thumb>();	
		
		thumbSize = 100;

		stageWidth = 1024;
		stageHeight = 768;
		
		m_background = new flash.display.Shape();
		m_background.graphics.beginFill(0x000000, 0.1);
		m_background.graphics.drawRect(0,0, stageWidth, 259);
		m_background.y = 384;
		addChild(m_background);

		m_darkBackground = new flash.display.Sprite();
		m_darkBackground.graphics.beginFill(0x000000, 0.8);
		m_darkBackground.graphics.drawRect(0, 0, stageWidth, stageHeight);

		addEventListener(flash.events.MouseEvent.MOUSE_MOVE, trackMouse);
	}

	/// create a thumbnail
	public function loadPicture(thumbURL : String, pictureURL : String)
	{
		var thumb = new gallery.Thumb(thumbURL, pictureURL, thumbSize);
		m_thumbs.push(thumb);
		addChild(thumb);
		thumb.addEventListener(flash.events.MouseEvent.MOUSE_UP, thumbClickListener);
		placeBoxes();
	}

	/// open full size image when the user clicks on the thumb
	public function thumbClickListener(event : flash.events.MouseEvent)
	{
		m_tolerance = 10;
		var thumb : gallery.Thumb = event.target;
		removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, trackMouse);
		
		var picture = new gallery.Picture(thumb.pictureURL, stageWidth/2.0);
		picture.x = stageWidth/2.0 - picture.width/2.0;
		picture.y = stageHeight/2.0 - picture.height/2.0;
		picture.addEventListener(flash.events.MouseEvent.MOUSE_UP, pictureClickListener);
		picture.addEventListener(flash.events.Event.COMPLETE, pictureFinishedLoad);
		
		addChild(m_darkBackground);
		addChild(picture);
	}
	
	/// called once picture is completely loaded to position picture properly
	public function pictureFinishedLoad(event : flash.events.Event)
	{
		var picture : gallery.Picture = event.target;
		picture.x = stageWidth/2.0 - picture.width/2.0;
		picture.y = stageHeight/2.0 - picture.height/2.0;
		picture.removeEventListener(flash.events.Event.COMPLETE, pictureFinishedLoad);
	}
	
	/// close picture when the user clicks on the image
	public function pictureClickListener(event : flash.events.MouseEvent)
	{
		var picture : gallery.Picture = event.target;
		removeChild(picture);
		removeChild(m_darkBackground);
		picture.removeEventListener(flash.events.MouseEvent.MOUSE_UP, pictureClickListener);
		addEventListener(flash.events.MouseEvent.MOUSE_MOVE, trackMouse);
	}

	/// calculate position and scale for thumbnails
	public function placeBoxes()
	{	
		// calculate the total width
		var totalWidth : Float = 0;
		for (box in m_thumbs.iterator())
		{
			//box.frame.alpha = 1.0;
			totalWidth += box.width/box.scaleX;
		}
		var remainWidth = stageWidth - totalWidth;
		
		// the spacing between every unscaled image
		var eqspacing = remainWidth/(m_thumbs.length+1);

		// calculate the center x position and store in array
		var xp : Float = 0;
		var cpa = new Array<Float>();
		for (box in m_thumbs.iterator())
		{
			xp += eqspacing;
			//box.x = xp;
			cpa.push(xp + (box.width/box.scaleX)/2.0);
			xp += box.width/box.scaleX;
		}

		// place and scale thumbnails
		xp = 0;
		totalWidth = 0;
		var sod : Float = 0;
		var sods : Float = 0;
		for (i in 0...m_thumbs.length)
		{
			var cp = cpa[i];
			var dist = (cp - mouseX);
			var sdist = dist;
			sods += sdist;
			dist = dist*dist;
			sod += dist;
			m_thumbs[i].scaleY = m_thumbs[i].scaleX = 1.0 + 0.3/(dist/1600 + 1);
			totalWidth += m_thumbs[i].width;
			m_thumbs[i].x = cp - m_thumbs[i].width/2.0;
			m_thumbs[i].y = m_background.y + m_background.height/2.0 - m_thumbs[i].height/2.0;
		}
		//trace(sods);
	}

	/// track the x position of the mouse
	public function trackMouse(event : flash.events.MouseEvent)
	{
		m_mouseX = event.localX;
		if (m_tolerance > 0)
			m_tolerance -= 1;
		else
			placeBoxes();
	}
}
