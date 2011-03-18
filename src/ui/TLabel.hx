package ui;

class TLabel extends flash.display.Sprite
{
	public var textField: flash.text.TextField;

	public function new(?text : String)
	{
		super();
		
		var format = new flash.text.TextFormat();
		format.font = "Arial";
		format.color = 0x000000;
		//format.size = null;
		//format.align = flash.text.TextFormatAlign.RIGHT;

		textField = new flash.text.TextField();
		textField.defaultTextFormat = format;
		if (text != null)
			textField.text = text;
		else
			textField.text = "";
		textField.embedFonts = true;
		textField.autoSize = flash.text.TextFieldAutoSize.LEFT;
		textField.multiline = false;
		textField.selectable = false;
		//textField.mouseEnabled = true;

		addChild(textField);
	}

	public function setText(text : String)
	{
		textField.text = text;
	}

	public function getText() : String
	{
		return textField.text;
	}
	
	public function setTextFormat(format : flash.text.TextFormat)
	{
		textField.defaultTextFormat = format;
	}

}
