package media.videoplayer;

class ProgressButton extends flash.display.Sprite
{
	public function new()
	{
		super();
		var track = new flash.display.Shape();
		track.graphics.beginFill(0x777777);
		track.graphics.drawRoundRect(0, -5, 7, 20, 7);
		addChild(track);
		useHandCursor = buttonMode = true;
	}
}

class ProgressSlider extends flash.display.Sprite
{

	private var m_slider : ProgressButton;
	private var m_minPosition : Float;
	private var m_maxPosition : Float;
	private var m_offset : Float;
	private var m_dragging : Bool;

	public var progress(default,setProgress) : Float;

	public function new(sizeX : Float)
	{
		super();

		m_dragging = false;
		
		var track = new flash.display.Shape();
		track.graphics.beginFill(0xAAAAAA);
		track.graphics.drawRoundRect(0, 0, sizeX, 10, 5);
		addChild(track);
		
		m_slider = new ProgressButton();
		addChild(m_slider);

		m_minPosition = 0;
		m_maxPosition = sizeX - m_slider.width;
		m_slider.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, mouseDown);

		//progress = 0;
	}

	public function setProgress(value : Float) : Float
	{
		progress = value;
		if (progress < 0) progress = 0;
		if (progress > 100) progress = 100.0;

		if (!m_dragging)
			m_slider.x = m_minPosition + progress/100.0*m_maxPosition;
		
		return progress;
	}

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
