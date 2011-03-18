package aux;

class Fader extends flash.events.EventDispatcher
{
	private var m_timer : flash.utils.Timer;
	private var m_displayObject : flash.display.DisplayObject;
	public var startAlpha : Float;
	public var endAlpha : Float;
	public var time : Float; // the complete time the timer must take
	public var timeIncrement : Float; // the increments that the timer should take
	private var m_alphaIncrement : Float;

	public function new(displayObject : flash.display.DisplayObject)
	{
		super();
		m_displayObject = displayObject;
	
		startAlpha = 0.0;
		endAlpha = 1.0;
		timeIncrement = 0.02;
		time = 1.0;

	}
	
	public function start()
	{
		var count = Math.ceil(time/timeIncrement);
		m_alphaIncrement = (endAlpha - startAlpha)/count;
		m_timer = new flash.utils.Timer(timeIncrement, count );
		m_timer.addEventListener(flash.events.TimerEvent.TIMER, tickListener);
		m_timer.addEventListener(flash.events.TimerEvent.TIMER_COMPLETE, finishedListener);
		m_timer.start();
	}

	public function tickListener(event : flash.events.TimerEvent)
	{
		var count = Math.ceil(time/timeIncrement);
		m_displayObject.alpha = startAlpha + event.target.currentCount/count*(endAlpha-startAlpha);
	}

	public function finishedListener(event : flash.events.TimerEvent)
	{
		m_displayObject.alpha = endAlpha;
		dispatchEvent(new flash.events.TimerEvent(flash.events.TimerEvent.TIMER_COMPLETE));
	}
}
