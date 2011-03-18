package media.musicplayer;

class Skin extends flash.display.Sprite{}
class Heading extends flash.display.Sprite{}
class CloseButton extends MusicPlayerButton{}
class MinimizeButton extends MusicPlayerButton{}
class PlayButton extends MusicPlayerButton{}
class PauseButton extends MusicPlayerButton{}
class StopButton extends MusicPlayerButton{}
class SelectionBar extends flash.display.Sprite{}

class MusicPlayer extends flash.display.Sprite
{
	public var playlist(default, setPlaylist) : Playlist;

	private var m_playlistView : ui.ListView;
	private var m_selectionBar : SelectionBar;
	private var m_timer : flash.utils.Timer;
	private var progressBar : TrackBar;

	public function new()
	{
		super();
		//trace("MusicPlayer::new");
		addChild(new Skin());

		var heading = new Heading();
		heading.x = width/2.0 - heading.width/2.0;
		heading.y = 22;
		addChild(heading);

		var closeButton = new CloseButton();
		closeButton.x = 237;
		closeButton.y = 15;
		addChild(closeButton);
		closeButton.addEventListener(flash.events.MouseEvent.CLICK, closeListener);

		/*var minimizeButton = new MinimizeButton();
		minimizeButton.x = 239;
		minimizeButton.y = 464;
		addChild(minimizeButton);*/

		var playButton = new PlayButton();
		playButton.x = 155;
		playButton.y = 454;
		addChild(playButton);
		playButton.addEventListener(flash.events.MouseEvent.CLICK, playListener);
		
		var pauseButton = new PauseButton();
		pauseButton.x = 127;
		pauseButton.y = 454;
		addChild(pauseButton);
		pauseButton.addEventListener(flash.events.MouseEvent.CLICK, pauseListener);

		var stopButton = new StopButton();
		stopButton.x = 95;
		stopButton.y = 454;
		addChild(stopButton);
		stopButton.addEventListener(flash.events.MouseEvent.CLICK, stopListener);

		progressBar = new TrackBar();
		progressBar.x = 17;
		progressBar.y = 432;
		progressBar.addEventListener(flash.events.Event.CHANGE, progressChangeListener);
		addChild(progressBar);
		
		m_selectionBar = new SelectionBar();
		m_selectionBar.alpha = 0;
		m_selectionBar.x = 18;
		addChild(m_selectionBar);

		m_playlistView = new ui.ListView();
		m_playlistView.x = 30;
		m_playlistView.y = 70;
		addChild(m_playlistView);
		m_playlistView.addEventListener(ui.ListViewEvent.ITEM_SELECTED, selectListener);
		m_playlistView.addEventListener(ui.ListViewEvent.ITEM_DOUBLE_CLICK, selectAndPlayListener);

		m_timer = new flash.utils.Timer(100, 0);
		m_timer.addEventListener(flash.events.TimerEvent.TIMER, progressTimer);

	}

	public function setPlaylist(playlist : Playlist) : Playlist
	{
		//trace("MusicPlayer::setPlaylist");
		this.playlist = playlist;

		var textFormat = new flash.text.TextFormat();
		textFormat.font = "Arial";
		textFormat.size = 16;

		var cnt : Int = 1;
		for (song in this.playlist.iterator())
		{
			var item = new ui.ListViewItem(cnt + ". " + song.name, song);
			item.setTextFormat(textFormat);
			item.label = cnt + ". " + song.name;
			m_playlistView.addItem(item);
			++cnt;
		}

		return this.playlist;
	}

	private function progressChangeListener(event : flash.events.Event)
	{
		//trace("Progress Changed:" + progressBar.progress);
		playlist.setProgress(progressBar.progress);
		progressBar.progress = playlist.getProgress();
	}

	private function progressTimer(evnt : flash.events.Event)
	{
		progressBar.progress = playlist.getProgress();
		progressBar.loadProgress = playlist.getLoadProgress();
	}

	private function selectListener(event : ui.ListViewEvent)
	{
		playlist.selected = event.item.data;
		m_selectionBar.y = m_playlistView.y + event.item.y;
		m_selectionBar.alpha = 1.0;
	}

	private function selectAndPlayListener(event : ui.ListViewEvent)
	{
		playlist.selected = event.item.data;
		m_selectionBar.y = m_playlistView.y + event.item.y;
		m_selectionBar.alpha = 1.0;
		playlist.stop();
		playlist.play();
		m_timer.start();
	}

	private function playListener(event : flash.events.Event)
	{
		//trace("Play");
		if (playlist == null)
			return;

		playlist.play();
		m_timer.start();
	}

	private function stopListener(event : flash.events.Event)
	{
		//trace("Stop");
		if (playlist == null)
			return;

		playlist.stop();
		m_timer.stop();
		progressBar.progress = 0;
	}

	private function pauseListener(event : flash.events.Event)
	{
		//trace("Pause");
		if (playlist == null)
			return;
		playlist.pause();
		m_timer.stop();
	}

	private function closeListener(event : flash.events.Event)
	{
		//trace("Close");
		dispatchEvent(new flash.events.Event(flash.events.Event.CLOSE));
		if (playlist != null)
			playlist.stop();
		m_timer.stop();
	}

}
