package gallery;

import aux.ProgressBar;

/// loads a picture from an URL and adds the picture as child
class Picture extends flash.display.Sprite
{
	private var pictureURL : String;
	private var progressBar : aux.ProgressBar;
	private var widthHint : Float; /// width used for progress bar
	
	public function new(pictureURL : String, widthHint : Float)
	{
		super();
		this.pictureURL = pictureURL;
		this.widthHint = widthHint;
		
		initialize();
	}

	private function initialize()
	{	
		useHandCursor = true;
		buttonMode = true;
		mouseChildren = false;
		
		var loader = new flash.display.Loader();
		loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loadComplete);
		loader.load(new flash.net.URLRequest(pictureURL));
		
		progressBar = new aux.ProgressBar(widthHint);
		addChild(progressBar);
		loader.contentLoaderInfo.addEventListener(flash.events.ProgressEvent.PROGRESS, loadProgress);
	}

	private function loadComplete(event : flash.events.Event)
	{
		removeChild(progressBar);
		var loader = event.target;
		var picture : flash.display.Bitmap = loader.content;
		picture.smoothing = true;			
		addChild(picture);
		dispatchEvent(new flash.events.Event(flash.events.Event.COMPLETE));
	}
	
	private function loadProgress(event : flash.events.ProgressEvent)
	{
		progressBar.progress = event.target.bytesLoaded/event.target.bytesTotal*100.0;
	}
}
