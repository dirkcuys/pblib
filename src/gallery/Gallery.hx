package gallery;

class Gallery extends flash.display.Sprite
{
	private var m_background : flash.display.Shape;
	private var m_darkBackground : flash.display.Shape;
	private var m_mouseX : Float;

	private var m_thumbs : Array<gallery.Thumb>;
	private var m_tolerance : Float;

	public var thumbWidth : Float;
	public var thumbHeight : Float;
	
	public var stageWidth : Float;
	public var stageHeight : Float;

	public function new()
	{
		super();
		m_tolerance = 0;
		m_thumbs = new Array<gallery.Thumb>();	
		
		thumbWidth = 100;
		thumbHeight = 100;

		stageWidth = 1024;
		stageHeight = 768;
		
		m_background = new flash.display.Shape();
		m_background.graphics.beginFill(0x000000, 0.1);
		m_background.graphics.drawRect(0,0, stageWidth, 259);
		m_background.y = 384;
		addChild(m_background);

		m_darkBackground = new flash.display.Shape();
		m_darkBackground.graphics.beginFill(0x000000, 0.1);
		m_darkBackground.graphics.drawRect(0, 0, stageWidth, stageHeight);
		m_darkBackground.alpha = 0.0;
		addChild(m_darkBackground);

		addEventListener(flash.events.MouseEvent.MOUSE_MOVE, trackMouse);
	}

	public function loadPicture(thumbURL : String, pictureURL : String)
	{
		var thumb = new gallery.Thumb(thumbURL, pictureURL, thumbWidth, thumbHeight);
		m_thumbs.push(thumb);
		addChild(thumb);
		placeBoxes();
	}

	public function pictureMaximizeListener(event : flash.events.MouseEvent)
	{
		m_tolerance = 10;
		var holder : gallery.Picture = event.target;
		//removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, trackMouse);
		//holder.scaleX = holder.scaleY = 1.0/holder.bitmap.scaleY;
		//holder.frame.alpha = 0.0;
		m_darkBackground.alpha = 1.0;
		holder.x = stageWidth/2.0 - holder.width/2.0;
		holder.y = stageHeight/2.0 - holder.height/2.0;
		swapChildren(m_darkBackground, getChildAt(numChildren-2));
		swapChildren(holder, getChildAt(numChildren-1));
	}

	/// calculate position and scale for thumbnails
	public function placeBoxes()
	{
		//m_darkBackground.alpha = 0.0;
		
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
