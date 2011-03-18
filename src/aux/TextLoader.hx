package aux;

class TextLoader extends flash.display.Sprite
{
	public var textFormat : flash.text.TextFormat;
	public var arrowPadding : Float;

	private var m_urlLoader : flash.net.URLLoader;
	private var m_textField : flash.text.TextField;
	private var m_upArrow : UpArrow;
	private var m_downArrow : DownArrow;

	public function new(sizeX : Float, sizeY : Float)
	{
		super();

		textFormat = new flash.text.TextFormat();
		textFormat.font = "Arial";
		textFormat.color = 0xFFFFFF;
		textFormat.size = 16;
		m_textField = new flash.text.TextField();
		m_textField.multiline = true;
		m_textField.wordWrap = true;
		m_textField.width = sizeX;
		m_textField.height = sizeY;
		//m_textField.scrollV = 1;

		arrowPadding = 10.0;
		m_upArrow = new UpArrow();
		m_upArrow.x = sizeX + arrowPadding;
		m_upArrow.y = sizeY/2.0 - m_upArrow.height - arrowPadding/2.0;
		m_upArrow.addEventListener(flash.events.MouseEvent.CLICK, scrollUp);
		addChild(m_upArrow);

		m_downArrow = new DownArrow();
		m_downArrow.x = sizeX + arrowPadding;
		m_downArrow.y = sizeY/2.0 + arrowPadding;
		m_downArrow.addEventListener(flash.events.MouseEvent.CLICK, scrollDown);
		addChild(m_downArrow);

	}

	public function loadText(url : String)
	{
		m_urlLoader = new flash.net.URLLoader();
		m_urlLoader.addEventListener(flash.events.Event.COMPLETE, textLoaded);
		m_urlLoader.load(new flash.net.URLRequest(url));
	}

	private function textLoaded(event : flash.events.Event)
	{
		m_textField.defaultTextFormat = textFormat;
		m_textField.htmlText = m_urlLoader.data;
		addChild(m_textField);
	}

	private function scrollUp(event : flash.events.Event)
	{
		if( m_textField.scrollV > 0)
			m_textField.scrollV -= 1;
	}

	private function scrollDown(event : flash.events.Event)
	{
		if (m_textField.scrollV < m_textField.maxScrollV)
			m_textField.scrollV += 1;
	}
}
