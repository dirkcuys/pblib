package ui;

class HorizontalLayout implements Layout
{
	private var m_elements : Array<flash.display.DisplayObject>;
	private var m_padding : Float;

	public function new()
	{
		m_elements = new Array<flash.display.DisplayObject>();
		m_padding = 0;
	}

	public function add(displayObject : flash.display.DisplayObject)
	{
		if (m_elements.length == 0){
			m_elements.push(displayObject);
			return;
		}
		var prev = m_elements[m_elements.length-1];
		displayObject.x = prev.x + prev.width + m_padding;
		m_elements.push(displayObject);
	}

}
