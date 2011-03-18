package media.musicplayer;

class ProgressButton extends MusicPlayerButton{}
class ProgressBack extends flash.display.Sprite{}

class TrackBar extends flash.display.Sprite
{

	private var m_slider : MusicPlayerButton;
	private var m_loadProgressFill : flash.display.Shape;
	private var m_minPosition : Float;
	private var m_maxPosition : Float;
	private var m_offset : Float;
	private var m_dragging : Bool;

	public var progress(default,setProgress) : Float;
	
	public var loadProgress(default, setLoadProgress) : Float;

	public function new()
	{
		super();

		m_dragging = false;
		
		var track = new ProgressBack();
		track.y = 1;
		addChild(track);
		
		m_loadProgressFill = new flash.display.Shape();
		m_loadProgressFill.y = (track.height - 4)/2.0;
		addChild(m_loadProgressFill);
		
		m_slider = new ProgressButton();
		addChild(m_slider);

		m_minPosition = 0;
		m_maxPosition = 190;
		m_slider.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, mouseDown);

		//progress = 0;
	}

	public function setProgress(value : Float) : Float
	{
		progress = value;
		if (progress < 0) progress = 0;
		if (progress > 100) progress = 100.0;
		
		// don't allow progress further than the load progress
		if (progress > loadProgress) progress = loadProgress;

		if (!m_dragging)
			m_slider.x = m_minPosition + progress/100.0*m_maxPosition;
		
		return progress;
	}
	
	public function setLoadProgress(value : Float) : Float
	{
		loadProgress = value;
		if (loadProgress < 0) loadProgress = 0.0;
		if (loadProgress > 100) loadProgress = 100.0;
		
		m_loadProgressFill.graphics.clear();
		m_loadProgressFill.graphics.beginFill(0x333333);
		m_loadProgressFill.graphics.drawRoundRect(2, 0, width*loadProgress/100.0 - 4, 4, 2);
		
		return loadProgress;
	}

	/// event listeners
	
	private function mouseDown(event : flash.events.MouseEvent)
	{
		//trace("ProgressBar::mouseDown");
		//m_slider.startDrag(false, new flash.geom.Rectangle(0,0,width-m_slider.width,0));
		m_dragging = true;
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.MOUSE_UP, mouseUp);
		flash.Lib.current.stage.addEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMove);
		m_offset = event.localX;
	}

	private function mouseUp(event : flash.events.MouseEvent)
	{
		m_dragging = false;
		var global = new flash.geom.Point(event.stageX - m_offset, event.stageY);
		var local = globalToLocal(global);
		progress = (local.x - m_minPosition)/(m_maxPosition - m_minPosition)*100.0;
		//trace("ProgressBar::mouseUp");
		//m_slider.stopDrag();
		flash.Lib.current.stage.removeEventListener(flash.events.MouseEvent.MOUSE_UP, mouseUp);
		flash.Lib.current.stage.removeEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseMove);
		dispatchEvent(new flash.events.Event(flash.events.Event.CHANGE));
	}

	private function mouseMove(event : flash.events.MouseEvent)
	{
		var global = new flash.geom.Point(event.stageX - m_offset, event.stageY);
		var local = globalToLocal(global);
		//progress = (local.x - m_minPosition)/(m_maxPosition - m_minPosition)*100.0;
		m_slider.x = local.x;
		if (m_slider.x < m_minPosition)
			m_slider.x = m_minPosition;
		if (m_slider.x > m_maxPosition)
			m_slider.x = m_maxPosition;
	}
}
