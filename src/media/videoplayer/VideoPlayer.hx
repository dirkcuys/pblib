package media.videoplayer;

class VideoMetaDataListener implements Dynamic
{
	private var m_videoPlayer : VideoPlayer;
	public function new( videoplayer : VideoPlayer) 
	{
		m_videoPlayer = videoplayer;
	}
	public function onMetaData(obj : Dynamic) 
	{
		//trace(obj.duration);
		m_videoPlayer.duration = obj.duration - 1;
	}
}

class PlayButton extends VideoPlayerButton {}
class PauseButton extends VideoPlayerButton {}
class StopButton extends VideoPlayerButton {}
class CloseButton extends VideoPlayerButton {}

class VideoPlayer extends flash.display.Sprite
{

	private var m_video : flash.media.Video;
	private var m_netStream : flash.net.NetStream;
	private var m_frame : flash.display.Shape;

	private var m_playButton : flash.display.Sprite;
	private var m_pauseButton : flash.display.Sprite;
	private var m_stopButton : flash.display.Sprite;
	private var m_closeButton : flash.display.Sprite;
	private var m_title : ui.TLabel;
	private var m_progressBar : ProgressBar;
	private var m_progressTimer : flash.utils.Timer;
	
	public var duration : Float;

	public function new()
	{
		super();
		duration = 0;
	}

	public function loadFile(url : String, sizeX : Int, sizeY : Int, ?title : String)
	{
		m_frame = new flash.display.Shape();
		m_frame.graphics.beginFill(0x333333);
		var fwidth = sizeX + 20;
		if (fwidth > 1024)
			fwidth = 1024;
		m_frame.graphics.drawRoundRect(0, 0, fwidth, sizeY + 70, 10);
		addChild(m_frame);

		var netConnection = new flash.net.NetConnection();
		netConnection.connect(null);

		m_netStream = new flash.net.NetStream(netConnection);
		m_video = new flash.media.Video(sizeX, sizeY);
		m_video.attachNetStream(m_netStream);
		m_video.width = sizeX;
		m_video.height = sizeY;
		m_video.x = sizeX==1024?0:10;
		m_video.y = 30;
		addChild(m_video);

		m_netStream.client = new VideoMetaDataListener(this);
		m_netStream.play(url);
		m_netStream.seek(0);
		m_netStream.pause();
		m_netStream.togglePause();


		if (title != null)
		{
			m_title = new ui.TLabel();
			var textFormat = new flash.text.TextFormat();
			textFormat.font = "Arial";
			textFormat.size = 18;
			textFormat.color = 0x999999;
			m_title.textField.defaultTextFormat = textFormat;
			m_title.textField.text = title;
			m_title.x = width/2.0 - m_title.width/2.0;
			m_title.y = 2;
			addChild(m_title);
		}

		m_closeButton = new CloseButton();
		m_closeButton.y = 8;
		m_closeButton.x = width - m_closeButton.width - 8;
		m_closeButton.addEventListener(flash.events.MouseEvent.CLICK, closeListener);
		addChild(m_closeButton);

		m_playButton = new PlayButton();
		m_playButton.y = sizeY + 40;
		m_playButton.x = 10;
		m_playButton.addEventListener(flash.events.MouseEvent.CLICK, playListener);
		//addChild(m_playButton);

		m_pauseButton = new PauseButton();
		m_pauseButton.y = sizeY + 40;
		m_pauseButton.x = 10;
		m_pauseButton.addEventListener(flash.events.MouseEvent.CLICK, pauseListener);
		addChild(m_pauseButton);

		m_stopButton = new StopButton();
		m_stopButton.y = sizeY + 40;
		m_stopButton.x = 20 + m_playButton.width;
		m_stopButton.addEventListener(flash.events.MouseEvent.CLICK, stopListener);
		addChild(m_stopButton);

		m_progressBar = new ProgressBar( width - (m_stopButton.x + m_stopButton.width + 20));
		m_progressBar.y = sizeY + 45;
		m_progressBar.x = m_stopButton.x + m_stopButton.width + 10;
		m_progressBar.addEventListener(flash.events.Event.CHANGE, skipListener);
		addChild(m_progressBar);

		flash.Lib.current.stage.addEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyboardListener);

		//m_timeEst = 0;//m_netStream.bytesTotal/(6000000.0/8.0);
		//trace("Estimate length: " + m_timeEst + "s");
		//trace("TotalBytes:" + m_netStream.bytesTotal );

		m_progressTimer = new flash.utils.Timer(1000, 0);
		m_progressTimer.addEventListener(flash.events.TimerEvent.TIMER, progressListener);
		m_progressTimer.start();
	}

	private function playListener(event : flash.events.MouseEvent)
	{
		m_netStream.togglePause();
		removeChild(m_playButton);
		addChild(m_pauseButton);

		//trace("Loaded: " + m_netStream.bytesLoaded / m_netStream.bytesTotal);
		//trace("Estimate length: " + m_netStream.bytesTotal/(6000000.0/8.0) + "s");
		//trace("TotalBytes:" + m_netStream.bytesTotal );
		//m_timeEst = m_netStream.bytesTotal/(6000000.0/8.0);
		m_progressTimer.start();
	}

	private function pauseListener(event : flash.events.MouseEvent)
	{
		m_netStream.togglePause();
		removeChild(m_pauseButton);
		addChild(m_playButton);
		m_progressTimer.stop();
	}

	private function stopListener(event : flash.events.MouseEvent)
	{
		m_netStream.pause();
		m_netStream.seek(0);
		if (contains(m_pauseButton))
		{
			removeChild(m_pauseButton);
			addChild(m_playButton);
		}
		m_progressTimer.stop();
	}

	private function closeListener(event : flash.events.MouseEvent)
	{
		m_netStream.close();
		m_video = null;
		flash.Lib.current.stage.removeEventListener(flash.events.KeyboardEvent.KEY_DOWN, keyboardListener);
		dispatchEvent(new flash.events.Event(flash.events.Event.CLOSE));
	}

	private function skipListener(event : flash.events.Event)
	{
		//trace("Skip to " + m_progressBar.progress/100.0*m_timeEst + "s");
		m_netStream.seek(m_progressBar.progress/100.0*duration);
	}

	private function keyboardListener(event : flash.events.KeyboardEvent)
	{
		if (event.keyCode == flash.ui.Keyboard.RIGHT)
		{
			//m_netStream.pause();
			m_netStream.togglePause();
			m_netStream.seek(m_netStream.time + 2);
			m_netStream.togglePause();
			//m_netStream.play();
			//m_netStream.togglePause();
		}
	}

	private function progressListener(event : flash.events.Event)
	{
		if (duration < 0.001)
			m_progressBar.progress = 0;

		m_progressBar.progress = m_netStream.time/duration*100;
	}

}
