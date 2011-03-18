package aux;

class ResourceLoader extends flash.display.Loader
{

	public function new(url : String)
	{	
		super();
		//var loaderContext = new flash.system.LoaderContext(false, new flash.system.ApplicationDomain(flash.system.ApplicationDomain.currentDomain));
		contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, loaderComplete);
		contentLoaderInfo.addEventListener(flash.events.IOErrorEvent.IO_ERROR, loaderError);
		load(new flash.net.URLRequest(url));//, loaderContext);
		//addChild(m_loader);
	}

	public function loaderComplete(event : flash.events.Event)
	{
		var loaderInfo = event.target;
		contentLoaderInfo.removeEventListener(flash.events.Event.COMPLETE, loaderComplete);
		contentLoaderInfo.removeEventListener(flash.events.IOErrorEvent.IO_ERROR, loaderError);
	}

	public function loaderError(event : flash.events.Event)
	{
		trace("An error occured while trying to load the swf file");
	}

}
