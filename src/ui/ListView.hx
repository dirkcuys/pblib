package ui;

class ListView extends flash.display.MovieClip
{
	private var m_items : Array<ListViewItem>;
	public var layout(default,default) : Layout;

	public function new()
	{
		super();
		m_items = new Array<ListViewItem>();
		layout = new VerticalLayout();
	}

	public function addItem( item : ListViewItem )
	{
		layout.add(item);
		addChild(item);
		item.addEventListener(flash.events.MouseEvent.DOUBLE_CLICK, doubleClickListener);
		item.addEventListener(flash.events.MouseEvent.CLICK, clickListener);
	}

	private function clickListener( event : flash.events.MouseEvent)
	{
		var listViewEvent = new ListViewEvent(ui.ListViewEvent.ITEM_SELECTED);
		listViewEvent.item = event.currentTarget;
		dispatchEvent(listViewEvent);
	}

	private function doubleClickListener( event : flash.events.MouseEvent)
	{	
		var listViewEvent = new ListViewEvent(ui.ListViewEvent.ITEM_DOUBLE_CLICK);
		listViewEvent.item = event.currentTarget;
		dispatchEvent(listViewEvent);
	}
}
