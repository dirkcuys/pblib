package aux;

class DefaultTButton extends ui.TButton
{
	public function new(label : String)
	{
		super();

		var textFormat = new flash.text.TextFormat();
		textFormat.font = "Courier";
		textFormat.color = 0xFFFFFF;
		textFormat.size = 22;

		setTextFormat(textFormat);
		setText(label);
	}
}
