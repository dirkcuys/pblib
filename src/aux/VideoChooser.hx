package aux;

class VideoThumb extends flash.display.Sprite
{
	public var url : String;
	public var thumb : flash.display.DisplayObject;
	public var title : String;
	public var sizeX : Float;
	public var sizeY : Float;

	public function new(thumb: flash.display.DisplayObject, url : String, title : String, sizeX : Float, sizeY : Float )
	{
		super();
		this.url = url;
		this.thumb = thumb;
		this.title = title;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		mouseChildren = false;
		useHandCursor = buttonMode = true;

		addChild(thumb);
		
		var shape = new flash.display.Shape();
		shape.graphics.lineStyle(1.0, 0xFFFFFF);
		shape.graphics.drawRect(2,2, width-4.0, height-4.0);
		addChild(shape);
	}
}

class VideoChooser extends flash.display.Sprite
{

	private var m_thumbs : Array<VideoThumb>;
	private var m_videoPlayer : media.videoplayer.VideoPlayer;
	private var m_back : flash.display.Sprite;

	public function new()
	{
		super();
		m_thumbs = new Array<VideoThumb>();
		m_back = new aux.DefaultTButton("Back");
		m_back.y = 10;
		m_back.x = 1024 - 10 - m_back.width;
		m_back.addEventListener(flash.events.MouseEvent.CLICK, backListener);
		addChild(m_back);
	}

	public function addVideoThumb(thumb: flash.display.DisplayObject, url : String, title : String, width : Float, height : Float )
	{
		var vt = new VideoThumb(thumb, url, title, width, height);
		vt.addEventListener(flash.events.MouseEvent.CLICK, clickListener);
		addChild(vt);
		m_thumbs.push(vt);
		layout();
	}

	public function layout()
	{
		var totalWidth : Float = 0;
		for (box in m_thumbs.iterator())
		{
			totalWidth += box.width/box.scaleX;
		}
		var remainWidth = 1024 - totalWidth;
		
		var eqspacing = remainWidth/(m_thumbs.length+1);

		var cur : Float = eqspacing;
		for (box in m_thumbs.iterator())
		{
			box.x = cur;
			box.y = 768/2.0 - box.height/2.0;
			cur += box.width + eqspacing;
		}
	}

	private function clickListener(event : flash.events.Event)
	{
		var thumb = event.target;
		m_videoPlayer = new media.videoplayer.VideoPlayer();
		m_videoPlayer.loadFile(thumb.url, thumb.sizeX, thumb.sizeY, thumb.title);
		m_videoPlayer.addEventListener(flash.events.Event.CLOSE, closeListener);
		m_videoPlayer.x = 1024/2.0 - m_videoPlayer.width/2.0;
		m_videoPlayer.y = 768/2.0 - m_videoPlayer.height/2.0;
		for (vt in m_thumbs.iterator())
		{
			removeChild(vt);
		}
		removeChild(m_back);
		addChild(m_videoPlayer);
	}

	private function closeListener(event : flash.events.Event)
	{
		removeChild(m_videoPlayer);
		m_videoPlayer = null;
	
		for (vt in m_thumbs.iterator())
		{
			addChild(vt);
		}
		addChild(m_back);
	}

	private function backListener(event : flash.events.Event)
	{
		dispatchEvent(new flash.events.Event(flash.events.Event.CLOSE));	
	}
}
