class Page extends flash.display.Sprite
{

	public var handler(default,default) : PageHandler;
	public var m_backArrow : flash.display.MovieClip;
	//private var m_tbutx : TButton;
	//private var m_tbuty : TButton;

	public function new(handler : PageHandler)
	{
		super();
		this.handler = handler;
		/*
		trace(width);
		trace(height);
		m_tbutx = new TButton("?");
		m_tbutx.y = 100;
		m_tbutx.x = 100;
		addChild(m_tbutx);
		m_tbuty = new TButton("?");
		m_tbuty.y = 140;
		m_tbuty.x = 100;
		addChild(m_tbuty);
		
		m_backArrow = flash.Lib.attach("Arrow");
		addChild(m_backArrow);
		m_backArrow.x = 0;
		m_backArrow.y = 160;
		m_backArrow.alpha = 0.0;
		//width = 1024;
		//height = 768;
		trace(width);
		trace(height);

		addEventListener(flash.events.MouseEvent.MOUSE_MOVE, mouseRegionListener, true);
		//*/
	}

	public function back()
	{
		handler.showPreviousPage();
	}

	private function mouseRegionListener(event : flash.events.MouseEvent)
	{
		m_backArrow.alpha = 1.0;
		/*if (event.localX < m_backArrow.width && event.localY > height - m_backArrow.height)
		{
			m_backArrow.x = 0;
			m_backArrow.y = height - m_backArrow.height;
			addChild(m_backArrow);
		} else if (contains(m_backArrow))
			removeChild(m_backArrow);
		//*/
		//m_tbutx.setText("x:" + (event.localX + event.target.x) );
		//m_tbuty.setText("y:" + (event.localY + event.target.y) );
	}

}
