package gallery;

class Gallery extends flash.display.Sprite
{
	private var m_background : flash.display.Shape;
	private var m_darkBackground : flash.display.Shape;
	private var m_mouseX : Float;

	private var m_thumbs : Array<gallery.Picture>;
	private var m_tolerance : Float;

	public var thumbWidth : Float;
	public var thumbHeight : Float;
	
	public var stageWidth : Float;
	public var stageHeight : Float;

	public function new()
	{
		super();
		m_tolerance = 0;
		m_thumbs = new Array<gallery.Picture>();	
		
		thumbWidth = 100;
		thumbHeight = 100;

		stageWidth = 1024;
		stageHeight = 768;
		
		m_background = new flash.display.Shape();
		m_background.graphics.beginFill(0x000000, 0.5);
		m_background.graphics.drawRect(0,0, 1024, 259);
		m_background.y = 384;
		addChild(m_background);

		m_darkBackground = new flash.display.Shape();
		m_darkBackground.graphics.beginFill(0x000000, 0.9);
		m_darkBackground.graphics.drawRect(0, 0, stageWidth, stageHeight);
		m_darkBackground.alpha = 0.0;
		addChild(m_darkBackground);

		addEventListener(flash.events.MouseEvent.MOUSE_MOVE, trackMouse);
	}

	public function loadPicture(url : String)
	{
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loadComplete);
		loader.load(new flash.net.URLRequest(url));
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
		}
		else
		{
			// portrait
			picture.scaleX = picture.scaleY = thumbHeight/picture.height;
		}
		var holder = new gallery.Picture(picture);
		holder.addEventListener(flash.events.MouseEvent.CLICK, pictureMaximizeListener);
		m_thumbs.push(holder);
		addChild(holder);
		placeBoxes();

	}

	public function pictureMaximizeListener(event : flash.events.MouseEvent)
	{
		m_tolerance = 10;
		var holder : gallery.Picture = event.target;
		//removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, trackMouse);
		holder.scaleX = holder.scaleY = 1.0/holder.bitmap.scaleY;
		holder.frame.alpha = 0.0;
		m_darkBackground.alpha = 1.0;
		holder.x = stageWidth/2.0 - holder.width/2.0;
		holder.y = stageHeight/2.0 - holder.height/2.0;
		swapChildren(m_darkBackground, getChildAt(numChildren-2));
		swapChildren(holder, getChildAt(numChildren-1));
	}

	public function placeBoxes()
	{
		m_darkBackground.alpha = 0.0;
		
		// calculate the total width
		var totalWidth : Float = 0;
		for (box in m_thumbs.iterator())
		{
			box.frame.alpha = 1.0;
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
			m_thumbs[i].x = (cp) - m_thumbs[i].width/2.0;
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
