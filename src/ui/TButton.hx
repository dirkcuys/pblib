package ui;

class TButton extends flash.display.Sprite
{
	private var m_textField: flash.text.TextField;

	public function new(?text : String)
	{
		super();
		
		buttonMode = true;
		useHandCursor = true;
		mouseChildren = false;
		
		var format = new flash.text.TextFormat();
		format.font = "Arial";
		format.color = 0x000000;
		//format.size = null;
		//format.align = flash.text.TextFormatAlign.RIGHT;

		m_textField = new flash.text.TextField();
		m_textField.defaultTextFormat = format;
		if (text != null)
			m_textField.text = text;
		else
			m_textField.text = "";
		m_textField.embedFonts = true;
		m_textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		m_textField.multiline = false;
		m_textField.selectable = false;
		m_textField.mouseEnabled = true;

		addChild(m_textField);
	}

	public function setText(text : String)
	{
		m_textField.text = text;
	}

	public function getText() : String
	{
		return m_textField.text;
	}

	public function setTextFormat(format : flash.text.TextFormat)
	{
		m_textField.defaultTextFormat = format;
	}
}
