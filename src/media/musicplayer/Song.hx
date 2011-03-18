package media.musicplayer;

/// Class responsible for managing flash.media.Sound class
class Song
{
	/// public properties
	public var url : String;
	public var name : String;
	public var artist : String;
	
	public var loaded(default, null) : Bool;

	public var loadProgress(default, null) : Float;

	private var m_position : Float;
	private var sound : flash.media.Sound;
	private var soundChannel : flash.media.SoundChannel;

	public function new(?url : String, ?name : String, ?artist : String)
	{
		this.url = url;
		this.name = name;
		this.artist = artist;
		
		loaded = false;
		m_position = 0;
		loadProgress = 0.0;
	}

	/// start loading song from location indicated by url or this.url
	public function loadSound(?url : String)
	{
		if (url != null)
			this.url = url;
		
		sound = new flash.media.Sound();
		sound.addEventListener(flash.events.Event.COMPLETE, loadCompleteListener);
		sound.addEventListener(flash.events.IOErrorEvent.IO_ERROR, loadIOErrorListener);
		sound.addEventListener(flash.events.ProgressEvent.PROGRESS, loadProgressListener);
		sound.load(new flash.net.URLRequest(this.url));
	}

	/// called when finished loading Sound
	private function loadCompleteListener(event : flash.events.Event)
	{
		loaded = true;
	}

	/// called when an error occurs while loading Sound
	private function loadIOErrorListener(event : flash.events.IOErrorEvent)
	{
		trace("failed loading sound");
	}
	
	/// called while loading Sound
	private function loadProgressListener(event : flash.events.ProgressEvent)
	{	
		loadProgress = event.bytesLoaded/event.bytesTotal*100.0;
	}

	/// play or resume song
	public function playResume()
	{
		soundChannel = sound.play(m_position);
	}

/*	
	/// start playing song from indicated position
	public function playFrom(startPos : Float)
	{
		stop();
		m_position = startPos;
		playResume();
	}
//*/

	/// pause song and remember last position
	public function pause()
	{
		m_position = soundChannel.position;
		soundChannel.stop();
		//trace("pause at " + position);
	}

	/// stop song and reset position
	public function stop()
	{
		soundChannel.stop();
		m_position = 0;
	}
	
	/// return the percentage of the song completed
	public function getSongProgress()
	{
		if (soundChannel == null || sound == null)
			return 0.0;
			
		return loadProgress*soundChannel.position/sound.length;
	}
	
	/// set song position to correspond to percentage complete
	public function setSongProgress(progress : Float)
	{
		if (soundChannel == null || sound == null || loadProgress == 0.0)
			return;
			
		m_position = progress*sound.length/loadProgress;
	}

}
