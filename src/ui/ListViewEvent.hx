package ui;

class ListViewEvent extends flash.events.Event
{
	public static var ITEM_SELECTED : String = "ItemSelected";
	public static var ITEM_DOUBLE_CLICK : String = "ItemDoubleClick";

	public var item(default,default) : ListViewItem;

	public function new(type : String)
	{
		super(type);
	}
}
