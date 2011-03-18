package ui;

class FixedLayout implements Layout
{
	private var m_nextX : Float;
	private var m_nextY : Float;

	public function new()
	{
		m_nextX = 0;
		m_nextY = 0;
	}

	public function add(displayObject : flash.display.DisplayObject)
	{
		displayObject.y = m_nextY;
		displayObject.x = m_nextX;
	}

	public function setNextPosition(x : Float, y : Float)
	{
		m_nextX = x;
		m_nextY = y;
	}

}
