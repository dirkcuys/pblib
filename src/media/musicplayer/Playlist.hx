package media.musicplayer;

class Playlist extends flash.events.EventDispatcher
{
	private var m_playlist : Array<Song>;
	private var m_playing : Song;
	private var m_paused : Bool;
	private var m_timer : flash.utils.Timer;

	public var selected(default,default) : Song;

	public function new()
	{
		super();
		m_playlist = new Array<Song>();
		selected = null;
		m_paused = false;
		m_timer = new flash.utils.Timer(1000);

	}

	public function addSong(song : Song)
	{
		m_playlist.push(song);
	}

	public function iterator() : Iterator<Song>
	{
		return m_playlist.iterator();
	}

	/// get the progress of the currently playing song
	public function getProgress() : Float
	{
		if (m_playing == null)
			return 0.0;

		return m_playing.getSongProgress();
	}

	/// set the progress of the currently playing song
	/// pregres in [0.0, 100.0]
	public function setProgress(progress : Float)
	{
		if (m_playing == null)
			return;
		
		if (!m_paused) m_playing.stop();
		m_playing.setSongProgress(progress);
		if (!m_paused) m_playing.playResume();
	}
	
	/// get the load progress of the currently playing song
	public function getLoadProgress() : Float
	{
		if (m_playing == null)
			return 0.0;

		return m_playing.loadProgress;
	}	

	/// set the selected song on the playlist
	public function selectSong(song : Song)
	{
		selected = song;
	}

	/// play the currently selected song
	public function play()
	{
		if (selected == null)
			return;
			
		if (m_paused)
		{
			m_playing.playResume();
			m_paused = false;
		}
		else
		{
			if (!selected.loaded)
			{
				selected.loadSound();
			}
			if (m_playing != null)
			{
				m_playing.stop();
			}
			selected.playResume();
			m_playing = selected;
		}	
	}

	/// stop currently paused or playing song
	public function stop()
	{
		if (m_playing == null)
			return;
		m_playing.stop();
		m_playing = null;
		m_paused = false;
	}

	/// pause currently playing song
	public function pause()
	{
		if (m_playing == null)
			return;
		m_playing.pause();
		m_paused = true;
	}

}
